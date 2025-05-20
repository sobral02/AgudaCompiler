; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"power"(i32 %"base", i32 %"exponent")
{
entry:
  %"base_ptr" = alloca i32
  store i32 %"base", i32* %"base_ptr"
  %"exponent_ptr" = alloca i32
  store i32 %"exponent", i32* %"exponent_ptr"
  %"result" = alloca i32
  store i32 1, i32* %"result"
  br label %"loop.cond"
loop.cond:
  %"exponent_val" = load i32, i32* %"exponent_ptr"
  %"cmptmp" = icmp sgt i32 %"exponent_val", 0
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"result_val" = load i32, i32* %"result"
  %"base_val" = load i32, i32* %"base_ptr"
  %"multmp" = mul i32 %"result_val", %"base_val"
  store i32 %"multmp", i32* %"result"
  %"exponent_val.1" = load i32, i32* %"exponent_ptr"
  %"subtmp" = sub i32 %"exponent_val.1", 1
  store i32 %"subtmp", i32* %"exponent_ptr"
  br label %"loop.cond"
loop.end:
  %"result_val.1" = load i32, i32* %"result"
  ret i32 %"result_val.1"
}

define void @"aguda_main"()
{
entry:
  %"power_call" = call i32 @"power"(i32 2, i32 6)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"power_call")
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
