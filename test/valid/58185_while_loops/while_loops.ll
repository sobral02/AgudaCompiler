; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"printPattern"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"i" = alloca i32
  store i32 0, i32* %"i"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp slt i32 %"i_val", %"n_val"
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"j" = alloca i32
  store i32 0, i32* %"j"
  br label %"loop.cond.1"
loop.end:
  ret void
loop.cond.1:
  %"j_val" = load i32, i32* %"j"
  %"i_val.1" = load i32, i32* %"i"
  %"cmptmp.1" = icmp sle i32 %"j_val", %"i_val.1"
  br i1 %"cmptmp.1", label %"loop.body.1", label %"loop.end.1"
loop.body.1:
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 5)
  %"j_val.1" = load i32, i32* %"j"
  %"addtmp" = add i32 %"j_val.1", 1
  store i32 %"addtmp", i32* %"j"
  br label %"loop.cond.1"
loop.end.1:
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 0)
  %"i_val.2" = load i32, i32* %"i"
  %"addtmp.1" = add i32 %"i_val.2", 1
  store i32 %"addtmp.1", i32* %"i"
  br label %"loop.cond"
}

declare i32 @"printf"(i8* %".1", ...)

@".printf_fmt_int" = internal constant [3 x i8] c"%d\00"
define void @"aguda_main"()
{
entry:
  call void @"printPattern"(i32 5)
  ret void
}

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
