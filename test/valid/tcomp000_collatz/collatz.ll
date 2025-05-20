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
  %"divtmp" = sdiv i32 %"n_val.1", 2
  br label %"merge"
else:
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"multmp" = mul i32 3, %"n_val.2"
  %"addtmp" = add i32 %"multmp", 1
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [%"divtmp", %"then"], [%"addtmp", %"else"]
  ret i32 %"iftmp"
}

define void @"conjecture"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"f_call" = call i32 @"f"(i32 %"n_val")
  %"cmptmp" = icmp ne i32 %"f_call", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"subtmp" = sub i32 %"n_val.1", 1
  call void @"conjecture"(i32 %"subtmp")
  br label %"merge"
else:
  br label %"merge"
merge:
  ret void
}

define void @"aguda_main"()
{
entry:
  call void @"conjecture"(i32 43786)
  %".2" = getelementptr [6 x i8], [6 x i8]* @".str_unit", i32 0, i32 0
  %"printf_call_unit" = call i32 (i8*, ...) @"printf"(i8* %".2")
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".str_unit" = internal constant [6 x i8] c"unit\0a\00"
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
