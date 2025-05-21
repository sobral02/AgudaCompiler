; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"helloWorld"()
{
entry:
  %"i" = alloca i32
  store i32 10, i32* %"i"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"cmptmp" = icmp sge i32 %"i_val", 0
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"i_val.1" = load i32, i32* %"i"
  %"cmptmp.1" = icmp eq i32 %"i_val.1", 0
  br i1 %"cmptmp.1", label %"then", label %"else"
loop.end:
  ret void
then:
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 55)
  br label %"merge"
else:
  %"i_val.2" = load i32, i32* %"i"
  %"cmptmp.2" = icmp eq i32 %"i_val.2", 1
  br i1 %"cmptmp.2", label %"then.1", label %"else.1"
merge:
  %"i_val.3" = load i32, i32* %"i"
  %"subtmp" = sub i32 %"i_val.3", 1
  store i32 %"subtmp", i32* %"i"
  br label %"loop.cond"
then.1:
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 77)
  br label %"merge.1"
else.1:
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 99)
  br label %"merge.1"
merge.1:
  br label %"merge"
}

declare i32 @"printf"(i8* %".1", ...)

@".printf_fmt_int" = internal constant [3 x i8] c"%d\00"
define void @"aguda_main"()
{
entry:
  call void @"helloWorld"()
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
