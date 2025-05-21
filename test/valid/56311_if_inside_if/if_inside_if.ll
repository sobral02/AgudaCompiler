; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"func"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"cmptmp" = icmp eq i32 %"x_val", 4
  br i1 %"cmptmp", label %"then", label %"else"
then:
  br label %"merge"
else:
  br label %"merge"
merge:
  %"iftmp" = phi  i1 [1, %"then"], [0, %"else"]
  br i1 %"iftmp", label %"then.1", label %"else.1"
then.1:
  br label %"merge.1"
else.1:
  br label %"merge.1"
merge.1:
  %"iftmp.1" = phi  i1 [1, %"then.1"], [0, %"else.1"]
  ret i1 %"iftmp.1"
}

define void @"aguda_main"()
{
entry:
  %"func_call" = call i1 @"func"(i32 4)
  br i1 %"func_call", label %"print_true", label %"print_false"
print_true:
  %".3" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".4" = call i32 (i8*, ...) @"printf"(i8* %".3")
  br label %"print_end"
print_false:
  %".6" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".7" = call i32 (i8*, ...) @"printf"(i8* %".6")
  br label %"print_end"
print_end:
  %"func_call.1" = call i1 @"func"(i32 3)
  br i1 %"func_call.1", label %"print_true.1", label %"print_false.1"
print_true.1:
  %".10" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".11" = call i32 (i8*, ...) @"printf"(i8* %".10")
  br label %"print_end.1"
print_false.1:
  %".13" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".14" = call i32 (i8*, ...) @"printf"(i8* %".13")
  br label %"print_end.1"
print_end.1:
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
