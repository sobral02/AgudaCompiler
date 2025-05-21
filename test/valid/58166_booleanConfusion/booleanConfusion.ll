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
  %"a_val.1" = load i1, i1* %"a"
  %"nottmp.1" = icmp eq i1 %"a_val.1", 0
  %"d" = alloca i1
  %"b_val" = load i1, i1* %"b"
  %"nottmp.2" = icmp eq i1 %"b_val", 0
  store i1 %"nottmp.2", i1* %"d"
  %"b_val.1" = load i1, i1* %"b"
  %"nottmp.3" = icmp eq i1 %"b_val.1", 0
  %"e" = alloca i1
  %"a_val.2" = load i1, i1* %"a"
  %"b_val.2" = load i1, i1* %"b"
  br i1 %"a_val.2", label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [%"b_val.2", %"and_else"]
  store i1 %"and_result", i1* %"e"
  %"a_val.3" = load i1, i1* %"a"
  %"b_val.3" = load i1, i1* %"b"
  br i1 %"a_val.3", label %"and_else.1", label %"and_then.1"
and_then.1:
  br label %"and_merge.1"
and_else.1:
  br label %"and_merge.1"
and_merge.1:
  %"and_result.1" = phi  i1 [0, %"and_then.1"], [%"b_val.3", %"and_else.1"]
  %"f" = alloca i1
  %"a_val.4" = load i1, i1* %"a"
  %"b_val.4" = load i1, i1* %"b"
  br i1 %"a_val.4", label %"or_then", label %"or_else"
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [%"b_val.4", %"or_else"]
  store i1 %"or_result", i1* %"f"
  %"a_val.5" = load i1, i1* %"a"
  %"b_val.5" = load i1, i1* %"b"
  br i1 %"a_val.5", label %"or_then.1", label %"or_else.1"
or_then.1:
  br label %"or_merge.1"
or_else.1:
  br label %"or_merge.1"
or_merge.1:
  %"or_result.1" = phi  i1 [1, %"or_then.1"], [%"b_val.5", %"or_else.1"]
  %"g" = alloca i1
  %"a_val.6" = load i1, i1* %"a"
  %"b_val.6" = load i1, i1* %"b"
  br i1 %"a_val.6", label %"and_else.2", label %"and_then.2"
and_then.2:
  br label %"and_merge.2"
and_else.2:
  br label %"and_merge.2"
and_merge.2:
  %"and_result.2" = phi  i1 [0, %"and_then.2"], [%"b_val.6", %"and_else.2"]
  %"nottmp.4" = icmp eq i1 %"and_result.2", 0
  store i1 %"nottmp.4", i1* %"g"
  %"a_val.7" = load i1, i1* %"a"
  %"b_val.7" = load i1, i1* %"b"
  br i1 %"a_val.7", label %"and_else.3", label %"and_then.3"
and_then.3:
  br label %"and_merge.3"
and_else.3:
  br label %"and_merge.3"
and_merge.3:
  %"and_result.3" = phi  i1 [0, %"and_then.3"], [%"b_val.7", %"and_else.3"]
  %"nottmp.5" = icmp eq i1 %"and_result.3", 0
  %"h" = alloca i1
  %"a_val.8" = load i1, i1* %"a"
  %"b_val.8" = load i1, i1* %"b"
  br i1 %"a_val.8", label %"or_then.2", label %"or_else.2"
or_then.2:
  br label %"or_merge.2"
or_else.2:
  br label %"or_merge.2"
or_merge.2:
  %"or_result.2" = phi  i1 [1, %"or_then.2"], [%"b_val.8", %"or_else.2"]
  %"nottmp.6" = icmp eq i1 %"or_result.2", 0
  store i1 %"nottmp.6", i1* %"h"
  %"a_val.9" = load i1, i1* %"a"
  %"b_val.9" = load i1, i1* %"b"
  br i1 %"a_val.9", label %"or_then.3", label %"or_else.3"
or_then.3:
  br label %"or_merge.3"
or_else.3:
  br label %"or_merge.3"
or_merge.3:
  %"or_result.3" = phi  i1 [1, %"or_then.3"], [%"b_val.9", %"or_else.3"]
  %"nottmp.7" = icmp eq i1 %"or_result.3", 0
  %"i" = alloca i1
  %"a_val.10" = load i1, i1* %"a"
  %"g_val" = load i1, i1* %"g"
  br i1 %"a_val.10", label %"and_else.4", label %"and_then.4"
and_then.4:
  br label %"and_merge.4"
and_else.4:
  br label %"and_merge.4"
and_merge.4:
  %"and_result.4" = phi  i1 [0, %"and_then.4"], [%"g_val", %"and_else.4"]
  store i1 %"and_result.4", i1* %"i"
  %"a_val.11" = load i1, i1* %"a"
  %"g_val.1" = load i1, i1* %"g"
  br i1 %"a_val.11", label %"and_else.5", label %"and_then.5"
and_then.5:
  br label %"and_merge.5"
and_else.5:
  br label %"and_merge.5"
and_merge.5:
  %"and_result.5" = phi  i1 [0, %"and_then.5"], [%"g_val.1", %"and_else.5"]
  %"j" = alloca i1
  %"a_val.12" = load i1, i1* %"a"
  %"c_val" = load i1, i1* %"c"
  br i1 %"a_val.12", label %"or_then.4", label %"or_else.4"
or_then.4:
  br label %"or_merge.4"
or_else.4:
  br label %"or_merge.4"
or_merge.4:
  %"or_result.4" = phi  i1 [1, %"or_then.4"], [%"c_val", %"or_else.4"]
  %"d_val" = load i1, i1* %"d"
  br i1 %"or_result.4", label %"and_else.6", label %"and_then.6"
and_then.6:
  br label %"and_merge.6"
and_else.6:
  br label %"and_merge.6"
and_merge.6:
  %"and_result.6" = phi  i1 [0, %"and_then.6"], [%"d_val", %"and_else.6"]
  %"f_val" = load i1, i1* %"f"
  %"d_val.1" = load i1, i1* %"d"
  %"h_val" = load i1, i1* %"h"
  %"c_val.1" = load i1, i1* %"c"
  %"i_val" = load i1, i1* %"i"
  br i1 %"c_val.1", label %"or_then.5", label %"or_else.5"
or_then.5:
  br label %"or_merge.5"
or_else.5:
  br label %"or_merge.5"
or_merge.5:
  %"or_result.5" = phi  i1 [1, %"or_then.5"], [%"i_val", %"or_else.5"]
  br i1 %"h_val", label %"and_else.7", label %"and_then.7"
and_then.7:
  br label %"and_merge.7"
and_else.7:
  br label %"and_merge.7"
and_merge.7:
  %"and_result.7" = phi  i1 [0, %"and_then.7"], [%"or_result.5", %"and_else.7"]
  br i1 %"d_val.1", label %"or_then.6", label %"or_else.6"
or_then.6:
  br label %"or_merge.6"
or_else.6:
  br label %"or_merge.6"
or_merge.6:
  %"or_result.6" = phi  i1 [1, %"or_then.6"], [%"and_result.7", %"or_else.6"]
  br i1 %"f_val", label %"and_else.8", label %"and_then.8"
and_then.8:
  br label %"and_merge.8"
and_else.8:
  br label %"and_merge.8"
and_merge.8:
  %"and_result.8" = phi  i1 [0, %"and_then.8"], [%"or_result.6", %"and_else.8"]
  br i1 %"and_result.6", label %"or_then.7", label %"or_else.7"
or_then.7:
  br label %"or_merge.7"
or_else.7:
  br label %"or_merge.7"
or_merge.7:
  %"or_result.7" = phi  i1 [1, %"or_then.7"], [%"and_result.8", %"or_else.7"]
  store i1 %"or_result.7", i1* %"j"
  %"a_val.13" = load i1, i1* %"a"
  %"c_val.2" = load i1, i1* %"c"
  br i1 %"a_val.13", label %"or_then.8", label %"or_else.8"
or_then.8:
  br label %"or_merge.8"
or_else.8:
  br label %"or_merge.8"
or_merge.8:
  %"or_result.8" = phi  i1 [1, %"or_then.8"], [%"c_val.2", %"or_else.8"]
  %"d_val.2" = load i1, i1* %"d"
  br i1 %"or_result.8", label %"and_else.9", label %"and_then.9"
and_then.9:
  br label %"and_merge.9"
and_else.9:
  br label %"and_merge.9"
and_merge.9:
  %"and_result.9" = phi  i1 [0, %"and_then.9"], [%"d_val.2", %"and_else.9"]
  %"f_val.1" = load i1, i1* %"f"
  %"d_val.3" = load i1, i1* %"d"
  %"h_val.1" = load i1, i1* %"h"
  %"c_val.3" = load i1, i1* %"c"
  %"i_val.1" = load i1, i1* %"i"
  br i1 %"c_val.3", label %"or_then.9", label %"or_else.9"
or_then.9:
  br label %"or_merge.9"
or_else.9:
  br label %"or_merge.9"
or_merge.9:
  %"or_result.9" = phi  i1 [1, %"or_then.9"], [%"i_val.1", %"or_else.9"]
  br i1 %"h_val.1", label %"and_else.10", label %"and_then.10"
and_then.10:
  br label %"and_merge.10"
and_else.10:
  br label %"and_merge.10"
and_merge.10:
  %"and_result.10" = phi  i1 [0, %"and_then.10"], [%"or_result.9", %"and_else.10"]
  br i1 %"d_val.3", label %"or_then.10", label %"or_else.10"
or_then.10:
  br label %"or_merge.10"
or_else.10:
  br label %"or_merge.10"
or_merge.10:
  %"or_result.10" = phi  i1 [1, %"or_then.10"], [%"and_result.10", %"or_else.10"]
  br i1 %"f_val.1", label %"and_else.11", label %"and_then.11"
and_then.11:
  br label %"and_merge.11"
and_else.11:
  br label %"and_merge.11"
and_merge.11:
  %"and_result.11" = phi  i1 [0, %"and_then.11"], [%"or_result.10", %"and_else.11"]
  br i1 %"and_result.9", label %"or_then.11", label %"or_else.11"
or_then.11:
  br label %"or_merge.11"
or_else.11:
  br label %"or_merge.11"
or_merge.11:
  %"or_result.11" = phi  i1 [1, %"or_then.11"], [%"and_result.11", %"or_else.11"]
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
