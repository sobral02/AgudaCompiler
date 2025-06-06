; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"y" = alloca i32
  store i32 4, i32* %"y"
  br label %"loop.cond"
loop.cond:
  %"y_val" = load i32, i32* %"y"
  %"cmptmp" = icmp slt i32 %"y_val", 10
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"y_val.1" = load i32, i32* %"y"
  %"addtmp" = add i32 %"y_val.1", 4
  store i32 %"addtmp", i32* %"y"
  br label %"loop.cond"
loop.end:
  %"y_val.2" = load i32, i32* %"y"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"y_val.2")
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
