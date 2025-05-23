; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"even"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"cmptmp" = icmp eq i32 %"x_val", 0
  %"x_val.1" = load i32, i32* %"x_ptr"
  %"subtmp" = sub i32 %"x_val.1", 1
  %"odd_call" = call i1 @"odd"(i32 %"subtmp")
  br i1 %"cmptmp", label %"or_merge", label %"or_rhs"
or_rhs:
  %"x_val.2" = load i32, i32* %"x_ptr"
  %"subtmp.1" = sub i32 %"x_val.2", 1
  %"odd_call.1" = call i1 @"odd"(i32 %"subtmp.1")
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"entry"], [%"odd_call.1", %"or_rhs"]
  ret i1 %"or_result"
}

define i1 @"odd"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"cmptmp" = icmp ne i32 %"x_val", 0
  %"x_val.1" = load i32, i32* %"x_ptr"
  %"subtmp" = sub i32 %"x_val.1", 1
  %"even_call" = call i1 @"even"(i32 %"subtmp")
  br i1 %"cmptmp", label %"and_rhs", label %"and_merge"
and_rhs:
  %"x_val.2" = load i32, i32* %"x_ptr"
  %"subtmp.1" = sub i32 %"x_val.2", 1
  %"even_call.1" = call i1 @"even"(i32 %"subtmp.1")
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"entry"], [%"even_call.1", %"and_rhs"]
  ret i1 %"and_result"
}

define void @"aguda_main"()
{
entry:
  %"odd_call" = call i1 @"odd"(i32 17)
  br i1 %"odd_call", label %"print_true", label %"print_false"
print_true:
  %".3" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".4" = call i32 (i8*, ...) @"printf"(i8* %".3")
  br label %"print_end"
print_false:
  %".6" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".7" = call i32 (i8*, ...) @"printf"(i8* %".6")
  br label %"print_end"
print_end:
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".str_true" = internal constant [5 x i8] c"true\00"
@".str_false" = internal constant [6 x i8] c"false\00"
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
