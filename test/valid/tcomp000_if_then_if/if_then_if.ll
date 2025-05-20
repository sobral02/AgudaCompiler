; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  br i1 1, label %"then", label %"else"
then:
  br i1 0, label %"then.1", label %"else.1"
else:
  br label %"merge"
merge:
  %".8" = getelementptr [6 x i8], [6 x i8]* @".str_unit", i32 0, i32 0
  %"printf_call_unit" = call i32 (i8*, ...) @"printf"(i8* %".8")
  ret void
then.1:
  br label %"merge.1"
else.1:
  br label %"merge.1"
merge.1:
  br label %"merge"
}

declare i32 @"printf"(i8* %".1", ...)

@".str_unit" = internal constant [6 x i8] c"unit\0a\00"
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
