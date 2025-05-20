; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"i" = alloca i32
  store i32 0, i32* %"i"
  %"limit" = alloca i32
  store i32 10, i32* %"limit"
  %"breakCondition" = alloca i32
  store i32 5, i32* %"breakCondition"
  %"flag" = alloca i1
  store i1 1, i1* %"flag"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"limit_val" = load i32, i32* %"limit"
  %"cmptmp" = icmp slt i32 %"i_val", %"limit_val"
  %"flag_val" = load i1, i1* %"flag"
  br i1 %"cmptmp", label %"and_else", label %"and_then"
loop.body:
  %"i_val.1" = load i32, i32* %"i"
  %"breakCondition_val" = load i32, i32* %"breakCondition"
  %"cmptmp.1" = icmp eq i32 %"i_val.1", %"breakCondition_val"
  br i1 %"cmptmp.1", label %"then", label %"else"
loop.end:
  ret void
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [%"flag_val", %"and_else"]
  br i1 %"and_result", label %"loop.body", label %"loop.end"
then:
  store i1 0, i1* %"flag"
  br label %"merge"
else:
  %"i_val.2" = load i32, i32* %"i"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"i_val.2")
  %"i_val.3" = load i32, i32* %"i"
  %"addtmp" = add i32 %"i_val.3", 1
  store i32 %"addtmp", i32* %"i"
  br label %"merge"
merge:
  br label %"loop.cond"
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
