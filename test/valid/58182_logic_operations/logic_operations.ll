; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"a" = alloca i1
  store i1 1, i1* %"a"
  %"b" = alloca i1
  store i1 0, i1* %"b"
  %"c" = alloca i1
  store i1 1, i1* %"c"
  %"opRes" = alloca i1
  store i1 0, i1* %"opRes"
  %"a_val" = load i1, i1* %"a"
  %"b_val" = load i1, i1* %"b"
  %"c_val" = load i1, i1* %"c"
  br i1 %"b_val", label %"or_then", label %"or_else"
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [%"c_val", %"or_else"]
  br i1 %"a_val", label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [%"or_result", %"and_else"]
  store i1 %"and_result", i1* %"opRes"
  %"opRes_val" = load i1, i1* %"opRes"
  br i1 %"opRes_val", label %"print_true", label %"print_false"
print_true:
  %".14" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".15" = call i32 (i8*, ...) @"printf"(i8* %".14")
  br label %"print_end"
print_false:
  %".17" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".18" = call i32 (i8*, ...) @"printf"(i8* %".17")
  br label %"print_end"
print_end:
  %"a_val.1" = load i1, i1* %"a"
  %"b_val.1" = load i1, i1* %"b"
  br i1 %"a_val.1", label %"and_else.1", label %"and_then.1"
and_then.1:
  br label %"and_merge.1"
and_else.1:
  br label %"and_merge.1"
and_merge.1:
  %"and_result.1" = phi  i1 [0, %"and_then.1"], [%"b_val.1", %"and_else.1"]
  %"c_val.1" = load i1, i1* %"c"
  br i1 %"and_result.1", label %"or_then.1", label %"or_else.1"
or_then.1:
  br label %"or_merge.1"
or_else.1:
  br label %"or_merge.1"
or_merge.1:
  %"or_result.1" = phi  i1 [1, %"or_then.1"], [%"c_val.1", %"or_else.1"]
  store i1 %"or_result.1", i1* %"opRes"
  %"opRes_val.1" = load i1, i1* %"opRes"
  br i1 %"opRes_val.1", label %"print_true.1", label %"print_false.1"
print_true.1:
  %".28" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".29" = call i32 (i8*, ...) @"printf"(i8* %".28")
  br label %"print_end.1"
print_false.1:
  %".31" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".32" = call i32 (i8*, ...) @"printf"(i8* %".31")
  br label %"print_end.1"
print_end.1:
  %"a_val.2" = load i1, i1* %"a"
  %"b_val.2" = load i1, i1* %"b"
  br i1 %"a_val.2", label %"and_else.2", label %"and_then.2"
and_then.2:
  br label %"and_merge.2"
and_else.2:
  br label %"and_merge.2"
and_merge.2:
  %"and_result.2" = phi  i1 [0, %"and_then.2"], [%"b_val.2", %"and_else.2"]
  %"nottmp" = icmp eq i1 %"and_result.2", 0
  %"b_val.3" = load i1, i1* %"b"
  %"c_val.2" = load i1, i1* %"c"
  br i1 %"b_val.3", label %"and_else.3", label %"and_then.3"
and_then.3:
  br label %"and_merge.3"
and_else.3:
  br label %"and_merge.3"
and_merge.3:
  %"and_result.3" = phi  i1 [0, %"and_then.3"], [%"c_val.2", %"and_else.3"]
  br i1 %"nottmp", label %"or_then.2", label %"or_else.2"
or_then.2:
  br label %"or_merge.2"
or_else.2:
  br label %"or_merge.2"
or_merge.2:
  %"or_result.2" = phi  i1 [1, %"or_then.2"], [%"and_result.3", %"or_else.2"]
  store i1 %"or_result.2", i1* %"opRes"
  %"opRes_val.2" = load i1, i1* %"opRes"
  br i1 %"opRes_val.2", label %"print_true.2", label %"print_false.2"
print_true.2:
  %".45" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".46" = call i32 (i8*, ...) @"printf"(i8* %".45")
  br label %"print_end.2"
print_false.2:
  %".48" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".49" = call i32 (i8*, ...) @"printf"(i8* %".48")
  br label %"print_end.2"
print_end.2:
  %"a_val.3" = load i1, i1* %"a"
  %"nottmp.1" = icmp eq i1 %"a_val.3", 0
  %"b_val.4" = load i1, i1* %"b"
  br i1 %"nottmp.1", label %"and_else.4", label %"and_then.4"
and_then.4:
  br label %"and_merge.4"
and_else.4:
  br label %"and_merge.4"
and_merge.4:
  %"and_result.4" = phi  i1 [0, %"and_then.4"], [%"b_val.4", %"and_else.4"]
  store i1 %"and_result.4", i1* %"opRes"
  %"opRes_val.3" = load i1, i1* %"opRes"
  br i1 %"opRes_val.3", label %"print_true.3", label %"print_false.3"
print_true.3:
  %".56" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".57" = call i32 (i8*, ...) @"printf"(i8* %".56")
  br label %"print_end.3"
print_false.3:
  %".59" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".60" = call i32 (i8*, ...) @"printf"(i8* %".59")
  br label %"print_end.3"
print_end.3:
  %"a_val.4" = load i1, i1* %"a"
  %"b_val.5" = load i1, i1* %"b"
  br i1 %"a_val.4", label %"or_then.3", label %"or_else.3"
or_then.3:
  br label %"or_merge.3"
or_else.3:
  br label %"or_merge.3"
or_merge.3:
  %"or_result.3" = phi  i1 [1, %"or_then.3"], [%"b_val.5", %"or_else.3"]
  %"c_val.3" = load i1, i1* %"c"
  br i1 %"or_result.3", label %"and_else.5", label %"and_then.5"
and_then.5:
  br label %"and_merge.5"
and_else.5:
  br label %"and_merge.5"
and_merge.5:
  %"and_result.5" = phi  i1 [0, %"and_then.5"], [%"c_val.3", %"and_else.5"]
  %"nottmp.2" = icmp eq i1 %"and_result.5", 0
  store i1 %"nottmp.2", i1* %"opRes"
  %"opRes_val.4" = load i1, i1* %"opRes"
  br i1 %"opRes_val.4", label %"print_true.4", label %"print_false.4"
print_true.4:
  %".70" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".71" = call i32 (i8*, ...) @"printf"(i8* %".70")
  br label %"print_end.4"
print_false.4:
  %".73" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".74" = call i32 (i8*, ...) @"printf"(i8* %".73")
  br label %"print_end.4"
print_end.4:
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
