; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"cube"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"multmp" = mul i32 %"n_val", %"n_val.1"
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"multmp.1" = mul i32 %"multmp", %"n_val.2"
  ret i32 %"multmp.1"
}

define i32 @"final_result"()
{
entry:
  %"cube_call" = call i32 @"cube"(i32 5)
  ret i32 %"cube_call"
}

define void @"aguda_main"()
{
entry:
  %"final_result_call" = call i32 @"final_result"()
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"final_result_call")
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".printf_fmt_int" = internal constant [3 x i8] c"%d\00"
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
