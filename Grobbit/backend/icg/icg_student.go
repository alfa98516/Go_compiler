package icg

import (
	"Grobbit/backend/icg/llvm"
	. "Grobbit/common"
)

var mapIArthOp = []llvm.IArithmeticOperator{
	TtOpAdd: llvm.Add,
	TtOpSub: llvm.Sub,
	TtOpMul: llvm.Mul,
	TtOpDiv: llvm.Div,
	TtOpMod: llvm.Mod,
}

var mapICmpOp = []llvm.ICmpOperator{
	TtOpEq: llvm.Eq,
	TtOpNe: llvm.Ne,
	TtOpGt: llvm.Sgt,
	TtOpGe: llvm.Sge,
	TtOpLt: llvm.Slt,
	TtOpLe: llvm.Sle,
}

var mapFArthOp = []llvm.FArithmeticOperator{
	TtOpAdd: llvm.FOpAdd,
	TtOpSub: llvm.FOpSub,
	TtOpMul: llvm.FOpMul,
	TtOpDiv: llvm.FOpDiv,
}

var mapFCmpOp = []llvm.FCmpOperator{
	TtOpEq: llvm.FCmpEq,
	TtOpNe: llvm.FCmpNe,
	TtOpGt: llvm.FCmpGt,
	TtOpGe: llvm.FCmpGe,
	TtOpLt: llvm.FCmpLt,
	TtOpLe: llvm.FCmpLe,
}

/*
ArithmeticOp implements a code for the arithmetic operators ( + - * / % ).
Returns a llvm value (llvm.Operand) with the result.
*/
func ArithmeticOp(v *IRVisitor, node *BinaryExprNode) llvm.Operand {
	v.visit(node.Lhs)
	lhsOp := v.ir.exprOperand // Sub-expression returns register where result stored via v.ir.exprOperand
	v.visit(node.Rhs)
	rhsOp := v.ir.exprOperand
	var operand *llvm.Register
	if node.GetType().String() == "float64" {
		operand = v.ir.activeBlock.Append(llvm.NewFArithmeticInstr(mapFArthOp[node.Tok.Type], lhsOp, rhsOp))
	} else {
		operand = v.ir.activeBlock.Append(llvm.NewIArithmeticInstr(mapIArthOp[node.Tok.Type], lhsOp, rhsOp))
	}
	return operand
}

/*
ComparisonOp implements a code for the comparison operators (==, !=, <= <, > >=).
Returns a llvm value (llvm.Operand) with the result.
*/
func ComparisonOp(v *IRVisitor, node *BinaryExprNode) llvm.Operand {
	// TO DO: add your do here (replacing dummy placeholder below).
	v.visit(node.Lhs)
	lhsOp := v.ir.exprOperand
	v.visit(node.Rhs)
	rhsOp := v.ir.exprOperand
	var operand *llvm.Register
	if node.GetType().String() == "float64" {
		operand = v.ir.activeBlock.Append(llvm.NewFCmpInstr(mapFCmpOp[node.Tok.Type], lhsOp, rhsOp))
	} else {
		operand = v.ir.activeBlock.Append(llvm.NewICmpInstr(mapICmpOp[node.Tok.Type], lhsOp, rhsOp))
	}

	return operand
}

/*
LogicalNotOp implements a code for the logical not operator.
Returns a llvm value (llvm.Operand) with the result.
*/
func LogicalNotOp(v *IRVisitor, node *UnaryExprNode) llvm.Operand {
	v.visit(node.Expr)
	value := v.ir.exprOperand
	var not_operator *llvm.Register
	not_operator = v.ir.activeBlock.Append(llvm.NewICmpInstr(llvm.Eq, value, llvm.NewLiteral(llvm.I1, "0")))
	return not_operator
}

/*
LogicalOrOp implements a short-circuit code for the logical or operator.
Returns a llvm value (llvm.Operand) with the result.
*/
func LogicalOrOp(v *IRVisitor, node *BinaryExprNode) llvm.Operand {

	merge_label, rhs_label := llvm.NewLabel(), llvm.NewLabel()
	v.visit(node.Lhs)
	lhsOp := v.ir.exprOperand
	lhs_block := v.ir.activeBlock.Get()
	lhs_block.Close(llvm.NewBranchCondInstr(lhsOp, merge_label, rhs_label))
	rhs_block := v.ir.function.Append(llvm.NewBlock(rhs_label, "or_rhs"))
	v.ir.activeBlock.Set(rhs_block)
	v.visit(node.Rhs)
	rhsOp := v.ir.exprOperand

	rhs_block = v.ir.activeBlock.Get()
	rhs_block.Close(llvm.NewBranchInstr(merge_label))

	merge_block := v.ir.function.Append(llvm.NewBlock(merge_label, "or_end"))
	v.ir.activeBlock.Set(merge_block)
	var operator *llvm.Register
	operator = merge_block.Append(llvm.NewPhiInstr(llvm.I1, llvm.ValueLabel{Op: llvm.NewLiteral(llvm.I1, "1"), Label: lhs_block.GetLabel()}, llvm.ValueLabel{Op: rhsOp, Label: rhs_block.GetLabel()}))

	return operator
}

/*
LogicalAndOp implements a short-circuit code for the logical and operator.
Returns a llvm value (llvm.Operand) with the result.
*/
func LogicalAndOp(v *IRVisitor, node *BinaryExprNode) llvm.Operand {
	// TO DO: add your do here (replacing dummy placeholder below).merge_label, rhs_label := llvm.NewLabel(), llvm.NewLabel()

	merge_label, rhs_label := llvm.NewLabel(), llvm.NewLabel()
	v.visit(node.Lhs)
	lhsOp := v.ir.exprOperand
	lhs_block := v.ir.activeBlock.Get()
	lhs_block.Close(llvm.NewBranchCondInstr(lhsOp, rhs_label, merge_label))
	rhs_block := v.ir.function.Append(llvm.NewBlock(rhs_label, "and_rhs"))
	v.ir.activeBlock.Set(rhs_block)
	v.visit(node.Rhs)
	rhsOp := v.ir.exprOperand

	rhs_block = v.ir.activeBlock.Get()
	rhs_block.Close(llvm.NewBranchInstr(merge_label))

	merge_block := v.ir.function.Append(llvm.NewBlock(merge_label, "and_end"))
	v.ir.activeBlock.Set(merge_block)
	var operator *llvm.Register
	operator = merge_block.Append(llvm.NewPhiInstr(llvm.I1, llvm.ValueLabel{Op: llvm.NewLiteral(llvm.I1, "0"), Label: lhs_block.GetLabel()}, llvm.ValueLabel{Op: rhsOp, Label: rhs_block.GetLabel()}))

	return operator

}

/*
	 ForStmt:
	 VisitForStmtNode generates following blocks:

		   Upon entering:
				current:				<-- ir.activeBlock
					...
					nil (block is open, does not have terminal instruction yet)

		   Upon exiting:
				current:
					...
					<init_stmts>
					'br cond' (if cond) else 'br body'
			   [ cond:
					op = <cond_expr>
					br op body end ]
		      [	post:
					...
					'br cond' (if cond) else 'br body' ]
		     	body:
					<body_stmt>
					'br post' (if post) else 'br cond' (if cond) or 'br body'
		     	end:					<-- ir.activeBlock
					nil (block is open, does not have terminal instruction yet)
*/
func ForStmt(v *IRVisitor, node *ForStmtNode) {
	// TO DO: add your do here (replacing dummy placeholder below).
}
