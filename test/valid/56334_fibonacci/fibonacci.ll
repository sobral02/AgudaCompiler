; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"Fibonacci"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp eq i32 %"n_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  br label %"merge"
else:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"cmptmp.1" = icmp eq i32 %"n_val.1", 1
  br i1 %"cmptmp.1", label %"then.1", label %"else.1"
merge:
  %"iftmp.1" = phi  i32 [0, %"then"], [%"iftmp", %"merge.1"]
  ret i32 %"iftmp.1"
then.1:
  br label %"merge.1"
else.1:
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"subtmp" = sub i32 %"n_val.2", 1
  %"Fibonacci_call" = call i32 @"Fibonacci"(i32 %"subtmp")
  %"n_val.3" = load i32, i32* %"n_ptr"
  %"subtmp.1" = sub i32 %"n_val.3", 2
  %"Fibonacci_call.1" = call i32 @"Fibonacci"(i32 %"subtmp.1")
  %"addtmp" = add i32 %"Fibonacci_call", %"Fibonacci_call.1"
  br label %"merge.1"
merge.1:
  %"iftmp" = phi  i32 [1, %"then.1"], [%"addtmp", %"else.1"]
  br label %"merge"
}

define void @"aguda_main"()
{
entry:
  %"Fibonacci_call" = call i32 @"Fibonacci"(i32 20)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"Fibonacci_call")
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
