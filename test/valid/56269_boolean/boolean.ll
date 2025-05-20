; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  br i1 1, label %"then", label %"else"
then:
  br label %"merge"
else:
  br label %"merge"
merge:
  %"iftmp" = phi  i1 [1, %"then"], [0, %"else"]
  br i1 %"iftmp", label %"print_true", label %"print_false"
print_true:
  %".6" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".7" = call i32 (i8*, ...) @"printf"(i8* %".6")
  br label %"print_end"
print_false:
  %".9" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".10" = call i32 (i8*, ...) @"printf"(i8* %".9")
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
