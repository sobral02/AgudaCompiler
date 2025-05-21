; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"f_call" = call i32 @"f"(i32 5, i32 6, i32 7)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"f_call")
  ret void
}

define i32 @"f"(i32 %"x", i32 %"y", i32 %"z")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"y_ptr" = alloca i32
  store i32 %"y", i32* %"y_ptr"
  %"z_ptr" = alloca i32
  store i32 %"z", i32* %"z_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"y_val" = load i32, i32* %"y_ptr"
  %"addtmp" = add i32 %"x_val", %"y_val"
  %"z_val" = load i32, i32* %"z_ptr"
  %"addtmp.1" = add i32 %"addtmp", %"z_val"
  ret i32 %"addtmp.1"
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
