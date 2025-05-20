; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"divide"(i32 %"a", i32 %"b")
{
entry:
  %"a_ptr" = alloca i32
  store i32 %"a", i32* %"a_ptr"
  %"b_ptr" = alloca i32
  store i32 %"b", i32* %"b_ptr"
  %"a_val" = load i32, i32* %"a_ptr"
  %"b_val" = load i32, i32* %"b_ptr"
  %"divtmp" = sdiv i32 %"a_val", %"b_val"
  ret i32 %"divtmp"
}

define i32 @"result"()
{
entry:
  %"divide_call" = call i32 @"divide"(i32 10, i32 2)
  ret i32 %"divide_call"
}

define void @"aguda_main"()
{
entry:
  %"result_call" = call i32 @"result"()
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"result_call")
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
