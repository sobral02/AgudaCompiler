; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"manyParams"(i32 %"a", i32 %"b", i32 %"c", i32 %"d", i32 %"e")
{
entry:
  %"a_ptr" = alloca i32
  store i32 %"a", i32* %"a_ptr"
  %"b_ptr" = alloca i32
  store i32 %"b", i32* %"b_ptr"
  %"c_ptr" = alloca i32
  store i32 %"c", i32* %"c_ptr"
  %"d_ptr" = alloca i32
  store i32 %"d", i32* %"d_ptr"
  %"e_ptr" = alloca i32
  store i32 %"e", i32* %"e_ptr"
  %"a_val" = load i32, i32* %"a_ptr"
  %"b_val" = load i32, i32* %"b_ptr"
  %"addtmp" = add i32 %"a_val", %"b_val"
  %"c_val" = load i32, i32* %"c_ptr"
  %"addtmp.1" = add i32 %"addtmp", %"c_val"
  %"d_val" = load i32, i32* %"d_ptr"
  %"addtmp.2" = add i32 %"addtmp.1", %"d_val"
  %"e_val" = load i32, i32* %"e_ptr"
  %"addtmp.3" = add i32 %"addtmp.2", %"e_val"
  ret i32 %"addtmp.3"
}

define void @"aguda_main"()
{
entry:
  %"manyParams_call" = call i32 @"manyParams"(i32 1, i32 2, i32 3, i32 4, i32 5)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"manyParams_call")
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
