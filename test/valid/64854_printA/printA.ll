; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"printA"()
{
entry:
  %".2" = getelementptr [6 x i8], [6 x i8]* @".str_unit", i32 0, i32 0
  %"printf_call_unit" = call i32 (i8*, ...) @"printf"(i8* %".2")
  ret void
}

define void @"aguda_main"()
{
entry:
  call void @"printA"()
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".str_unit" = internal constant [6 x i8] c"unit\0a\00"
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
