; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"printn"(i1 %"s", i32 %"n")
{
entry:
  %"s_ptr" = alloca i1
  store i1 %"s", i1* %"s_ptr"
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"i" = alloca i32
  store i32 0, i32* %"i"
  br label %"loop.cond"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp slt i32 %"i_val", %"n_val"
  br i1 %"cmptmp", label %"loop.body", label %"loop.end"
loop.body:
  %"s_val" = load i1, i1* %"s_ptr"
  br i1 %"s_val", label %"print_true", label %"print_false"
loop.end:
  ret void
print_true:
  %".10" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".11" = call i32 (i8*, ...) @"printf"(i8* %".10")
  br label %"print_end"
print_false:
  %".13" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".14" = call i32 (i8*, ...) @"printf"(i8* %".13")
  br label %"print_end"
print_end:
  %"i_val.1" = load i32, i32* %"i"
  %"addtmp" = add i32 %"i_val.1", 1
  store i32 %"addtmp", i32* %"i"
  br label %"loop.cond"
}

declare i32 @"printf"(i8* %".1", ...)

@".str_true" = internal constant [5 x i8] c"true\00"
@".str_false" = internal constant [6 x i8] c"false\00"
define void @"aguda_main"()
{
entry:
  call void @"printn"(i1 0, i32 4)
  ret void
}

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
