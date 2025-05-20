; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"pow_result" = alloca i32
  store i32 1, i32* %"pow_result"
  %"pow_counter" = alloca i32
  store i32 2, i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_cond:
  %".5" = load i32, i32* %"pow_counter"
  %".6" = icmp sgt i32 %".5", 0
  br i1 %".6", label %"pow_loop_body", label %"pow_loop_end"
pow_loop_body:
  %".8" = load i32, i32* %"pow_result"
  %".9" = mul i32 %".8", 4
  store i32 %".9", i32* %"pow_result"
  %".11" = sub i32 %".5", 1
  store i32 %".11", i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_end:
  %"pow_result_val" = load i32, i32* %"pow_result"
  %"multmp" = mul i32 3, %"pow_result_val"
  %"addtmp" = add i32 12, %"multmp"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"addtmp")
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
