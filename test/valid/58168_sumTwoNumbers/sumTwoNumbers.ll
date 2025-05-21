; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"sum"(i32 %"a", i32 %"b")
{
entry:
  %"a_ptr" = alloca i32
  store i32 %"a", i32* %"a_ptr"
  %"b_ptr" = alloca i32
  store i32 %"b", i32* %"b_ptr"
  %"c" = alloca i32
  %"a_val" = load i32, i32* %"a_ptr"
  %"b_val" = load i32, i32* %"b_ptr"
  %"addtmp" = add i32 %"a_val", %"b_val"
  store i32 %"addtmp", i32* %"c"
  %"a_val.1" = load i32, i32* %"a_ptr"
  %"b_val.1" = load i32, i32* %"b_ptr"
  %"addtmp.1" = add i32 %"a_val.1", %"b_val.1"
  %"c_val" = load i32, i32* %"c"
  ret i32 %"c_val"
}

define void @"aguda_main"()
{
entry:
  %"sum_call" = call i32 @"sum"(i32 5, i32 5)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"sum_call")
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
