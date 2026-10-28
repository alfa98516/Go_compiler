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
  %14 = alloca i32
  %15 = alloca i32
  %16 = alloca i32
  br label %17
17:
  store i32 0, i32* %4
  store i32 %0, i32* %5
  store i32 %1, i32* %6
  store i32 %2, i32* %7
  store i32 100, i32* %8
  store i32 1, i32* %9
  br label %18
18:
  %19 = load i32, i32* %5
  %20 = load i32, i32* %6
  %21 = load i32, i32* %7
  %22 = load i32, i32* %8
  %23 = load i32, i32* %9
  call void (i32, ...) @PrintN(i32 5, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23)
  store i32 30, i32* %10
  %24 = load i32, i32* %10
  call void  @Print(i32 %24)
  store i32 40, i32* %10
  %25 = load i32, i32* %10
  call void  @Print(i32 %25)
  store i32 10, i32* %6
  store i32 20, i32* %7
  store i32 1, i32* %11
  store i32 2, i32* %12
  %26 = load i32, i32* %6
  %27 = load i32, i32* %7
  %28 = load i32, i32* %11
  %29 = load i32, i32* %12
  call void (i32, ...) @PrintN(i32 4, i32 %26, i32 %27, i32 %28, i32 %29)
  br label %30
30:
  ; cond
  %31 = load i32, i32* %5
  %32 = icmp sgt i32 %31, 10
  br i1 %32, label %33, label %34
33:
  ; then
  store i32 20, i32* %5
  br label %41
34:
  ; else
  br label %35
35:
  ; cond
  %36 = load i32, i32* %5
  %37 = icmp sgt i32 %36, 20
  br i1 %37, label %38, label %39
38:
  ; then
  store i32 30, i32* %5
  br label %40
39:
  ; else
  store i32 40, i32* %5
  br label %40
40:
  ; end
  br label %41
41:
  ; end
  %42 = load i32, i32* %5
  call void  @Print(i32 %42)
  store i32 100, i32* %13
  br label %43
43:
  ; cond
  %44 = load i32, i32* %13
  %45 = icmp sgt i32 %44, 0
  br i1 %45, label %46, label %48
46:
  ; then
  %47 = load i32, i32* %13
  call void  @Print(i32 %47)
  br label %48
48:
  ; end
  %49 = load i32, i32* %5
  call void  @Print(i32 %49)
  store i32 0, i32* %14
  br label %50
50:
  ; cond
  %51 = load i32, i32* %14
  %52 = icmp slt i32 %51, 5
  br i1 %52, label %56, label %77
53:
  ; post
  %54 = load i32, i32* %14
  %55 = add i32 %54, 1
  store i32 %55, i32* %14
  br label %50
56:
  ; block
  br label %57
57:
  ; cond
  %58 = load i32, i32* %14
  %59 = icmp eq i32 %58, 1
  br i1 %59, label %60, label %61
60:
  ; then
  br label %53
61:
  ; end
  store i32 0, i32* %15
  br label %62
62:
  ; cond
  %63 = load i32, i32* %15
  %64 = icmp slt i32 %63, 6
  br i1 %64, label %68, label %76
65:
  ; post
  %66 = load i32, i32* %15
  %67 = add i32 %66, 1
  store i32 %67, i32* %15
  br label %62
68:
  ; block
  %69 = load i32, i32* %14
  %70 = load i32, i32* %15
  call void (i32, ...) @PrintN(i32 2, i32 %69, i32 %70)
  br label %71
71:
  ; cond
  %72 = load i32, i32* %15
  %73 = icmp eq i32 %72, 3
  br i1 %73, label %74, label %75
74:
  ; then
  br label %76
75:
  ; end
  br label %65
76:
  ; end
  br label %53
77:
  ; end
  br label %78
78:
  ; cond
  %79 = icmp ne i32 0, 1
  br i1 %79, label %80, label %81
80:
  ; block
  call void (i32, ...) @PrintN(i32 1, i32 1000)
  br label %81
81:
  ; end
  store i32 1, i32* %16
  br label %82
82:
  ; cond
  %83 = load i32, i32* %16
  %84 = icmp slt i32 %83, 10
  br i1 %84, label %88, label %92
85:
  ; post
  %86 = load i32, i32* %16
  %87 = add i32 %86, 1
  store i32 %87, i32* %16
  br label %82
88:
  ; block
  %89 = load i32, i32* %16
  %90 = load i32, i32* @g_c1
  %91 = load i1, i1* @g_x
  call void (i32, ...) @PrintN(i32 3, i32 %89, i32 %90, i1 %91)
  br label %85
92:
  ; end
  store i32 1, i32* %4
  br label %93
93:
  %94 = load i32, i32* %4
  ret i32 %94
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
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  br label %6
6:
  store i32 1, i32* %1
  store i32 0, i32* %2
  br label %7
7:
  br label %8
8:
  ; cond
  %9 = load i32, i32* %1
  %10 = icmp slt i32 %9, 5
  br i1 %10, label %11, label %15
11:
  ; block
  %12 = load i32, i32* %1
  call void  @Print(i32 %12)
  %13 = load i32, i32* %1
  %14 = add i32 %13, 1
  store i32 %14, i32* %1
  br label %8
15:
  ; end
  store i32 1, i32* %3
  br label %16
16:
  ; cond
  %17 = load i32, i32* %3
  %18 = icmp slt i32 %17, 3
  br i1 %18, label %22, label %28
19:
  ; post
  %20 = load i32, i32* %3
  %21 = add i32 %20, 2
  store i32 %21, i32* %3
  br label %16
22:
  ; block
  %23 = load i32, i32* %2
  %24 = load i32, i32* %3
  %25 = add i32 %23, %24
  store i32 %25, i32* %2
  %26 = load i32, i32* %3
  %27 = load i32, i32* %2
  call void (i32, ...) @PrintN(i32 2, i32 %26, i32 %27)
  br label %19
28:
  ; end
  br label %29
29:
  ; block
  call void  @Print(i32 0)
  br label %30
30:
  ; end
  store i32 0, i32* %4
  br label %31
31:
  ; cond
  %32 = load i32, i32* %4
  %33 = icmp slt i32 %32, 5
  br i1 %33, label %37, label %58
34:
  ; post
  %35 = load i32, i32* %4
  %36 = add i32 %35, 1
  store i32 %36, i32* %4
  br label %31
37:
  ; block
  br label %38
38:
  ; cond
  %39 = load i32, i32* %4
  %40 = icmp eq i32 %39, 1
  br i1 %40, label %41, label %42
41:
  ; then
  br label %34
42:
  ; end
  store i32 0, i32* %5
  br label %43
43:
  ; cond
  %44 = load i32, i32* %5
  %45 = icmp slt i32 %44, 6
  br i1 %45, label %49, label %57
46:
  ; post
  %47 = load i32, i32* %5
  %48 = add i32 %47, 1
  store i32 %48, i32* %5
  br label %43
49:
  ; block
  %50 = load i32, i32* %4
  %51 = load i32, i32* %5
  call void (i32, ...) @PrintN(i32 2, i32 %50, i32 %51)
  br label %52
52:
  ; cond
  %53 = load i32, i32* %5
  %54 = icmp eq i32 %53, 3
  br i1 %54, label %55, label %56
55:
  ; then
  br label %57
56:
  ; end
  br label %46
57:
  ; end
  br label %34
58:
  ; end
  br label %59
59:
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
  br label %8
8:
  ; cond
  %9 = load i32, i32* %5
  %10 = load i32, i32* %3
  %11 = icmp sle i32 %9, %10
  br i1 %11, label %12, label %18
12:
  ; block
  %13 = load i32, i32* %4
  %14 = load i32, i32* %5
  %15 = mul i32 %13, %14
  store i32 %15, i32* %4
  %16 = load i32, i32* %5
  %17 = add i32 %16, 1
  store i32 %17, i32* %5
  br label %8
18:
  ; end
  %19 = load i32, i32* %4
  store i32 %19, i32* %2
  br label %20
20:
  %21 = load i32, i32* %2
  ret i32 %21
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
  %7 = alloca i32
  br label %8
8:
  store double 3.0, double* %1
  store double 1.0, double* %2
  store i32 1, i32* %3
  store i32 0, i32* %6
  br label %9
9:
  %10 = load double, double* %1
  %11 = load double, double* %2
  %12 = fadd double %10, %11
  store double %12, double* %4
  %13 = load double, double* %1
  %14 = load double, double* %2
  %15 = fcmp ogt double %13, %14
  store i1 %15, i1* %5
  %16 = load double, double* %1
  %17 = load double, double* %2
  %18 = load double, double* %4
  call void (i32, ...) @PrintN_F(i32 3, double %16, double %17, double %18)
  %19 = load i1, i1* %5
  call void  @Print(i1 %19)
  call void  @TestLogicalOp()
  call void  @TestFor()
  store i32 0, i32* %7
  br label %20
20:
  ; cond
  %21 = load i32, i32* %7
  %22 = icmp slt i32 %21, 5
  br i1 %22, label %26, label %34
23:
  ; post
  %24 = load i32, i32* %7
  %25 = add i32 %24, 1
  store i32 %25, i32* %7
  br label %20
26:
  ; block
  %27 = load i32, i32* %7
  %28 = mul i32 3, %27
  %29 = add i32 %28, 1
  %30 = load i32, i32* %7
  %31 = add i32 %30, 2
  %32 = call i32  @TestIf(i32 %29, i32 %31)
  store i32 %32, i32* %6
  %33 = load i32, i32* %6
  call void  @Print(i32 %33)
  br label %23
34:
  ; end
  %35 = call i32  @FactorialI(i32 5)
  %36 = call i32  @FactorialR(i32 5)
  call void (i32, ...) @PrintN(i32 2, i32 %35, i32 %36)
  %37 = call i32  @foo(i32 1, i32 2, i32 3)
  store i32 %37, i32* %6
  %38 = load i32, i32* %6
  call void  @Print(i32 %38)
  br label %39
39:
  ret void 
}

