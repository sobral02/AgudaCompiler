; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"sum_up_to_n"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"sum" = alloca i32
  store i32 0, i32* %"sum"
  %"i" = alloca i32
  store i32 1, i32* %"i"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp sle i32 %"i_val", %"n_val"
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"sum_val" = load i32, i32* %"sum"
  %"i_val.1" = load i32, i32* %"i"
  %"addtmp" = add i32 %"sum_val", %"i_val.1"
  store i32 %"addtmp", i32* %"sum"
  %"i_val.2" = load i32, i32* %"i"
  %"addtmp.1" = add i32 %"i_val.2", 1
  store i32 %"addtmp.1", i32* %"i"
  br label %"loop.cond"
loop.end:
  %"sum_val.1" = load i32, i32* %"sum"
  ret i32 %"sum_val.1"
}

define i32 @"result"()
{
entry:
  %"sum_up_to_n_call" = call i32 @"sum_up_to_n"(i32 8127)
  ret i32 %"sum_up_to_n_call"
}

define void @"aguda_main"()
{
entry:
  %"result_call" = call i32 @"result"()
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"result_call")
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
