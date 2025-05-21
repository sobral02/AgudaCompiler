; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"printBool"(i1 %"b")
{
entry:
  %"b_ptr" = alloca i1
  store i1 %"b", i1* %"b_ptr"
  %"b_val" = load i1, i1* %"b_ptr"
  br i1 %"b_val", label %"then", label %"else"
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

declare i32 @"printf"(i8* %".1", ...)

@".str_true" = internal constant [5 x i8] c"true\00"
@".str_false" = internal constant [6 x i8] c"false\00"
define void @"aguda_main"()
{
entry:
  br i1 1, label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [1, %"and_else"]
  call void @"printBool"(i1 %"and_result")
  br i1 1, label %"and_else.1", label %"and_then.1"
and_then.1:
  br label %"and_merge.1"
and_else.1:
  br label %"and_merge.1"
and_merge.1:
  %"and_result.1" = phi  i1 [0, %"and_then.1"], [0, %"and_else.1"]
  call void @"printBool"(i1 %"and_result.1")
  br i1 1, label %"or_then", label %"or_else"
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [0, %"or_else"]
  call void @"printBool"(i1 %"or_result")
  br i1 0, label %"or_then.1", label %"or_else.1"
or_then.1:
  br label %"or_merge.1"
or_else.1:
  br label %"or_merge.1"
or_merge.1:
  %"or_result.1" = phi  i1 [1, %"or_then.1"], [0, %"or_else.1"]
  call void @"printBool"(i1 %"or_result.1")
  %"nottmp" = icmp eq i1 1, 0
  call void @"printBool"(i1 %"nottmp")
  %"nottmp.1" = icmp eq i1 0, 0
  call void @"printBool"(i1 %"nottmp.1")
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
