; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"mdc"(i32 %"a", i32 %"b")
{
entry:
  %"a_ptr" = alloca i32
  store i32 %"a", i32* %"a_ptr"
  %"b_ptr" = alloca i32
  store i32 %"b", i32* %"b_ptr"
  br label %"loop.cond"
loop.cond:
  %"b_val" = load i32, i32* %"b_ptr"
  %"cmptmp" = icmp ne i32 %"b_val", 0
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"temp" = alloca i32
  %"b_val.1" = load i32, i32* %"b_ptr"
  store i32 %"b_val.1", i32* %"temp"
  %"b_val.2" = load i32, i32* %"b_ptr"
  %"a_val" = load i32, i32* %"a_ptr"
  %"b_val.3" = load i32, i32* %"b_ptr"
  %"remtmp" = srem i32 %"a_val", %"b_val.3"
  store i32 %"remtmp", i32* %"b_ptr"
  %"temp_val" = load i32, i32* %"temp"
  store i32 %"temp_val", i32* %"a_ptr"
  br label %"loop.cond"
loop.end:
  %"a_val.1" = load i32, i32* %"a_ptr"
  ret i32 %"a_val.1"
}

define void @"aguda_main"()
{
entry:
  %"mdc_call" = call i32 @"mdc"(i32 48, i32 18)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"mdc_call")
  %"mdc_call.1" = call i32 @"mdc"(i32 101, i32 103)
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 %"mdc_call.1")
  %"mdc_call.2" = call i32 @"mdc"(i32 56, i32 98)
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 %"mdc_call.2")
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
