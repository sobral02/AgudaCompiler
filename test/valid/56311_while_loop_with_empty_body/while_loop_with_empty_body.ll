; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"countForever"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  br label %"loop.cond"
loop.cond:
  br i1 0, label %"loop.body", label %"loop.end"
loop.body:
  %"n_val" = load i32, i32* %"n_ptr"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"n_val")
  br label %"loop.cond"
loop.end:
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".printf_fmt_int" = internal constant [3 x i8] c"%d\00"
define void @"aguda_main"()
{
entry:
  call void @"countForever"(i32 10)
  %".2" = getelementptr [6 x i8], [6 x i8]* @".str_unit", i32 0, i32 0
  %"printf_call_unit" = call i32 (i8*, ...) @"printf"(i8* %".2")
  ret void
}

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
