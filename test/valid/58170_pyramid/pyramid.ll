; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"printPyramid"(i32 %"rows")
{
entry:
  %"rows_ptr" = alloca i32
  store i32 %"rows", i32* %"rows_ptr"
  %"i" = alloca i32
  store i32 1, i32* %"i"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"rows_val" = load i32, i32* %"rows_ptr"
  %"cmptmp" = icmp sle i32 %"i_val", %"rows_val"
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"j" = alloca i32
  store i32 1, i32* %"j"
  %"space" = alloca i32
  %"rows_val.1" = load i32, i32* %"rows_ptr"
  %"i_val.1" = load i32, i32* %"i"
  %"subtmp" = sub i32 %"rows_val.1", %"i_val.1"
  store i32 %"subtmp", i32* %"space"
  %"rows_val.2" = load i32, i32* %"rows_ptr"
  %"i_val.2" = load i32, i32* %"i"
  %"subtmp.1" = sub i32 %"rows_val.2", %"i_val.2"
  br label %"loop.cond.1"
loop.end:
  ret void
loop.cond.1:
  %"space_val" = load i32, i32* %"space"
  %"cmptmp.1" = icmp sgt i32 %"space_val", 0
  br i1 %"cmptmp.1", label %"loop.body.1", label %"loop.end.1"
loop.body.1:
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 0)
  %"space_val.1" = load i32, i32* %"space"
  %"subtmp.2" = sub i32 %"space_val.1", 1
  store i32 %"subtmp.2", i32* %"space"
  br label %"loop.cond.1"
loop.end.1:
  br label %"loop.cond.2"
loop.cond.2:
  %"j_val" = load i32, i32* %"j"
  %"i_val.3" = load i32, i32* %"i"
  %"multmp" = mul i32 2, %"i_val.3"
  %"subtmp.3" = sub i32 %"multmp", 1
  %"cmptmp.2" = icmp sle i32 %"j_val", %"subtmp.3"
  br i1 %"cmptmp.2", label %"loop.body.2", label %"loop.end.2"
loop.body.2:
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 1)
  %"j_val.1" = load i32, i32* %"j"
  %"addtmp" = add i32 %"j_val.1", 1
  store i32 %"addtmp", i32* %"j"
  br label %"loop.cond.2"
loop.end.2:
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 9)
  %"i_val.4" = load i32, i32* %"i"
  %"addtmp.1" = add i32 %"i_val.4", 1
  store i32 %"addtmp.1", i32* %"i"
  br label %"loop.cond"
}

declare i32 @"printf"(i8* %".1", ...)

@".printf_fmt_int" = internal constant [3 x i8] c"%d\00"
define void @"aguda_main"()
{
entry:
  call void @"printPyramid"(i32 3)
  call void @"printPyramid"(i32 5)
  call void @"printPyramid"(i32 7)
  ret void
}

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
