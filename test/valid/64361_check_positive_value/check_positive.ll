; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"testPositiveAssignment"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"cmptmp" = icmp sgt i32 %"x_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  br i1 1, label %"print_true", label %"print_false"
else:
  br i1 0, label %"print_true.1", label %"print_false.1"
merge:
  ret void
print_true:
  %".6" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".7" = call i32 (i8*, ...) @"printf"(i8* %".6")
  br label %"print_end"
print_false:
  %".9" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".10" = call i32 (i8*, ...) @"printf"(i8* %".9")
  br label %"print_end"
print_end:
  br label %"merge"
print_true.1:
  %".14" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".15" = call i32 (i8*, ...) @"printf"(i8* %".14")
  br label %"print_end.1"
print_false.1:
  %".17" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".18" = call i32 (i8*, ...) @"printf"(i8* %".17")
  br label %"print_end.1"
print_end.1:
  br label %"merge"
}

define void @"aguda_main"()
{
entry:
  %"negtmp" = sub i32 0, 10
  call void @"testPositiveAssignment"(i32 %"negtmp")
  call void @"testPositiveAssignment"(i32 10)
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
