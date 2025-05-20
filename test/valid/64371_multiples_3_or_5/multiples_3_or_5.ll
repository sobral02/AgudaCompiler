; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"res" = alloca i32
  store i32 0, i32* %"res"
  %"i" = alloca i32
  store i32 0, i32* %"i"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"cmptmp" = icmp slt i32 %"i_val", 1000
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"i_val.1" = load i32, i32* %"i"
  %"remtmp" = srem i32 %"i_val.1", 3
  %"cmptmp.1" = icmp eq i32 %"remtmp", 0
  %"i_val.2" = load i32, i32* %"i"
  %"remtmp.1" = srem i32 %"i_val.2", 5
  %"cmptmp.2" = icmp eq i32 %"remtmp.1", 0
  br i1 %"cmptmp.1", label %"or_then", label %"or_else"
loop.end:
  %"res_val.1" = load i32, i32* %"res"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"res_val.1")
  ret void
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [%"cmptmp.2", %"or_else"]
  br i1 %"or_result", label %"then", label %"else"
then:
  %"res_val" = load i32, i32* %"res"
  %"i_val.3" = load i32, i32* %"i"
  %"addtmp" = add i32 %"res_val", %"i_val.3"
  store i32 %"addtmp", i32* %"res"
  br label %"merge"
else:
  br label %"merge"
merge:
  %"i_val.4" = load i32, i32* %"i"
  %"addtmp.1" = add i32 %"i_val.4", 1
  store i32 %"addtmp.1", i32* %"i"
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
