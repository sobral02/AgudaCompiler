; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"calculate_operations"(i32 %"a", i32 %"b", i32 %"c", i32 %"d", i32 %"e")
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
  %"mult1" = alloca i32
  %"a_val" = load i32, i32* %"a_ptr"
  %"b_val" = load i32, i32* %"b_ptr"
  %"multmp" = mul i32 %"a_val", %"b_val"
  store i32 %"multmp", i32* %"mult1"
  %"a_val.1" = load i32, i32* %"a_ptr"
  %"b_val.1" = load i32, i32* %"b_ptr"
  %"multmp.1" = mul i32 %"a_val.1", %"b_val.1"
  %"mult2" = alloca i32
  %"c_val" = load i32, i32* %"c_ptr"
  %"d_val" = load i32, i32* %"d_ptr"
  %"multmp.2" = mul i32 %"c_val", %"d_val"
  store i32 %"multmp.2", i32* %"mult2"
  %"c_val.1" = load i32, i32* %"c_ptr"
  %"d_val.1" = load i32, i32* %"d_ptr"
  %"multmp.3" = mul i32 %"c_val.1", %"d_val.1"
  %"sub1" = alloca i32
  %"mult1_val" = load i32, i32* %"mult1"
  %"mult2_val" = load i32, i32* %"mult2"
  %"subtmp" = sub i32 %"mult1_val", %"mult2_val"
  store i32 %"subtmp", i32* %"sub1"
  %"mult1_val.1" = load i32, i32* %"mult1"
  %"mult2_val.1" = load i32, i32* %"mult2"
  %"subtmp.1" = sub i32 %"mult1_val.1", %"mult2_val.1"
  %"result" = alloca i32
  %"sub1_val" = load i32, i32* %"sub1"
  %"e_val" = load i32, i32* %"e_ptr"
  %"addtmp" = add i32 %"sub1_val", %"e_val"
  store i32 %"addtmp", i32* %"result"
  %"sub1_val.1" = load i32, i32* %"sub1"
  %"e_val.1" = load i32, i32* %"e_ptr"
  %"addtmp.1" = add i32 %"sub1_val.1", %"e_val.1"
  %"result_val" = load i32, i32* %"result"
  ret i32 %"result_val"
}

define i32 @"final_result"()
{
entry:
  %"x_global_val" = load i32, i32* @"x"
  %"y_global_val" = load i32, i32* @"y"
  %"z_global_val" = load i32, i32* @"z"
  %"w_global_val" = load i32, i32* @"w"
  %"v_global_val" = load i32, i32* @"v"
  %"calculate_operations_call" = call i32 @"calculate_operations"(i32 %"x_global_val", i32 %"y_global_val", i32 %"z_global_val", i32 %"w_global_val", i32 %"v_global_val")
  ret i32 %"calculate_operations_call"
}

define void @"aguda_main"()
{
entry:
  %"final_result_call" = call i32 @"final_result"()
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"final_result_call")
  ret void
}

@"x" = internal global i32 1
@"y" = internal global i32 2
@"z" = internal global i32 3
@"w" = internal global i32 4
@"v" = internal global i32 5
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
