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
  ; cond
  %5 = load i32, i32* %1
  %6 = icmp slt i32 %5, 3
  br i1 %6, label %8, label %12
7:
  ; post
  br label %4
8:
  ; block
  %9 = load i32, i32* %1
  call void  @Print(i32 %9)
  %10 = load i32, i32* %1
  %11 = add i32 %10, 1
  store i32 %11, i32* %1
  br label %4
12:
  ; end
  br label %13
13:
  ret void 
}

