; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"produceLetter"(i1 %"letter")
{
entry:
  %"letter_ptr" = alloca i1
  store i1 %"letter", i1* %"letter_ptr"
  %"l" = alloca i1
  %"letter_val" = load i1, i1* %"letter_ptr"
  store i1 %"letter_val", i1* %"l"
  %"letter_val.1" = load i1, i1* %"letter_ptr"
  %"l_val" = load i1, i1* %"l"
  ret i1 %"l_val"
}

define void @"aguda_main"()
{
entry:
  %"a" = alloca i1
  store i1 1, i1* %"a"
  %"a_val" = load i1, i1* %"a"
  %"produceLetter_call" = call i1 @"produceLetter"(i1 %"a_val")
  br i1 %"produceLetter_call", label %"print_true", label %"print_false"
print_true:
  %".4" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".5" = call i32 (i8*, ...) @"printf"(i8* %".4")
  br label %"print_end"
print_false:
  %".7" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".8" = call i32 (i8*, ...) @"printf"(i8* %".7")
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
