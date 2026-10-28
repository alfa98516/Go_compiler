; Available external functions.
declare void @Print(i32)
declare void @PrintN(i32, ...)
declare void @Print_F(double)
declare void @PrintN_F(i32, ...)


@g_x = global i1 true

@g_c1 = constant i32 5

@g_y = global i32 20

@g_z = global i32 30

@g_x2 = global i32 0

@g_x3 = global i32 0

define i32 @foo(i32 %0, i32 %1, i32 %2) {
3:
  %4 = alloca i32
  %5 = alloca i32
  %6 = alloca i32
  %7 = alloca i32
  %8 = alloca i32
  %9 = alloca i32
  %10 = alloca i32
  %11 = alloca i32
  %12 = alloca i32
  %13 = alloca i32
  br label %14
14:
  store i32 0, i32* %4
  store i32 %0, i32* %5
  store i32 %1, i32* %6
  store i32 %2, i32* %7
  store i32 100, i32* %8
  store i32 1, i32* %9
  br label %15
15:
  %16 = load i32, i32* %5
  %17 = load i32, i32* %6
  %18 = load i32, i32* %7
  %19 = load i32, i32* %8
  %20 = load i32, i32* %9
  call void (i32, ...) @PrintN(i32 5, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20)
  store i32 30, i32* %10
  %21 = load i32, i32* %10
  call void  @Print(i32 %21)
  store i32 40, i32* %10
  %22 = load i32, i32* %10
  call void  @Print(i32 %22)
  store i32 10, i32* %6
  store i32 20, i32* %7
  store i32 1, i32* %11
  store i32 2, i32* %12
  %23 = load i32, i32* %6
  %24 = load i32, i32* %7
  %25 = load i32, i32* %11
  %26 = load i32, i32* %12
  call void (i32, ...) @PrintN(i32 4, i32 %23, i32 %24, i32 %25, i32 %26)
  br label %27
27:
  ; cond
  %28 = load i32, i32* %5
  %29 = icmp sgt i32 %28, 10
  br i1 %29, label %30, label %31
30:
  ; then
  store i32 20, i32* %5
  br label %38
31:
  ; else
  br label %32
32:
  ; cond
  %33 = load i32, i32* %5
  %34 = icmp sgt i32 %33, 20
  br i1 %34, label %35, label %36
35:
  ; then
  store i32 30, i32* %5
  br label %37
36:
  ; else
  store i32 40, i32* %5
  br label %37
37:
  ; end
  br label %38
38:
  ; end
  %39 = load i32, i32* %5
  call void  @Print(i32 %39)
  store i32 100, i32* %13
  br label %40
40:
  ; cond
  %41 = load i32, i32* %13
  %42 = icmp sgt i32 %41, 0
  br i1 %42, label %43, label %45
43:
  ; then
  %44 = load i32, i32* %13
  call void  @Print(i32 %44)
  br label %45
45:
  ; end
  %46 = load i32, i32* %5
  call void  @Print(i32 %46)
  store i32 1, i32* %4
  br label %47
47:
  %48 = load i32, i32* %4
  ret i32 %48
}

@g_x1 = global i32 0

@g_y1 = global i32 0

@g_z1 = global i32 0

define i32 @TestIf(i32 %0, i32 %1) {
2:
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  %6 = alloca i32
  br label %7
7:
  store i32 0, i32* %3
  store i32 %0, i32* %4
  store i32 %1, i32* %5
  store i32 0, i32* %6
  br label %8
8:
  br label %9
9:
  ; cond
  %10 = load i32, i32* %4
  %11 = load i32, i32* %5
  %12 = icmp sgt i32 %10, %11
  br i1 %12, label %13, label %17
13:
  ; then
  %14 = load i32, i32* %6
  %15 = load i32, i32* %4
  %16 = add i32 %14, %15
  store i32 %16, i32* %6
  br label %17
17:
  ; end
  br label %18
18:
  ; cond
  %19 = load i32, i32* %4
  %20 = load i32, i32* %5
  %21 = icmp eq i32 %19, %20
  br i1 %21, label %22, label %27
22:
  ; then
  %23 = load i32, i32* %6
  %24 = load i32, i32* %4
  %25 = mul i32 2, %24
  %26 = add i32 %23, %25
  store i32 %26, i32* %6
  br label %32
27:
  ; else
  %28 = load i32, i32* %6
  %29 = load i32, i32* %5
  %30 = mul i32 3, %29
  %31 = add i32 %28, %30
  store i32 %31, i32* %6
  br label %32
32:
  ; end
  br label %33
33:
  ; cond
  %34 = load i32, i32* %4
  %35 = load i32, i32* %5
  %36 = sub i32 %35, 2
  %37 = icmp slt i32 %34, %36
  br i1 %37, label %38, label %43
38:
  ; then
  %39 = load i32, i32* %6
  %40 = load i32, i32* %4
  %41 = mul i32 10, %40
  %42 = add i32 %39, %41
  store i32 %42, i32* %6
  br label %58
43:
  ; else
  br label %44
44:
  ; cond
  %45 = load i32, i32* %4
  %46 = load i32, i32* %5
  %47 = mul i32 2, %46
  %48 = icmp sgt i32 %45, %47
  br i1 %48, label %49, label %54
49:
  ; then
  %50 = load i32, i32* %6
  %51 = load i32, i32* %5
  %52 = mul i32 3, %51
  %53 = add i32 %50, %52
  store i32 %53, i32* %6
  br label %57
54:
  ; else
  %55 = load i32, i32* %6
  %56 = mul i32 2, %55
  store i32 %56, i32* %6
  br label %57
57:
  ; end
  br label %58
58:
  ; end
  %59 = load i32, i32* %6
  store i32 %59, i32* %3
  br label %60
60:
  %61 = load i32, i32* %3
  ret i32 %61
}

define void @TestFor() {
0:
  %1 = alloca i32
  %2 = alloca i32
  br label %3
3:
  store i32 1, i32* %1
  store i32 0, i32* %2
  br label %4
4:
  br label %5
5:
  ret void 
}

define i1 @boo(i1 %0) {
1:
  %2 = alloca i1
  %3 = alloca i1
  br label %4
4:
  store i1 0, i1* %2
  store i1 %0, i1* %3
  br label %5
5:
  call void  @Print(i32 42)
  %6 = load i1, i1* %3
  store i1 %6, i1* %2
  br label %7
7:
  %8 = load i1, i1* %2
  ret i1 %8
}

define void @TestLogicalOp() {
0:
  br label %1
1:
  br label %2
2:
  br i1 false, label %4, label %3
3:
  ; or_rhs
  br label %4
4:
  ; or_end
  %5 = phi i1 [ 1, %2 ], [ false, %3 ]
  call void  @Print(i1 %5)
  br i1 false, label %7, label %6
6:
  ; or_rhs
  br label %7
7:
  ; or_end
  %8 = phi i1 [ 1, %4 ], [ true, %6 ]
  call void  @Print(i1 %8)
  br i1 true, label %10, label %9
9:
  ; or_rhs
  br label %10
10:
  ; or_end
  %11 = phi i1 [ 1, %7 ], [ false, %9 ]
  call void  @Print(i1 %11)
  br i1 true, label %13, label %12
12:
  ; or_rhs
  br label %13
13:
  ; or_end
  %14 = phi i1 [ 1, %10 ], [ true, %12 ]
  call void  @Print(i1 %14)
  br i1 false, label %15, label %16
15:
  ; and_rhs
  br label %16
16:
  ; and_end
  %17 = phi i1 [ 0, %13 ], [ false, %15 ]
  call void  @Print(i1 %17)
  br i1 false, label %18, label %19
18:
  ; and_rhs
  br label %19
19:
  ; and_end
  %20 = phi i1 [ 0, %16 ], [ true, %18 ]
  call void  @Print(i1 %20)
  br i1 true, label %21, label %22
21:
  ; and_rhs
  br label %22
22:
  ; and_end
  %23 = phi i1 [ 0, %19 ], [ false, %21 ]
  call void  @Print(i1 %23)
  br i1 true, label %24, label %25
24:
  ; and_rhs
  br label %25
25:
  ; and_end
  %26 = phi i1 [ 0, %22 ], [ true, %24 ]
  call void  @Print(i1 %26)
  %27 = icmp eq i1 false, 0
  call void  @Print(i1 %27)
  %28 = icmp eq i1 true, 0
  call void  @Print(i1 %28)
  br i1 true, label %31, label %29
29:
  ; or_rhs
  %30 = call i1  @boo(i1 false)
  br label %31
31:
  ; or_end
  %32 = phi i1 [ 1, %25 ], [ %30, %29 ]
  call void  @Print(i1 %32)
  br i1 false, label %33, label %35
33:
  ; and_rhs
  %34 = call i1  @boo(i1 true)
  br label %35
35:
  ; and_end
  %36 = phi i1 [ 0, %31 ], [ %34, %33 ]
  call void  @Print(i1 %36)
  %37 = call i1  @boo()
  br label %38
38:
  ret void 
}

define i32 @FactorialI(i32 %0) {
1:
  %2 = alloca i32
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  br label %6
6:
  store i32 0, i32* %2
  store i32 %0, i32* %3
  store i32 1, i32* %4
  store i32 1, i32* %5
  br label %7
7:
  %8 = load i32, i32* %4
  store i32 %8, i32* %2
  br label %9
9:
  %10 = load i32, i32* %2
  ret i32 %10
}

define i32 @FactorialR(i32 %0) {
1:
  %2 = alloca i32
  %3 = alloca i32
  br label %4
4:
  store i32 0, i32* %2
  store i32 %0, i32* %3
  br label %5
5:
  br label %6
6:
  ; cond
  %7 = load i32, i32* %3
  %8 = icmp sle i32 %7, 1
  br i1 %8, label %9, label %10
9:
  ; then
  store i32 1, i32* %2
  br label %16
10:
  ; end
  %11 = load i32, i32* %3
  %12 = load i32, i32* %3
  %13 = sub i32 %12, 1
  %14 = call i32  @FactorialR(i32 %13)
  %15 = mul i32 %11, %14
  store i32 %15, i32* %2
  br label %16
16:
  %17 = load i32, i32* %2
  ret i32 %17
}

define void @main_Grobbit_16__() {
0:
  %1 = alloca double
  %2 = alloca double
  %3 = alloca i32
  %4 = alloca double
  %5 = alloca i1
  %6 = alloca i32
  br label %7
7:
  store double 3.0, double* %1
  store double 1.0, double* %2
  store i32 1, i32* %3
  store i32 0, i32* %6
  br label %8
8:
  %9 = load double, double* %1
  %10 = load double, double* %2
  %11 = fadd double %9, %10
  store double %11, double* %4
  %12 = load double, double* %1
  %13 = load double, double* %2
  %14 = icmp sgt double %12, %13
  store i1 %14, i1* %5
  %15 = load double, double* %1
  %16 = load double, double* %2
  %17 = load double, double* %4
  call void (i32, ...) @PrintN_F(i32 3, double %15, double %16, double %17)
  %18 = load i1, i1* %5
  call void  @Print(i1 %18)
  call void  @TestLogicalOp()
  call void  @TestFor()
  %19 = call i32  @FactorialI(i32 5)
  %20 = call i32  @FactorialR(i32 5)
  call void (i32, ...) @PrintN(i32 2, i32 %19, i32 %20)
  %21 = call i32  @foo(i32 1, i32 2, i32 3)
  store i32 %21, i32* %6
  %22 = load i32, i32* %6
  call void  @Print(i32 %22)
  br label %23
23:
  ret void 
}

