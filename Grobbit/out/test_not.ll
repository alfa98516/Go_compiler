; Available external functions.
declare void @Print(i32)
declare void @PrintN(i32, ...)
declare void @Print_F(double)
declare void @PrintN_F(i32, ...)


define void @main_Grobbit_16__() {
0:
  %1 = alloca i1
  br label %2
2:
  br label %3
3:
  store i1 true, i1* %1
  br label %4
4:
  ; cond
  %5 = load i1, i1* %1
  %6 = icmp eq i1 %5, 0
  br i1 %6, label %7, label %8
7:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 0)
  br label %9
8:
  ; else
  call void (i32, ...) @PrintN(i32 1, i32 1)
  br label %9
9:
  ; end
  br label %10
10:
  ret void 
}

