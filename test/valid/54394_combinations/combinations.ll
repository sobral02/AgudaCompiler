; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"fac"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp eq i32 %"n_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  br label %"merge"
else:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"subtmp" = sub i32 %"n_val.2", 1
  %"fac_call" = call i32 @"fac"(i32 %"subtmp")
  %"multmp" = mul i32 %"n_val.1", %"fac_call"
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [1, %"then"], [%"multmp", %"else"]
  ret i32 %"iftmp"
}

define i32 @"comb"(i32 %"n", i32 %"k")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"k_ptr" = alloca i32
  store i32 %"k", i32* %"k_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"fac_call" = call i32 @"fac"(i32 %"n_val")
  %"k_val" = load i32, i32* %"k_ptr"
  %"fac_call.1" = call i32 @"fac"(i32 %"k_val")
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"k_val.1" = load i32, i32* %"k_ptr"
  %"subtmp" = sub i32 %"n_val.1", %"k_val.1"
  %"fac_call.2" = call i32 @"fac"(i32 %"subtmp")
  %"multmp" = mul i32 %"fac_call.1", %"fac_call.2"
  %"divtmp" = sdiv i32 %"fac_call", %"multmp"
  ret i32 %"divtmp"
}

define void @"aguda_main"()
{
entry:
  %"comb_call" = call i32 @"comb"(i32 6, i32 2)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"comb_call")
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
