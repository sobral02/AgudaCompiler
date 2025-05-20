; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"powerTen"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"result" = alloca i32
  store i32 0, i32* %"result"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp slt i32 %"n_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"negtmp" = sub i32 0, 1
  store i32 %"negtmp", i32* %"result"
  br label %"merge"
else:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"cmptmp.1" = icmp eq i32 %"n_val.1", 0
  br i1 %"cmptmp.1", label %"then.1", label %"else.1"
merge:
  %"result_val" = load i32, i32* %"result"
  ret i32 %"result_val"
then.1:
  store i32 1, i32* %"result"
  br label %"merge.1"
else.1:
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"subtmp" = sub i32 %"n_val.2", 1
  %"powerTen_call" = call i32 @"powerTen"(i32 %"subtmp")
  %"multmp" = mul i32 10, %"powerTen_call"
  store i32 %"multmp", i32* %"result"
  br label %"merge.1"
merge.1:
  br label %"merge"
}

define void @"aguda_main"()
{
entry:
  %"powerTen_call" = call i32 @"powerTen"(i32 7)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"powerTen_call")
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
