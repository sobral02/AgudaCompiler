; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"booleanConfusion"()
{
entry:
  %"a" = alloca i1
  store i1 1, i1* %"a"
  %"b" = alloca i1
  store i1 0, i1* %"b"
  %"c" = alloca i1
  %"a_val" = load i1, i1* %"a"
  %"nottmp" = icmp eq i1 %"a_val", 0
  store i1 %"nottmp", i1* %"c"
  %"d" = alloca i1
  %"b_val" = load i1, i1* %"b"
  %"nottmp.1" = icmp eq i1 %"b_val", 0
  store i1 %"nottmp.1", i1* %"d"
  %"e" = alloca i1
  %"a_val.1" = load i1, i1* %"a"
  %"b_val.1" = load i1, i1* %"b"
  br i1 %"a_val.1", label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [%"b_val.1", %"and_else"]
  store i1 %"and_result", i1* %"e"
  %"f" = alloca i1
  %"a_val.2" = load i1, i1* %"a"
  %"b_val.2" = load i1, i1* %"b"
  br i1 %"a_val.2", label %"or_then", label %"or_else"
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [%"b_val.2", %"or_else"]
  store i1 %"or_result", i1* %"f"
  %"g" = alloca i1
  %"a_val.3" = load i1, i1* %"a"
  %"b_val.3" = load i1, i1* %"b"
  br i1 %"a_val.3", label %"and_else.1", label %"and_then.1"
and_then.1:
  br label %"and_merge.1"
and_else.1:
  br label %"and_merge.1"
and_merge.1:
  %"and_result.1" = phi  i1 [0, %"and_then.1"], [%"b_val.3", %"and_else.1"]
  %"nottmp.2" = icmp eq i1 %"and_result.1", 0
  store i1 %"nottmp.2", i1* %"g"
  %"h" = alloca i1
  %"a_val.4" = load i1, i1* %"a"
  %"b_val.4" = load i1, i1* %"b"
  br i1 %"a_val.4", label %"or_then.1", label %"or_else.1"
or_then.1:
  br label %"or_merge.1"
or_else.1:
  br label %"or_merge.1"
or_merge.1:
  %"or_result.1" = phi  i1 [1, %"or_then.1"], [%"b_val.4", %"or_else.1"]
  %"nottmp.3" = icmp eq i1 %"or_result.1", 0
  store i1 %"nottmp.3", i1* %"h"
  %"i" = alloca i1
  %"a_val.5" = load i1, i1* %"a"
  %"g_val" = load i1, i1* %"g"
  br i1 %"a_val.5", label %"and_else.2", label %"and_then.2"
and_then.2:
  br label %"and_merge.2"
and_else.2:
  br label %"and_merge.2"
and_merge.2:
  %"and_result.2" = phi  i1 [0, %"and_then.2"], [%"g_val", %"and_else.2"]
  store i1 %"and_result.2", i1* %"i"
  %"j" = alloca i1
  %"a_val.6" = load i1, i1* %"a"
  %"c_val" = load i1, i1* %"c"
  br i1 %"a_val.6", label %"or_then.2", label %"or_else.2"
or_then.2:
  br label %"or_merge.2"
or_else.2:
  br label %"or_merge.2"
or_merge.2:
  %"or_result.2" = phi  i1 [1, %"or_then.2"], [%"c_val", %"or_else.2"]
  %"d_val" = load i1, i1* %"d"
  br i1 %"or_result.2", label %"and_else.3", label %"and_then.3"
and_then.3:
  br label %"and_merge.3"
and_else.3:
  br label %"and_merge.3"
and_merge.3:
  %"and_result.3" = phi  i1 [0, %"and_then.3"], [%"d_val", %"and_else.3"]
  %"f_val" = load i1, i1* %"f"
  %"d_val.1" = load i1, i1* %"d"
  %"h_val" = load i1, i1* %"h"
  %"c_val.1" = load i1, i1* %"c"
  %"i_val" = load i1, i1* %"i"
  br i1 %"c_val.1", label %"or_then.3", label %"or_else.3"
or_then.3:
  br label %"or_merge.3"
or_else.3:
  br label %"or_merge.3"
or_merge.3:
  %"or_result.3" = phi  i1 [1, %"or_then.3"], [%"i_val", %"or_else.3"]
  br i1 %"h_val", label %"and_else.4", label %"and_then.4"
and_then.4:
  br label %"and_merge.4"
and_else.4:
  br label %"and_merge.4"
and_merge.4:
  %"and_result.4" = phi  i1 [0, %"and_then.4"], [%"or_result.3", %"and_else.4"]
  br i1 %"d_val.1", label %"or_then.4", label %"or_else.4"
or_then.4:
  br label %"or_merge.4"
or_else.4:
  br label %"or_merge.4"
or_merge.4:
  %"or_result.4" = phi  i1 [1, %"or_then.4"], [%"and_result.4", %"or_else.4"]
  br i1 %"f_val", label %"and_else.5", label %"and_then.5"
and_then.5:
  br label %"and_merge.5"
and_else.5:
  br label %"and_merge.5"
and_merge.5:
  %"and_result.5" = phi  i1 [0, %"and_then.5"], [%"or_result.4", %"and_else.5"]
  br i1 %"and_result.3", label %"or_then.5", label %"or_else.5"
or_then.5:
  br label %"or_merge.5"
or_else.5:
  br label %"or_merge.5"
or_merge.5:
  %"or_result.5" = phi  i1 [1, %"or_then.5"], [%"and_result.5", %"or_else.5"]
  store i1 %"or_result.5", i1* %"j"
  %"j_val" = load i1, i1* %"j"
  ret i1 %"j_val"
}

define void @"aguda_main"()
{
entry:
  %"booleanConfusion_call" = call i1 @"booleanConfusion"()
  br i1 %"booleanConfusion_call", label %"print_true", label %"print_false"
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
