; Available external functions.
declare void @Print(i32)
declare void @PrintN(i32, ...)
declare void @Print_F(double)
declare void @PrintN_F(i32, ...)


define void @multiplication(i32 %0, i32 %1) {
2:
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  br label %6
6:
  store i32 %0, i32* %3
  store i32 %1, i32* %4
  br label %7
7:
  %8 = load i32, i32* %3
  %9 = load i32, i32* %4
  %10 = mul i32 %8, %9
  store i32 %10, i32* %5
  %11 = load i32, i32* %5
  call void  @Print(i32 %11)
  br label %12
12:
  ret void 
}

define void @main_Grobbit_16__() {
0:
  %1 = alloca i32
  %2 = alloca i32
  br label %3
3:
  br label %4
4:
  store i32 5, i32* %1
  store i32 3, i32* %2
  %5 = load i32, i32* %1
  %6 = load i32, i32* %2
  call void  @multiplication(i32 %5, i32 %6)
  br label %7
7:
  ret void 
}

