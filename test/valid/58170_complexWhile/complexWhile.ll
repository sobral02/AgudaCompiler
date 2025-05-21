; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"a" = alloca i32
  store i32 1, i32* %"a"
  %"b" = alloca i32
  store i32 10, i32* %"b"
  %"c" = alloca i32
  store i32 0, i32* %"c"
  br label %"loop.cond"
loop.cond:
  %"a_val" = load i32, i32* %"a"
  %"b_val" = load i32, i32* %"b"
  %"cmptmp" = icmp slt i32 %"a_val", %"b_val"
  %"a_val.1" = load i32, i32* %"a"
  %"remtmp" = srem i32 %"a_val.1", 3
  %"cmptmp.1" = icmp ne i32 %"remtmp", 0
  %"b_val.1" = load i32, i32* %"b"
  %"remtmp.1" = srem i32 %"b_val.1", 5
  %"cmptmp.2" = icmp ne i32 %"remtmp.1", 0
  br i1 %"cmptmp.1", label %"or_then", label %"or_else"
loop.body:
  %"a_val.2" = load i32, i32* %"a"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"a_val.2")
  %"b_val.2" = load i32, i32* %"b"
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 %"b_val.2")
  %"a_val.3" = load i32, i32* %"a"
  %"addtmp" = add i32 %"a_val.3", 1
  store i32 %"addtmp", i32* %"a"
  %"b_val.3" = load i32, i32* %"b"
  %"subtmp" = sub i32 %"b_val.3", 1
  store i32 %"subtmp", i32* %"b"
  %"c_val" = load i32, i32* %"c"
  %"addtmp.1" = add i32 %"c_val", 1
  store i32 %"addtmp.1", i32* %"c"
  br label %"loop.cond"
loop.end:
  %"c_val.1" = load i32, i32* %"c"
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 %"c_val.1")
  %"a_val.4" = load i32, i32* %"a"
  %"fmtptr.3" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.3" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.3", i32 %"a_val.4")
  %"b_val.4" = load i32, i32* %"b"
  %"fmtptr.4" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.4" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.4", i32 %"b_val.4")
  ret void
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [%"cmptmp.2", %"or_else"]
  br i1 %"cmptmp", label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [%"or_result", %"and_else"]
  br i1 %"and_result", label %"loop.body", label %"loop.end"
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
