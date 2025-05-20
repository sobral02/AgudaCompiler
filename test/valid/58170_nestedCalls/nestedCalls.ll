; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"f"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"addtmp" = add i32 %"x_val", 1
  ret i32 %"addtmp"
}

define i32 @"g"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"multmp" = mul i32 %"x_val", 2
  ret i32 %"multmp"
}

define i32 @"h"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"subtmp" = sub i32 %"x_val", 3
  ret i32 %"subtmp"
}

define void @"aguda_main"()
{
entry:
  %"result" = alloca i32
  %"h_call" = call i32 @"h"(i32 5)
  %"g_call" = call i32 @"g"(i32 %"h_call")
  %"f_call" = call i32 @"f"(i32 %"g_call")
  %"h_call.1" = call i32 @"h"(i32 %"f_call")
  %"g_call.1" = call i32 @"g"(i32 %"h_call.1")
  %"f_call.1" = call i32 @"f"(i32 %"g_call.1")
  store i32 %"f_call.1", i32* %"result"
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
