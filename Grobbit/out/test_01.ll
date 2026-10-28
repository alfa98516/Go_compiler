; Available external functions.
declare void @Print(i32)
declare void @PrintN(i32, ...)
declare void @Print_F(double)
declare void @PrintN_F(i32, ...)


define void @main_Grobbit_16__() {
0:
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca i1
  br label %4
4:
  br label %5
5:
  store i32 3, i32* %1
  store i32 5, i32* %2
  br label %6
6:
  ; cond
  %7 = load i32, i32* %1
  %8 = load i32, i32* %2
  %9 = icmp eq i32 %7, %8
  br i1 %9, label %10, label %12
10:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 0)
  br label %28
12:
  ; else
  br label %13
13:
  ; cond
  %14 = load i32, i32* %1
  %15 = load i32, i32* %2
  %16 = icmp sge i32 %14, %15
  br i1 %16, label %17, label %19
17:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 1)
  br label %27
19:
  ; else
  br label %20
20:
  ; cond
  %21 = load i32, i32* %1
  %22 = load i32, i32* %2
  %23 = icmp sle i32 %21, %22
  br i1 %23, label %24, label %26
24:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 2)
  br label %26
26:
  ; end
  br label %27
27:
  ; end
  br label %28
28:
  ; end
  br label %29
29:
  ; cond
  %30 = load i32, i32* %1
  %31 = load i32, i32* %2
  %32 = icmp ne i32 %30, %31
  br i1 %32, label %33, label %35
33:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 3)
  br label %35
35:
  ; end
  br label %36
36:
  ; cond
  %37 = load i32, i32* %1
  %38 = load i32, i32* %2
  %39 = icmp slt i32 %37, %38
  br i1 %39, label %40, label %42
40:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 4)
  br label %50
42:
  ; else
  br label %43
43:
  ; cond
  %44 = load i32, i32* %1
  %45 = load i32, i32* %2
  %46 = icmp sgt i32 %44, %45
  br i1 %46, label %47, label %49
47:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 5)
  br label %49
49:
  ; end
  br label %50
50:
  ; end
  store i1 true, i1* %3
  br label %51
51:
  ; cond
  %52 = load i1, i1* %3
  %53 = icmp eq i1 %52, 0
  br i1 %53, label %54, label %56
54:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 0)
  br label %62
56:
  ; else
  br label %57
57:
  ; cond
  %58 = load i1, i1* %3
  br i1 %58, label %59, label %61
59:
  ; then
  call void (i32, ...) @PrintN(i32 1, i32 1)
  br label %61
61:
  ; end
  br label %62
62:
  ; end
  br label %63
63:
  ret void 
}

