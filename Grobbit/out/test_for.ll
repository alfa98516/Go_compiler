; Available external functions.
declare void @Print(i32)
declare void @PrintN(i32, ...)
declare void @Print_F(double)
declare void @PrintN_F(i32, ...)


define void @main_Grobbit_16__() {
0:
  %1 = alloca i32
  br label %2
2:
  br label %3
3:
  store i32 0, i32* %1
  br label %4
4:
  ; block
  br label %5
5:
  ; cond
  %6 = load i32, i32* %1
  %7 = icmp sgt i32 %6, 3
  br i1 %7, label %8, label %9
8:
  ; then
  br label %10
9:
  ; end
  br label %4
10:
  ; end
  br label %11
11:
  ret void 
}

