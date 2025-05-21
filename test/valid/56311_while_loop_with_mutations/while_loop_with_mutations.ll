; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"countDown"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  br label %"loop.cond"
loop.cond:
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp sgt i32 %"n_val", 0
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"n_val.1")
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"subtmp" = sub i32 %"n_val.2", 1
  store i32 %"subtmp", i32* %"n_ptr"
  br label %"loop.cond"
loop.end:
  ret void
}

define void @"aguda_main"()
{
entry:
  call void @"countDown"(i32 10)
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
