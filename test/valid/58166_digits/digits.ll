; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"digits"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"m" = alloca i32
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp slt i32 %"n_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"negtmp" = sub i32 0, %"n_val.1"
  br label %"merge"
else:
  %"n_val.2" = load i32, i32* %"n_ptr"
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [%"negtmp", %"then"], [%"n_val.2", %"else"]
  store i32 %"iftmp", i32* %"m"
  %"n_val.3" = load i32, i32* %"n_ptr"
  %"cmptmp.1" = icmp slt i32 %"n_val.3", 0
  br i1 %"cmptmp.1", label %"then.1", label %"else.1"
then.1:
  %"n_val.4" = load i32, i32* %"n_ptr"
  %"negtmp.1" = sub i32 0, %"n_val.4"
  br label %"merge.1"
else.1:
  %"n_val.5" = load i32, i32* %"n_ptr"
  br label %"merge.1"
merge.1:
  %"iftmp.1" = phi  i32 [%"negtmp.1", %"then.1"], [%"n_val.5", %"else.1"]
  %"m_val" = load i32, i32* %"m"
  %"cmptmp.2" = icmp slt i32 %"m_val", 10
  br i1 %"cmptmp.2", label %"then.2", label %"else.2"
then.2:
  br label %"merge.2"
else.2:
  %"m_val.1" = load i32, i32* %"m"
  %"divtmp" = sdiv i32 %"m_val.1", 10
  %"digits_call" = call i32 @"digits"(i32 %"divtmp")
  %"addtmp" = add i32 1, %"digits_call"
  br label %"merge.2"
merge.2:
  %"iftmp.2" = phi  i32 [1, %"then.2"], [%"addtmp", %"else.2"]
  ret i32 %"iftmp.2"
}

define void @"aguda_main"()
{
entry:
  %"digits_call" = call i32 @"digits"(i32 2025)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"digits_call")
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
