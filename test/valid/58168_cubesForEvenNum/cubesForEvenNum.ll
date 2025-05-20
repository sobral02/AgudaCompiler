; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"f"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"remtmp" = srem i32 %"n_val", 2
  %"cmptmp" = icmp eq i32 %"remtmp", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"multmp" = mul i32 %"n_val.1", %"n_val.2"
  %"n_val.3" = load i32, i32* %"n_ptr"
  %"multmp.1" = mul i32 %"multmp", %"n_val.3"
  store i32 %"multmp.1", i32* %"n_ptr"
  br label %"merge"
else:
  br label %"merge"
merge:
  %"n_val.4" = load i32, i32* %"n_ptr"
  ret i32 %"n_val.4"
}

define void @"aguda_main"()
{
entry:
  %"f_call" = call i32 @"f"(i32 4)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"f_call")
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
