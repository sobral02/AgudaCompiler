; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  br i1 0, label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [1, %"and_else"]
  br i1 %"and_result", label %"or_then", label %"or_else"
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [1, %"or_else"]
  br i1 %"or_result", label %"print_true", label %"print_false"
print_true:
  %".9" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".10" = call i32 (i8*, ...) @"printf"(i8* %".9")
  br label %"print_end"
print_false:
  %".12" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".13" = call i32 (i8*, ...) @"printf"(i8* %".12")
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
