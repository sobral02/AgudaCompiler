; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"max"(i32 %"x", i32 %"y")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"y_ptr" = alloca i32
  store i32 %"y", i32* %"y_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"y_val" = load i32, i32* %"y_ptr"
  %"cmptmp" = icmp sge i32 %"x_val", %"y_val"
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"x_val.1" = load i32, i32* %"x_ptr"
  br label %"merge"
else:
  %"y_val.1" = load i32, i32* %"y_ptr"
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [%"x_val.1", %"then"], [%"y_val.1", %"else"]
  ret i32 %"iftmp"
}

define void @"aguda_main"()
{
entry:
  %"max_call" = call i32 @"max"(i32 5, i32 9)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"max_call")
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
