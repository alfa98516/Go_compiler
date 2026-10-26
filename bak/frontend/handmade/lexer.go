package handmade

import (
	"strings"
	"unicode"

	. "Grobbit/common"
)

type Lexer struct {
	src          []rune
	n            int
	i            int
	ch           rune
	eoi          bool
	token        Token
	pos          Position
	errorHandler ErrorHandler
}

var charEscapeSet = map[rune]bool{
	't':  true,
	'n':  true,
	'\\': true,
	'\'': true,
}

var stringEscapeSet = map[rune]bool{
	't':  true,
	'n':  true,
	'\\': true,
	'"':  true,
}

///////////////////// Helper functions ////////////////////////////

func (lexer *Lexer) peekRune() (rune, bool) {
	if lexer.eoi || lexer.i+1 >= lexer.n {
		return rune(0), true
	}
	return lexer.src[lexer.i+1], false
}

func (lexer *Lexer) peekRuneIs(check rune) bool {
	r, err := lexer.peekRune()
	return !err && r == check
}

func (lexer *Lexer) nextRune() {
	if lexer.eoi {
		return
	}
	lexer.i++
	if lexer.i >= lexer.n {
		lexer.ch, lexer.eoi = rune(0), true
		return
	}
	ch := lexer.src[lexer.i]
	if ch == '\n' { // Note: '\r'
		lexer.pos.Line += 1
		lexer.pos.Col = -1
	}
	lexer.pos.Col += 1
	lexer.ch, lexer.eoi = ch, false
}

type pair struct {
	r rune
	t TokenType
}

/*
 * @brief This function is my baby, I'm really proud of it
 * The original given setToken function didnt work correctly, what this one does is it continuously makes a guess for what the current token is.
 * if we get "&", and the next char is '^', we send setToken all possible outcomes from that token:
 * setToken(TtOpBitXor, pair{'^', TtOpBitAndNot}, pair{'=', TtOpBitAndNotAssign})
 * From this, the function checks what the next rune is, and continuously guesses what the token might be, until there's no doubt about what it is.
 */
func (lexer *Lexer) setToken(Tt TokenType, pairs ...pair) {
	lenpairs := len(pairs)
	nextR, _ := lexer.peekRune()
	// we check here if the next rune is actually equal to the first rune in the pairs.
	// this is so we dont consume unnecessary tokens
	if lenpairs == 0 || (lenpairs > 0 && (pairs[0].r != nextR)) {
		lexer.token = Token{Type: Tt, Lexeme: string(lexer.ch), Pos: lexer.pos}
		lexer.nextRune()
		lexer.token.PosEnd = lexer.pos
	} else {
		startChar, startPos := lexer.ch, lexer.pos
		lexer.nextRune()
		if !lexer.eoi {
			lexer.token = Token{Type: Tt, Lexeme: string(startChar), Pos: lexer.pos}
			for _, p := range pairs {
				if lexer.ch == p.r {
					lexer.token = Token{Type: p.t, Lexeme: lexer.token.Lexeme + string(lexer.ch), Pos: startPos} // continueously concatinate the lexeme and current character.
					lexer.nextRune()
					lexer.token.PosEnd = lexer.pos
					continue
				}
			}
		}
	}
}

func (lexer *Lexer) identifier() string {
	var builder strings.Builder
	for { // not good practice to do this obviously, but i couldnt find a comfortable breaking point that could be calculated at start of loop
		builder.WriteRune(lexer.ch)
		nextR, _ := lexer.peekRune()
		if unicode.IsLetter(nextR) || nextR == '_' ||
			unicode.IsDigit(nextR) {
			lexer.nextRune()
		} else {
			break
		}
	}
	return builder.String()
}

/* @brief chimera of a function, do not do this.
 * Handles floats, ints, exponents, imaginaries, runes and strings.
 * This is too much load for one function and we would've done it differently if we had the chance
 */
func (lexer *Lexer) buildFunc(ru rune, digit bool, ps Position) (string, TokenType) {
	ttype := TtString
	builder := strings.Builder{}
	floa := false
	exp := false
	if digit {
		ttype = TtInt
		if lexer.ch == '.' {
			floa = true
			ttype = TtFloat
			builder.WriteRune(lexer.ch)
			lexer.nextRune()
		}
		for !lexer.eoi && (unicode.IsDigit(lexer.ch) ||
			(lexer.peekRuneIs('.') && !floa)) ||
			(floa && (lexer.ch == 'E' || lexer.ch == 'e')) ||
			((floa && exp) && lexer.ch == '+') || lexer.ch == 'i' {

			if lexer.ch == 'i' {
				builder.WriteRune(lexer.ch)
				ttype = TtImag
				lexer.nextRune()
				return builder.String(), ttype

			}
			if lexer.ch == 'e' || lexer.ch == 'E' {
				exp = true
			}
			if lexer.peekRuneIs(rune('.')) && !floa {
				builder.WriteRune(lexer.ch)
				lexer.nextRune()
				builder.WriteRune(lexer.ch)
				lexer.nextRune()
				// the reason we consum and write so much is because if we dont, it writes not enough runes
				// it makes no sense, but this works, i dont know why it does this, but consuming two more than seemingly necessary seems to work
				floa = true
				ttype = TtFloat
			} else {
				builder.WriteRune(lexer.ch)
				lexer.nextRune()
			}
		}
		return builder.String(), ttype
	}
	for !lexer.eoi && !lexer.peekRuneIs(ru) {
		if lexer.peekRuneIs('\n') {
			lexer.errorHandler(ps, "string literal not terminated") // error message copied directly from builtin
			break
		}
		builder.WriteRune(lexer.ch)
		lexer.nextRune()
	}
	builder.WriteRune(lexer.ch)
	lexer.nextRune()
	if lexer.ch != '\n' {
		builder.WriteRune(lexer.ch)
	}
	lexer.nextRune()
	return builder.String(), ttype
}

func (lexer *Lexer) resetToken(Tt TokenType) {
	lexer.token = Token{Type: Tt, Lexeme: lexer.token.Lexeme + string(lexer.ch), Pos: lexer.token.Pos}
	lexer.nextRune()
	lexer.token.PosEnd = lexer.pos
}

func (lexer *Lexer) processWhiteSpaces() bool {
	n := 0
	for !lexer.eoi && unicode.IsSpace(lexer.ch) {
		n += 1
		lexer.nextRune()
	}
	return n > 0
}

///////////////////// Public functions ////////////////////////////

// Init function initialises the lexical analysis.
func (lexer *Lexer) Init(src []byte, handler ErrorHandler) {
	str := []rune(string(src))                               // Fix: cast to string
	lexer.src, lexer.n, lexer.i = []rune(str), len(str), -1. // Fix: len of str
	lexer.eoi = false
	lexer.pos = Position{Line: 1, Col: 0}
	lexer.errorHandler = handler
	lexer.nextRune()
}

// NextToken reads and returns the next token.
func (lexer *Lexer) NextToken() Token {
	for lexer.processWhiteSpaces() {
		// Nothing ...
	}

	if lexer.eoi {
		lexer.setToken(TtEOI)
		return lexer.token
	}

	for lexer.ch == '/' && lexer.peekRuneIs(rune('/')) {
		// loop continuously until all consecutive comments are done
		for lexer.ch != '\n' {
			lexer.nextRune()
		}
		lexer.nextRune()
	}

	for lexer.processWhiteSpaces() {
	}

	if lexer.eoi {
		lexer.setToken(TtEOI)
		return lexer.token
	}

	switch lexer.ch {
	case '+':
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpAdd, pair{'=', TtOpAddAssign})
		} else if lexer.peekRuneIs(rune('+')) {
			lexer.setToken(TtOpAdd, pair{'+', TtOpInc})
		} else {
			lexer.setToken(TtOpAdd)
		}

	case '-':
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpSub, pair{'=', TtOpSubAssign})
		} else if lexer.peekRuneIs(rune('-')) {
			lexer.setToken(TtOpSub, pair{'-', TtOpDec})
		} else {
			lexer.setToken(TtOpSub)
		}

	case '*':
		lexer.setToken(TtOpMul, pair{'=', TtOpMulAssign})

	case '/':
		lexer.setToken(TtOpDiv, pair{'=', TtOpDivAssign})

	case '%':
		lexer.setToken(TtOpMod, pair{'%', TtOpModAssign})

	case '&':
		if lexer.peekRuneIs(rune('^')) {
			//lexer.setToken(TtOpBitAnd, pair{'^', TtOpBitAndNot})
			lexer.setToken(TtOpBitAnd, pair{'^', TtOpBitAndNot}, pair{'=', TtOpBitAndNotAssign})
		} else if lexer.peekRuneIs(rune('&')) {
			lexer.setToken(TtOpBitAnd, pair{'&', TtOpAnd})
		} else {
			lexer.setToken(TtOpBitAnd, pair{'=', TtOpBitAndAssign})
		}

	case '|':
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpBitOr, pair{'=', TtOpBitOrAssign})
		} else {
			lexer.setToken(TtOpBitOr, pair{'|', TtOpOr})
		}

	case '^':
		lexer.setToken(TtOpBitXor, pair{'=', TtOpBitXorAssign})

	case '<':
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpLt, pair{'=', TtOpLe})
		} else {
			lexer.setToken(TtOpLt, pair{'<', TtOpBitShl}, pair{'=', TtOpBitShlAssign})
		}

	case '>':
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpGt, pair{'=', TtOpGe})
		} else {
			lexer.setToken(TtOpGt, pair{'>', TtOpBitShr}, pair{'=', TtOpBitShrAssign})
		}

	case '=':
		lexer.setToken(TtOpAssign, pair{'=', TtOpEq})

	case '!':
		lexer.setToken(TtOpNot, pair{'=', TtOpNe})

	case '(':
		lexer.setToken(TtLParen)

	case '[':
		lexer.setToken(TtLBracket)

	case '{':
		lexer.setToken(TtLBrace)

	case ',':
		lexer.setToken(TtComma)

	case '.':
		nextRune, _ := lexer.peekRune()
		if lexer.peekRuneIs('.') {
			if lexer.eoi || lexer.i+2 >= lexer.n {
				lexer.setToken(TtPeriod)
			} else {
				if lexer.src[lexer.i+2] == '.' {
					lexer.setToken(TtPeriod, pair{'.', TtPeriod}, pair{'.', TtOpEllipsis})
				} else {
					lexer.setToken(TtPeriod)
				}
			}
		} else if unicode.IsDigit(nextRune) {
			startPos := lexer.pos
			builder, ttype := lexer.buildFunc(lexer.ch, true, lexer.pos)
			lexer.token = Token{Type: ttype, Lexeme: builder, Pos: startPos}
		} else {
			lexer.setToken(TtPeriod)
		}

	case ')':
		lexer.setToken(TtRParen)

	case ']':
		lexer.setToken(TtRBracket)

	case '}':
		lexer.setToken(TtRBrace)

	case ';':
		lexer.setToken(TtSemicolon)

	case ':':
		lexer.setToken(TtColon, pair{'=', TtOpDefine})

	case '~':
		lexer.setToken(TtTilde)

	case '"':
		startPos := lexer.pos
		builder, _ := lexer.buildFunc('"', false, lexer.pos)
		lexer.token = Token{Type: TtString, Lexeme: builder, Pos: startPos}

	case '\'':
		startPos := lexer.pos
		builder, _ := lexer.buildFunc('\'', false, lexer.pos)
		if len(builder) != 3 {
			lexer.errorHandler(startPos, "illegal rune literal")
		}
		lexer.token = Token{Type: TtChar, Lexeme: builder, Pos: startPos}

	default:
		if unicode.IsLetter(lexer.ch) || lexer.ch == '_' {
			ps := lexer.pos
			lexeme := lexer.identifier()
			lexer.setToken(Lookup(lexeme))
			lexer.token.Pos = ps
			lexer.token.Lexeme = lexeme
		} else if unicode.IsDigit(lexer.ch) {
			startPos := lexer.pos
			builder, ttype := lexer.buildFunc(lexer.ch, true, lexer.pos)
			lexer.token = Token{Type: ttype, Lexeme: builder, Pos: startPos}
		} else {
			lexer.setToken(TtUnknown)
		}
	}
	return lexer.token
}
