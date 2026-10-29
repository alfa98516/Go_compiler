; Available external functions.
declare void @Print(i32)
declare void @PrintN(i32, ...)
declare void @Print_F(double)
declare void @PrintN_F(i32, ...)


define void @hi() {
0:
  %1 = alloca i32
  br label %2
2:
  store i32 0, i32* %1
  br label %3
3:
  br label %4
4:
  ret void 
}

