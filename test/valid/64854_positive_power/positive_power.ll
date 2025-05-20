; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"positivePower"(i32 %"p", i32 %"k")
{
entry:
  %"p_ptr" = alloca i32
  store i32 %"p", i32* %"p_ptr"
  %"k_ptr" = alloca i32
  store i32 %"k", i32* %"k_ptr"
  %"k_val" = load i32, i32* %"k_ptr"
  %"cmptmp" = icmp sle i32 %"k_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  br label %"merge"
else:
  %"p_val" = load i32, i32* %"p_ptr"
  %"cmptmp.1" = icmp sle i32 %"p_val", 0
  br i1 %"cmptmp.1", label %"then.1", label %"else.1"
merge:
  %"iftmp.1" = phi  i32 [1, %"then"], [%"iftmp", %"merge.1"]
  ret i32 %"iftmp.1"
then.1:
  br label %"merge.1"
else.1:
  %"p_val.1" = load i32, i32* %"p_ptr"
  %"k_val.1" = load i32, i32* %"k_ptr"
  %"pow_result" = alloca i32
  store i32 1, i32* %"pow_result"
  %"pow_counter" = alloca i32
  store i32 %"k_val.1", i32* %"pow_counter"
  br label %"pow_loop_cond"
merge.1:
  %"iftmp" = phi  i32 [0, %"then.1"], [%"pow_result_val", %"pow_loop_end"]
  br label %"merge"
pow_loop_cond:
  %".13" = load i32, i32* %"pow_counter"
  %".14" = icmp sgt i32 %".13", 0
  br i1 %".14", label %"pow_loop_body", label %"pow_loop_end"
pow_loop_body:
  %".16" = load i32, i32* %"pow_result"
  %".17" = mul i32 %".16", %"p_val.1"
  store i32 %".17", i32* %"pow_result"
  %".19" = sub i32 %".13", 1
  store i32 %".19", i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_end:
  %"pow_result_val" = load i32, i32* %"pow_result"
  br label %"merge.1"
}

define void @"aguda_main"()
{
entry:
  %"positivePower_call" = call i32 @"positivePower"(i32 2, i32 3)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"positivePower_call")
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
