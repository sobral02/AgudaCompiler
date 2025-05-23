; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  br i1 0, label %"and_rhs", label %"and_merge"
and_rhs:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"entry"], [1, %"and_rhs"]
  br i1 %"and_result", label %"or_merge", label %"or_rhs"
or_rhs:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"and_merge"], [1, %"or_rhs"]
  br i1 %"or_result", label %"print_true", label %"print_false"
print_true:
  %".7" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".8" = call i32 (i8*, ...) @"printf"(i8* %".7")
  br label %"print_end"
print_false:
  %".10" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".11" = call i32 (i8*, ...) @"printf"(i8* %".10")
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
