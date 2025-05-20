; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"add"(i32 %"x", i32 %"y")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"y_ptr" = alloca i32
  store i32 %"y", i32* %"y_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"y_val" = load i32, i32* %"y_ptr"
  %"addtmp" = add i32 %"x_val", %"y_val"
  ret i32 %"addtmp"
}

define void @"aguda_main"()
{
entry:
  br i1 1, label %"then", label %"else"
then:
  br label %"merge"
else:
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [3, %"then"], [4, %"else"]
  br i1 1, label %"then.1", label %"else.1"
then.1:
  br i1 0, label %"then.2", label %"else.2"
else.1:
  br label %"merge.1"
merge.1:
  %"iftmp.2" = phi  i32 [%"iftmp.1", %"merge.2"], [7, %"else.1"]
  %"add_call" = call i32 @"add"(i32 %"iftmp", i32 %"iftmp.2")
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"add_call")
  ret void
then.2:
  br label %"merge.2"
else.2:
  br label %"merge.2"
merge.2:
  %"iftmp.1" = phi  i32 [5, %"then.2"], [6, %"else.2"]
  br label %"merge.1"
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
