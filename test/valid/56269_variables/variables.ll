; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"f"()
{
entry:
  %"x" = alloca i32
  store i32 1, i32* %"x"
  %"y" = alloca i32
  %"x_val" = load i32, i32* %"x"
  %"addtmp" = add i32 %"x_val", 2
  store i32 %"addtmp", i32* %"y"
  %"x_val.1" = load i32, i32* %"x"
  %"addtmp.1" = add i32 %"x_val.1", 2
  %"y_val" = load i32, i32* %"y"
  %"multmp" = mul i32 %"y_val", 2
  %"x_val.2" = load i32, i32* %"x"
  %"multmp.1" = mul i32 %"multmp", %"x_val.2"
  %"x_val.3" = load i32, i32* %"x"
  %"multmp.2" = mul i32 %"multmp.1", %"x_val.3"
  ret i32 %"multmp.2"
}

define void @"aguda_main"()
{
entry:
  %"f_call" = call i32 @"f"()
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"f_call")
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
