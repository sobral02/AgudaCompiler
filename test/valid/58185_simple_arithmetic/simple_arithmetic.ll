; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"addtmp" = add i32 10, 5
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"addtmp")
  %"subtmp" = sub i32 10, 5
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 %"subtmp")
  %"multmp" = mul i32 10, 5
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 %"multmp")
  %"divtmp" = sdiv i32 10, 5
  %"fmtptr.3" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.3" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.3", i32 %"divtmp")
  %"remtmp" = srem i32 10, 3
  %"fmtptr.4" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.4" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.4", i32 %"remtmp")
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
