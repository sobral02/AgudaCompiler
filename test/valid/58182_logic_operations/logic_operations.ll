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
  br i1 %"b_val", label %"or_merge", label %"or_rhs"
or_rhs:
  %"c_val.1" = load i1, i1* %"c"
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"entry"], [%"c_val.1", %"or_rhs"]
  br i1 %"a_val", label %"and_rhs", label %"and_merge"
and_rhs:
  %"b_val.1" = load i1, i1* %"b"
  %"c_val.2" = load i1, i1* %"c"
  br i1 %"b_val.1", label %"or_merge.1", label %"or_rhs.1"
and_merge:
  %"and_result" = phi  i1 [0, %"or_merge"], [%"or_result.1", %"or_merge.1"]
  store i1 %"and_result", i1* %"opRes"
  %"opRes_val" = load i1, i1* %"opRes"
  br i1 %"opRes_val", label %"print_true", label %"print_false"
or_rhs.1:
  %"c_val.3" = load i1, i1* %"c"
  br label %"or_merge.1"
or_merge.1:
  %"or_result.1" = phi  i1 [1, %"and_rhs"], [%"c_val.3", %"or_rhs.1"]
  br label %"and_merge"
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
  %"b_val.2" = load i1, i1* %"b"
  br i1 %"a_val.1", label %"and_rhs.1", label %"and_merge.1"
and_rhs.1:
  %"b_val.3" = load i1, i1* %"b"
  br label %"and_merge.1"
and_merge.1:
  %"and_result.1" = phi  i1 [0, %"print_end"], [%"b_val.3", %"and_rhs.1"]
  %"c_val.4" = load i1, i1* %"c"
  br i1 %"and_result.1", label %"or_merge.2", label %"or_rhs.2"
or_rhs.2:
  %"c_val.5" = load i1, i1* %"c"
  br label %"or_merge.2"
or_merge.2:
  %"or_result.2" = phi  i1 [1, %"and_merge.1"], [%"c_val.5", %"or_rhs.2"]
  store i1 %"or_result.2", i1* %"opRes"
  %"opRes_val.1" = load i1, i1* %"opRes"
  br i1 %"opRes_val.1", label %"print_true.1", label %"print_false.1"
print_true.1:
  %".26" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".27" = call i32 (i8*, ...) @"printf"(i8* %".26")
  br label %"print_end.1"
print_false.1:
  %".29" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".30" = call i32 (i8*, ...) @"printf"(i8* %".29")
  br label %"print_end.1"
print_end.1:
  %"a_val.2" = load i1, i1* %"a"
  %"b_val.4" = load i1, i1* %"b"
  br i1 %"a_val.2", label %"and_rhs.2", label %"and_merge.2"
and_rhs.2:
  %"b_val.5" = load i1, i1* %"b"
  br label %"and_merge.2"
and_merge.2:
  %"and_result.2" = phi  i1 [0, %"print_end.1"], [%"b_val.5", %"and_rhs.2"]
  %"nottmp" = icmp eq i1 %"and_result.2", 0
  %"b_val.6" = load i1, i1* %"b"
  %"c_val.6" = load i1, i1* %"c"
  br i1 %"b_val.6", label %"and_rhs.3", label %"and_merge.3"
and_rhs.3:
  %"c_val.7" = load i1, i1* %"c"
  br label %"and_merge.3"
and_merge.3:
  %"and_result.3" = phi  i1 [0, %"and_merge.2"], [%"c_val.7", %"and_rhs.3"]
  br i1 %"nottmp", label %"or_merge.3", label %"or_rhs.3"
or_rhs.3:
  %"b_val.7" = load i1, i1* %"b"
  %"c_val.8" = load i1, i1* %"c"
  br i1 %"b_val.7", label %"and_rhs.4", label %"and_merge.4"
or_merge.3:
  %"or_result.3" = phi  i1 [1, %"and_merge.3"], [%"and_result.4", %"and_merge.4"]
  store i1 %"or_result.3", i1* %"opRes"
  %"opRes_val.2" = load i1, i1* %"opRes"
  br i1 %"opRes_val.2", label %"print_true.2", label %"print_false.2"
and_rhs.4:
  %"c_val.9" = load i1, i1* %"c"
  br label %"and_merge.4"
and_merge.4:
  %"and_result.4" = phi  i1 [0, %"or_rhs.3"], [%"c_val.9", %"and_rhs.4"]
  br label %"or_merge.3"
print_true.2:
  %".42" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".43" = call i32 (i8*, ...) @"printf"(i8* %".42")
  br label %"print_end.2"
print_false.2:
  %".45" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".46" = call i32 (i8*, ...) @"printf"(i8* %".45")
  br label %"print_end.2"
print_end.2:
  %"a_val.3" = load i1, i1* %"a"
  %"nottmp.1" = icmp eq i1 %"a_val.3", 0
  %"b_val.8" = load i1, i1* %"b"
  br i1 %"nottmp.1", label %"and_rhs.5", label %"and_merge.5"
and_rhs.5:
  %"b_val.9" = load i1, i1* %"b"
  br label %"and_merge.5"
and_merge.5:
  %"and_result.5" = phi  i1 [0, %"print_end.2"], [%"b_val.9", %"and_rhs.5"]
  store i1 %"and_result.5", i1* %"opRes"
  %"opRes_val.3" = load i1, i1* %"opRes"
  br i1 %"opRes_val.3", label %"print_true.3", label %"print_false.3"
print_true.3:
  %".52" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".53" = call i32 (i8*, ...) @"printf"(i8* %".52")
  br label %"print_end.3"
print_false.3:
  %".55" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".56" = call i32 (i8*, ...) @"printf"(i8* %".55")
  br label %"print_end.3"
print_end.3:
  %"a_val.4" = load i1, i1* %"a"
  %"b_val.10" = load i1, i1* %"b"
  br i1 %"a_val.4", label %"or_merge.4", label %"or_rhs.4"
or_rhs.4:
  %"b_val.11" = load i1, i1* %"b"
  br label %"or_merge.4"
or_merge.4:
  %"or_result.4" = phi  i1 [1, %"print_end.3"], [%"b_val.11", %"or_rhs.4"]
  %"c_val.10" = load i1, i1* %"c"
  br i1 %"or_result.4", label %"and_rhs.6", label %"and_merge.6"
and_rhs.6:
  %"c_val.11" = load i1, i1* %"c"
  br label %"and_merge.6"
and_merge.6:
  %"and_result.6" = phi  i1 [0, %"or_merge.4"], [%"c_val.11", %"and_rhs.6"]
  %"nottmp.2" = icmp eq i1 %"and_result.6", 0
  store i1 %"nottmp.2", i1* %"opRes"
  %"opRes_val.4" = load i1, i1* %"opRes"
  br i1 %"opRes_val.4", label %"print_true.4", label %"print_false.4"
print_true.4:
  %".64" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".65" = call i32 (i8*, ...) @"printf"(i8* %".64")
  br label %"print_end.4"
print_false.4:
  %".67" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".68" = call i32 (i8*, ...) @"printf"(i8* %".67")
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
