; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"modTest"(i32 %"n", i32 %"d")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"d_ptr" = alloca i32
  store i32 %"d", i32* %"d_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"d_val" = load i32, i32* %"d_ptr"
  %"remtmp" = srem i32 %"n_val", %"d_val"
  %"cmptmp" = icmp eq i32 %"remtmp", 0
  ret i1 %"cmptmp"
}

define void @"aguda_main"()
{
entry:
  %"a" = alloca i32
  store i32 253540, i32* %"a"
  %"b" = alloca i32
  store i32 27, i32* %"b"
  %"c" = alloca i32
  store i32 2025, i32* %"c"
  %"d" = alloca i32
  store i32 2077, i32* %"d"
  %"k" = alloca i32
  store i32 5, i32* %"k"
  %"a_val" = load i32, i32* %"a"
  %"k_val" = load i32, i32* %"k"
  %"modTest_call" = call i1 @"modTest"(i32 %"a_val", i32 %"k_val")
  br i1 %"modTest_call", label %"print_true", label %"print_false"
print_true:
  %".8" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".9" = call i32 (i8*, ...) @"printf"(i8* %".8")
  br label %"print_end"
print_false:
  %".11" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".12" = call i32 (i8*, ...) @"printf"(i8* %".11")
  br label %"print_end"
print_end:
  %"b_val" = load i32, i32* %"b"
  %"k_val.1" = load i32, i32* %"k"
  %"modTest_call.1" = call i1 @"modTest"(i32 %"b_val", i32 %"k_val.1")
  br i1 %"modTest_call.1", label %"print_true.1", label %"print_false.1"
print_true.1:
  %".15" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".16" = call i32 (i8*, ...) @"printf"(i8* %".15")
  br label %"print_end.1"
print_false.1:
  %".18" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".19" = call i32 (i8*, ...) @"printf"(i8* %".18")
  br label %"print_end.1"
print_end.1:
  %"c_val" = load i32, i32* %"c"
  %"k_val.2" = load i32, i32* %"k"
  %"modTest_call.2" = call i1 @"modTest"(i32 %"c_val", i32 %"k_val.2")
  br i1 %"modTest_call.2", label %"print_true.2", label %"print_false.2"
print_true.2:
  %".22" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".23" = call i32 (i8*, ...) @"printf"(i8* %".22")
  br label %"print_end.2"
print_false.2:
  %".25" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".26" = call i32 (i8*, ...) @"printf"(i8* %".25")
  br label %"print_end.2"
print_end.2:
  %"d_val" = load i32, i32* %"d"
  %"k_val.3" = load i32, i32* %"k"
  %"modTest_call.3" = call i1 @"modTest"(i32 %"d_val", i32 %"k_val.3")
  br i1 %"modTest_call.3", label %"print_true.3", label %"print_false.3"
print_true.3:
  %".29" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".30" = call i32 (i8*, ...) @"printf"(i8* %".29")
  br label %"print_end.3"
print_false.3:
  %".32" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".33" = call i32 (i8*, ...) @"printf"(i8* %".32")
  br label %"print_end.3"
print_end.3:
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".str_true" = internal constant [5 x i8] c"true\00"
@".str_false" = internal constant [6 x i8] c"false\00"
define i32 @"wrapper_main"()
{
entry:
  call void @"aguda_main"()
  ret i32 0
}

define i32 @"main"()
{
entry:
  %".2" = call i32 @"wrapper_main"()
  ret i32 %".2"
}
