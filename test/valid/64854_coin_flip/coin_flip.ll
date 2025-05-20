; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"coinFlip"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"remtmp" = srem i32 %"n_val", 2
  %"cmptmp" = icmp eq i32 %"remtmp", 1
  br i1 %"cmptmp", label %"then", label %"else"
then:
  br label %"merge"
else:
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [1, %"then"], [2, %"else"]
  ret i32 %"iftmp"
}

define void @"aguda_main"()
{
entry:
  %"coinFlip_call" = call i32 @"coinFlip"(i32 4)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"coinFlip_call")
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
