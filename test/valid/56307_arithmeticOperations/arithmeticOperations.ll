; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"sumUp"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"s" = alloca i32
  store i32 0, i32* %"s"
  %"i" = alloca i32
  store i32 1, i32* %"i"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp sle i32 %"i_val", %"n_val"
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"s_val" = load i32, i32* %"s"
  %"i_val.1" = load i32, i32* %"i"
  %"addtmp" = add i32 %"s_val", %"i_val.1"
  store i32 %"addtmp", i32* %"s"
  %"i_val.2" = load i32, i32* %"i"
  %"addtmp.1" = add i32 %"i_val.2", 1
  store i32 %"addtmp.1", i32* %"i"
  br label %"loop.cond"
loop.end:
  %"s_val.1" = load i32, i32* %"s"
  ret i32 %"s_val.1"
}

define i32 @"product"(i32 %"a", i32 %"b")
{
entry:
  %"a_ptr" = alloca i32
  store i32 %"a", i32* %"a_ptr"
  %"b_ptr" = alloca i32
  store i32 %"b", i32* %"b_ptr"
  %"a_val" = load i32, i32* %"a_ptr"
  %"b_val" = load i32, i32* %"b_ptr"
  %"multmp" = mul i32 %"a_val", %"b_val"
  ret i32 %"multmp"
}

define i32 @"combine"(i32 %"n", i32 %"m")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"m_ptr" = alloca i32
  store i32 %"m", i32* %"m_ptr"
  %"s" = alloca i32
  %"n_val" = load i32, i32* %"n_ptr"
  %"sumUp_call" = call i32 @"sumUp"(i32 %"n_val")
  store i32 %"sumUp_call", i32* %"s"
  %"p" = alloca i32
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"m_val" = load i32, i32* %"m_ptr"
  %"product_call" = call i32 @"product"(i32 %"n_val.1", i32 %"m_val")
  store i32 %"product_call", i32* %"p"
  %"s_val" = load i32, i32* %"s"
  %"p_val" = load i32, i32* %"p"
  %"addtmp" = add i32 %"s_val", %"p_val"
  ret i32 %"addtmp"
}

define void @"aguda_main"()
{
entry:
  %"combine_call" = call i32 @"combine"(i32 10, i32 5)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"combine_call")
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
