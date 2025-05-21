; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"even"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"result" = alloca i1
  store i1 0, i1* %"result"
  %"x_val" = load i32, i32* %"x_ptr"
  %"cmptmp" = icmp eq i32 %"x_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  store i1 1, i1* %"result"
  br label %"merge"
else:
  %"x_val.1" = load i32, i32* %"x_ptr"
  %"subtmp" = sub i32 %"x_val.1", 1
  %"odd_call" = call i1 @"odd"(i32 %"subtmp")
  store i1 %"odd_call", i1* %"result"
  br label %"merge"
merge:
  %"result_val" = load i1, i1* %"result"
  ret i1 %"result_val"
}

define i1 @"odd"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"result" = alloca i1
  store i1 0, i1* %"result"
  %"x_val" = load i32, i32* %"x_ptr"
  %"cmptmp" = icmp eq i32 %"x_val", 0
  br i1 %"cmptmp", label %"then", label %"else"
then:
  store i1 0, i1* %"result"
  br label %"merge"
else:
  %"x_val.1" = load i32, i32* %"x_ptr"
  %"subtmp" = sub i32 %"x_val.1", 1
  %"even_call" = call i1 @"even"(i32 %"subtmp")
  store i1 %"even_call", i1* %"result"
  br label %"merge"
merge:
  %"result_val" = load i1, i1* %"result"
  ret i1 %"result_val"
}

define void @"aguda_main"()
{
entry:
  %"odd_call" = call i1 @"odd"(i32 19)
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
