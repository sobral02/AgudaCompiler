; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"a" = alloca i32
  %"pow_result" = alloca i32
  store i32 1, i32* %"pow_result"
  %"pow_counter" = alloca i32
  store i32 2, i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_cond:
  %".5" = load i32, i32* %"pow_counter"
  %".6" = icmp sgt i32 %".5", 0
  br i1 %".6", label %"pow_loop_body", label %"pow_loop_end"
pow_loop_body:
  %".8" = load i32, i32* %"pow_result"
  %".9" = mul i32 %".8", 4
  store i32 %".9", i32* %"pow_result"
  %".11" = sub i32 %".5", 1
  store i32 %".11", i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_end:
  %"pow_result_val" = load i32, i32* %"pow_result"
  %"multmp" = mul i32 3, %"pow_result_val"
  %"divtmp" = sdiv i32 %"multmp", 2
  %"addtmp" = add i32 2, %"divtmp"
  %"subtmp" = sub i32 %"addtmp", 1
  store i32 %"subtmp", i32* %"a"
  %"pow_result.1" = alloca i32
  store i32 1, i32* %"pow_result.1"
  %"pow_counter.1" = alloca i32
  store i32 2, i32* %"pow_counter.1"
  br label %"pow_loop_cond.1"
pow_loop_cond.1:
  %".18" = load i32, i32* %"pow_counter.1"
  %".19" = icmp sgt i32 %".18", 0
  br i1 %".19", label %"pow_loop_body.1", label %"pow_loop_end.1"
pow_loop_body.1:
  %".21" = load i32, i32* %"pow_result.1"
  %".22" = mul i32 %".21", 4
  store i32 %".22", i32* %"pow_result.1"
  %".24" = sub i32 %".18", 1
  store i32 %".24", i32* %"pow_counter.1"
  br label %"pow_loop_cond.1"
pow_loop_end.1:
  %"pow_result_val.1" = load i32, i32* %"pow_result.1"
  %"multmp.1" = mul i32 3, %"pow_result_val.1"
  %"divtmp.1" = sdiv i32 %"multmp.1", 2
  %"addtmp.1" = add i32 2, %"divtmp.1"
  %"subtmp.1" = sub i32 %"addtmp.1", 1
  %"b" = alloca i32
  %"negtmp" = sub i32 0, 2
  %"pow_result.2" = alloca i32
  store i32 1, i32* %"pow_result.2"
  %"pow_counter.2" = alloca i32
  store i32 2, i32* %"pow_counter.2"
  br label %"pow_loop_cond.2"
pow_loop_cond.2:
  %".30" = load i32, i32* %"pow_counter.2"
  %".31" = icmp sgt i32 %".30", 0
  br i1 %".31", label %"pow_loop_body.2", label %"pow_loop_end.2"
pow_loop_body.2:
  %".33" = load i32, i32* %"pow_result.2"
  %".34" = mul i32 %".33", %"negtmp"
  store i32 %".34", i32* %"pow_result.2"
  %".36" = sub i32 %".30", 1
  store i32 %".36", i32* %"pow_counter.2"
  br label %"pow_loop_cond.2"
pow_loop_end.2:
  %"pow_result_val.2" = load i32, i32* %"pow_result.2"
  %"multmp.2" = mul i32 3, %"pow_result_val.2"
  store i32 %"multmp.2", i32* %"b"
  %"negtmp.1" = sub i32 0, 2
  %"pow_result.3" = alloca i32
  store i32 1, i32* %"pow_result.3"
  %"pow_counter.3" = alloca i32
  store i32 2, i32* %"pow_counter.3"
  br label %"pow_loop_cond.3"
pow_loop_cond.3:
  %".43" = load i32, i32* %"pow_counter.3"
  %".44" = icmp sgt i32 %".43", 0
  br i1 %".44", label %"pow_loop_body.3", label %"pow_loop_end.3"
pow_loop_body.3:
  %".46" = load i32, i32* %"pow_result.3"
  %".47" = mul i32 %".46", %"negtmp.1"
  store i32 %".47", i32* %"pow_result.3"
  %".49" = sub i32 %".43", 1
  store i32 %".49", i32* %"pow_counter.3"
  br label %"pow_loop_cond.3"
pow_loop_end.3:
  %"pow_result_val.3" = load i32, i32* %"pow_result.3"
  %"multmp.3" = mul i32 3, %"pow_result_val.3"
  %"c" = alloca i1
  %"nottmp" = icmp eq i1 1, 0
  br i1 0, label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [1, %"and_else"]
  br i1 %"nottmp", label %"or_then", label %"or_else"
or_then:
  br label %"or_merge"
or_else:
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"or_then"], [%"and_result", %"or_else"]
  store i1 %"or_result", i1* %"c"
  %"nottmp.1" = icmp eq i1 1, 0
  br i1 0, label %"and_else.1", label %"and_then.1"
and_then.1:
  br label %"and_merge.1"
and_else.1:
  br label %"and_merge.1"
and_merge.1:
  %"and_result.1" = phi  i1 [0, %"and_then.1"], [1, %"and_else.1"]
  br i1 %"nottmp.1", label %"or_then.1", label %"or_else.1"
or_then.1:
  br label %"or_merge.1"
or_else.1:
  br label %"or_merge.1"
or_merge.1:
  %"or_result.1" = phi  i1 [1, %"or_then.1"], [%"and_result.1", %"or_else.1"]
  %"a_val" = load i32, i32* %"a"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"a_val")
  %"b_val" = load i32, i32* %"b"
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 %"b_val")
  %"c_val" = load i1, i1* %"c"
  br i1 %"c_val", label %"print_true", label %"print_false"
print_true:
  %".66" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".67" = call i32 (i8*, ...) @"printf"(i8* %".66")
  br label %"print_end"
print_false:
  %".69" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".70" = call i32 (i8*, ...) @"printf"(i8* %".69")
  br label %"print_end"
print_end:
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".printf_fmt_int" = internal constant [3 x i8] c"%d\00"
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
