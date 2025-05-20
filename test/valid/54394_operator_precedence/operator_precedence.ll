; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"negtmp" = sub i32 0, 2
  %"multmp" = mul i32 4, 3
  %"addtmp" = add i32 %"negtmp", %"multmp"
  %"pow_result" = alloca i32
  store i32 1, i32* %"pow_result"
  %"pow_counter" = alloca i32
  store i32 3, i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_cond:
  %".5" = load i32, i32* %"pow_counter"
  %".6" = icmp sgt i32 %".5", 0
  br i1 %".6", label %"pow_loop_body", label %"pow_loop_end"
pow_loop_body:
  %".8" = load i32, i32* %"pow_result"
  %".9" = mul i32 %".8", 2
  store i32 %".9", i32* %"pow_result"
  %".11" = sub i32 %".5", 1
  store i32 %".11", i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_end:
  %"pow_result_val" = load i32, i32* %"pow_result"
  %"subtmp" = sub i32 %"addtmp", %"pow_result_val"
  %"addtmp.1" = add i32 %"subtmp", 11
  %"remtmp" = srem i32 %"addtmp.1", 5
  %"negtmp.1" = sub i32 0, 3
  %"divtmp" = sdiv i32 6, %"negtmp.1"
  %"addtmp.2" = add i32 %"remtmp", %"divtmp"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"addtmp.2")
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
