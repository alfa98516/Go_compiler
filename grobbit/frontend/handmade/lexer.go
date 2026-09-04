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

func (lexer *Lexer) setToken(Tt TokenType, pairs ...pair) {
	lenpairs := len(pairs)
	nextR, _ := lexer.peekRune()
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
					lexer.token = Token{Type: p.t, Lexeme: lexer.token.Lexeme + string(lexer.ch), Pos: startPos}
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

	for {

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

func (lexer *Lexer) buildFunc(ru rune, digit bool) (string, TokenType) {
	ttype := TtString
	builder := strings.Builder{}
	floa := false
	if digit {
		ttype = TtInt
		for !lexer.eoi && (unicode.IsDigit(lexer.ch) || (lexer.peekRuneIs('.') && !floa)) {
			if lexer.peekRuneIs(rune('.')) && !floa {
				builder.WriteRune(lexer.ch)
				lexer.nextRune()
				builder.WriteRune(lexer.ch)
				lexer.nextRune()
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
		builder.WriteRune(lexer.ch)
		lexer.nextRune()
	}
	builder.WriteRune(lexer.ch)
	lexer.nextRune()
	builder.WriteRune(lexer.ch)
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
	lexer.src, lexer.n, lexer.i = []rune(string(src)), len(src), -1
	lexer.eoi = false
	lexer.pos = Position{Line: 1, Col: 0}
	lexer.errorHandler = handler
	lexer.nextRune()
}

// NextToken reads and returns the next token.
func (lexer *Lexer) NextToken() Token {
	// TODO: Modify the code in here.

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
	// TODO: FLOAT
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
		// DONE
		lexer.setToken(TtOpDiv, pair{'=', TtOpDivAssign})

	case '%':
		// DONE
		lexer.setToken(TtOpMod, pair{'%', TtOpModAssign})

	case '&':
		// DONE
		if lexer.peekRuneIs(rune('^')) {
			//lexer.setToken(TtOpBitAnd, pair{'^', TtOpBitAndNot})
			lexer.setToken(TtOpBitAnd, pair{'^', TtOpBitAndNot}, pair{'=', TtOpBitAndNotAssign})
		} else if lexer.peekRuneIs(rune('&')) {
			lexer.setToken(TtOpBitAnd, pair{'&', TtOpAnd})
		} else {
			lexer.setToken(TtOpBitAnd, pair{'=', TtOpBitAndAssign})
		}

	case '|':
		// DONE
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpBitOr, pair{'=', TtOpBitOrAssign})
		} else {
			lexer.setToken(TtOpBitOr, pair{'|', TtOpOr})
		}

	case '^':
		// DONE
		lexer.setToken(TtOpBitXor, pair{'=', TtOpBitXorAssign})

	case '<':
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpLt, pair{'=', TtOpLe})
		} else {
			lexer.setToken(TtOpLt, pair{'<', TtOpBitShl}, pair{'=', TtOpBitShlAssign})
		}

	case '>':
		// DONE
		if lexer.peekRuneIs(rune('=')) {
			lexer.setToken(TtOpGt, pair{'=', TtOpGe})
		} else {
			lexer.setToken(TtOpGt, pair{'>', TtOpBitShr}, pair{'=', TtOpBitShrAssign})
		}

	case '=':
		// DONE
		lexer.setToken(TtOpAssign, pair{'=', TtOpEq})

	case '!':
		// DONE
		lexer.setToken(TtOpNot, pair{'=', TtOpNe})

	case '(':
		// DONE
		lexer.setToken(TtLParen)

	case '[':
		// DONE
		lexer.setToken(TtLBracket)

	case '{':
		// DONE
		lexer.setToken(TtLBrace)

	case ',':
		// DONE
		lexer.setToken(TtComma)

	case '.':
		// TODO: ...
		// fuck this fucking case i hate this thing
		lexer.setToken(TtPeriod, pair{'.', TtPeriod}, pair{'.', TtOpEllipsis})

	case ')':
		// DONE
		lexer.setToken(TtRParen)

	case ']':
		// DONE
		lexer.setToken(TtRBracket)

	case '}':
		// DONE
		lexer.setToken(TtRBrace)

	case ';':
		// DONE
		lexer.setToken(TtSemicolon)

	case ':':
		// DONE
		lexer.setToken(TtColon, pair{'=', TtOpDefine})

	case '~':
		// DONE
		lexer.setToken(TtTilde)

	case '"':
		startPos := lexer.pos
		builder, _ := lexer.buildFunc('"', false)
		lexer.token = Token{Type: TtString, Lexeme: builder, Pos: startPos}

	case '\'':
		startPos := lexer.pos
		builder, _ := lexer.buildFunc('\'', false)
		lexer.token = Token{Type: TtChar, Lexeme: builder, Pos: startPos}

	default:
		if unicode.IsLetter(lexer.ch) || lexer.ch == '_' {
			lexeme := lexer.identifier()
			lexer.setToken(Lookup(lexeme))
			lexer.token.Lexeme = lexeme
		} else if unicode.IsDigit(lexer.ch) {
			startPos := lexer.pos
			builder, ttype := lexer.buildFunc(lexer.ch, true)
			lexer.token = Token{Type: ttype, Lexeme: builder, Pos: startPos}
		} else {
			lexer.setToken(TtUnknown)
		}
	}
	return lexer.token
}
