; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"min"(i32 %"n", i32 %"v")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"v_ptr" = alloca i32
  store i32 %"v", i32* %"v_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"v_val" = load i32, i32* %"v_ptr"
  %"cmptmp" = icmp sgt i32 %"n_val", %"v_val"
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"v_val.1" = load i32, i32* %"v_ptr"
  br label %"merge"
else:
  %"n_val.1" = load i32, i32* %"n_ptr"
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [%"v_val.1", %"then"], [%"n_val.1", %"else"]
  ret i32 %"iftmp"
}

define i32 @"max"(i32 %"n", i32 %"v")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"v_ptr" = alloca i32
  store i32 %"v", i32* %"v_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"v_val" = load i32, i32* %"v_ptr"
  %"cmptmp" = icmp slt i32 %"n_val", %"v_val"
  br i1 %"cmptmp", label %"then", label %"else"
then:
  %"v_val.1" = load i32, i32* %"v_ptr"
  br label %"merge"
else:
  %"n_val.1" = load i32, i32* %"n_ptr"
  br label %"merge"
merge:
  %"iftmp" = phi  i32 [%"v_val.1", %"then"], [%"n_val.1", %"else"]
  ret i32 %"iftmp"
}

define i32 @"clamp"(i32 %"m", i32 %"n", i32 %"v")
{
entry:
  %"m_ptr" = alloca i32
  store i32 %"m", i32* %"m_ptr"
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"v_ptr" = alloca i32
  store i32 %"v", i32* %"v_ptr"
  %"m_val" = load i32, i32* %"m_ptr"
  %"n_val" = load i32, i32* %"n_ptr"
  %"v_val" = load i32, i32* %"v_ptr"
  %"min_call" = call i32 @"min"(i32 %"n_val", i32 %"v_val")
  %"max_call" = call i32 @"max"(i32 %"m_val", i32 %"min_call")
  ret i32 %"max_call"
}

define void @"aguda_main"()
{
entry:
  %"clamp_call" = call i32 @"clamp"(i32 0, i32 7, i32 16)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"clamp_call")
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
