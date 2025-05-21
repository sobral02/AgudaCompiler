; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"addOne"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"addtmp" = add i32 %"x_val", 1
  ret i32 %"addtmp"
}

define i32 @"addTwo"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"addOne_call" = call i32 @"addOne"(i32 %"x_val")
  %"addOne_call.1" = call i32 @"addOne"(i32 %"addOne_call")
  ret i32 %"addOne_call.1"
}

define void @"aguda_main"()
{
entry:
  %"result" = alloca i32
  %"addTwo_call" = call i32 @"addTwo"(i32 5)
  store i32 %"addTwo_call", i32* %"result"
  %"addTwo_call.1" = call i32 @"addTwo"(i32 5)
  %"result_val" = load i32, i32* %"result"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"result_val")
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
