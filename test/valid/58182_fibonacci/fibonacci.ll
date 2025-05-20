; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"fibonacci"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp sle i32 %"n_val", 1
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"n_val.1" = load i32, i32* %"n_ptr"
  br label %"merge"
else:
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"subtmp" = sub i32 %"n_val.2", 1
  %"fibonacci_call" = call i32 @"fibonacci"(i32 %"subtmp")
  %"n_val.3" = load i32, i32* %"n_ptr"
  %"subtmp.1" = sub i32 %"n_val.3", 2
  %"fibonacci_call.1" = call i32 @"fibonacci"(i32 %"subtmp.1")
  %"addtmp" = add i32 %"fibonacci_call", %"fibonacci_call.1"
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [%"n_val.1", %"then"], [%"addtmp", %"else"]
  ret i32 %"iftmp"
}

define void @"aguda_main"()
{
entry:
  %"fibonacci_call" = call i32 @"fibonacci"(i32 20)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"fibonacci_call")
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
