; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"factorial"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp sle i32 %"n_val", 1
  br i1 %"cmptmp", label %"then", label %"else"
then:
  br label %"merge"
else:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"subtmp" = sub i32 %"n_val.2", 1
  %"factorial_call" = call i32 @"factorial"(i32 %"subtmp")
  %"multmp" = mul i32 %"n_val.1", %"factorial_call"
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [1, %"then"], [%"multmp", %"else"]
  ret i32 %"iftmp"
}

define void @"aguda_main"()
{
entry:
  %"factorial_call" = call i32 @"factorial"(i32 5)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"factorial_call")
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
