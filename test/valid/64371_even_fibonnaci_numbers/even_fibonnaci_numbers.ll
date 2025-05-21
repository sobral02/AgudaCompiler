; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"res" = alloca i32
  store i32 0, i32* %"res"
  %"i" = alloca i32
  store i32 1, i32* %"i"
  %"j" = alloca i32
  store i32 2, i32* %"j"
  br label %"loop.cond"
loop.cond:
  %"j_val" = load i32, i32* %"j"
  %"cmptmp" = icmp slt i32 %"j_val", 4000000
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"j_val.1" = load i32, i32* %"j"
  %"remtmp" = srem i32 %"j_val.1", 2
  %"cmptmp.1" = icmp eq i32 %"remtmp", 0
  br i1 %"cmptmp.1", label %"then", label %"else"
loop.end:
  %"res_val.1" = load i32, i32* %"res"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"res_val.1")
  ret void
then:
  %"res_val" = load i32, i32* %"res"
  %"j_val.2" = load i32, i32* %"j"
  %"addtmp" = add i32 %"res_val", %"j_val.2"
  store i32 %"addtmp", i32* %"res"
  br label %"merge"
else:
  br label %"merge"
merge:
  %"tmp" = alloca i32
  %"i_val" = load i32, i32* %"i"
  store i32 %"i_val", i32* %"tmp"
  %"i_val.1" = load i32, i32* %"i"
  %"j_val.3" = load i32, i32* %"j"
  store i32 %"j_val.3", i32* %"i"
  %"tmp_val" = load i32, i32* %"tmp"
  %"j_val.4" = load i32, i32* %"j"
  %"addtmp.1" = add i32 %"tmp_val", %"j_val.4"
  store i32 %"addtmp.1", i32* %"j"
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
