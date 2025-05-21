; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"pow_result" = alloca i32
  store i32 1, i32* %"pow_result"
  %"pow_counter" = alloca i32
  store i32 3, i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_cond:
  %".5" = load i32, i32* %"pow_counter"
  %".6" = icmp sgt i32 %".5", 0
  br i1 %".6", label %"pow_loop_body", label %"pow_loop_end"
pow_loop_body:
  %".8" = load i32, i32* %"pow_result"
  %".9" = mul i32 %".8", 2
  store i32 %".9", i32* %"pow_result"
  %".11" = sub i32 %".5", 1
  store i32 %".11", i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_end:
  %"pow_result_val" = load i32, i32* %"pow_result"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"pow_result_val")
  %"pow_result.1" = alloca i32
  store i32 1, i32* %"pow_result.1"
  %"pow_counter.1" = alloca i32
  store i32 2, i32* %"pow_counter.1"
  br label %"pow_loop_cond.1"
pow_loop_cond.1:
  %".17" = load i32, i32* %"pow_counter.1"
  %".18" = icmp sgt i32 %".17", 0
  br i1 %".18", label %"pow_loop_body.1", label %"pow_loop_end.1"
pow_loop_body.1:
  %".20" = load i32, i32* %"pow_result.1"
  %".21" = mul i32 %".20", 3
  store i32 %".21", i32* %"pow_result.1"
  %".23" = sub i32 %".17", 1
  store i32 %".23", i32* %"pow_counter.1"
  br label %"pow_loop_cond.1"
pow_loop_end.1:
  %"pow_result_val.1" = load i32, i32* %"pow_result.1"
  %"pow_result.2" = alloca i32
  store i32 1, i32* %"pow_result.2"
  %"pow_counter.2" = alloca i32
  store i32 %"pow_result_val.1", i32* %"pow_counter.2"
  br label %"pow_loop_cond.2"
pow_loop_cond.2:
  %".29" = load i32, i32* %"pow_counter.2"
  %".30" = icmp sgt i32 %".29", 0
  br i1 %".30", label %"pow_loop_body.2", label %"pow_loop_end.2"
pow_loop_body.2:
  %".32" = load i32, i32* %"pow_result.2"
  %".33" = mul i32 %".32", 2
  store i32 %".33", i32* %"pow_result.2"
  %".35" = sub i32 %".29", 1
  store i32 %".35", i32* %"pow_counter.2"
  br label %"pow_loop_cond.2"
pow_loop_end.2:
  %"pow_result_val.2" = load i32, i32* %"pow_result.2"
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 %"pow_result_val.2")
  %"negtmp" = sub i32 0, 3
  %"pow_result.3" = alloca i32
  store i32 1, i32* %"pow_result.3"
  %"pow_counter.3" = alloca i32
  store i32 %"negtmp", i32* %"pow_counter.3"
  br label %"pow_loop_cond.3"
pow_loop_cond.3:
  %".41" = load i32, i32* %"pow_counter.3"
  %".42" = icmp sgt i32 %".41", 0
  br i1 %".42", label %"pow_loop_body.3", label %"pow_loop_end.3"
pow_loop_body.3:
  %".44" = load i32, i32* %"pow_result.3"
  %".45" = mul i32 %".44", 2
  store i32 %".45", i32* %"pow_result.3"
  %".47" = sub i32 %".41", 1
  store i32 %".47", i32* %"pow_counter.3"
  br label %"pow_loop_cond.3"
pow_loop_end.3:
  %"pow_result_val.3" = load i32, i32* %"pow_result.3"
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 %"pow_result_val.3")
  %"pow_result.4" = alloca i32
  store i32 1, i32* %"pow_result.4"
  %"pow_counter.4" = alloca i32
  store i32 2, i32* %"pow_counter.4"
  br label %"pow_loop_cond.4"
pow_loop_cond.4:
  %".53" = load i32, i32* %"pow_counter.4"
  %".54" = icmp sgt i32 %".53", 0
  br i1 %".54", label %"pow_loop_body.4", label %"pow_loop_end.4"
pow_loop_body.4:
  %".56" = load i32, i32* %"pow_result.4"
  %".57" = mul i32 %".56", 2
  store i32 %".57", i32* %"pow_result.4"
  %".59" = sub i32 %".53", 1
  store i32 %".59", i32* %"pow_counter.4"
  br label %"pow_loop_cond.4"
pow_loop_end.4:
  %"pow_result_val.4" = load i32, i32* %"pow_result.4"
  %"multmp" = mul i32 3, %"pow_result_val.4"
  %"fmtptr.3" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.3" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.3", i32 %"multmp")
  %"pow_result.5" = alloca i32
  store i32 1, i32* %"pow_result.5"
  %"pow_counter.5" = alloca i32
  store i32 2, i32* %"pow_counter.5"
  br label %"pow_loop_cond.5"
pow_loop_cond.5:
  %".65" = load i32, i32* %"pow_counter.5"
  %".66" = icmp sgt i32 %".65", 0
  br i1 %".66", label %"pow_loop_body.5", label %"pow_loop_end.5"
pow_loop_body.5:
  %".68" = load i32, i32* %"pow_result.5"
  %".69" = mul i32 %".68", 2
  store i32 %".69", i32* %"pow_result.5"
  %".71" = sub i32 %".65", 1
  store i32 %".71", i32* %"pow_counter.5"
  br label %"pow_loop_cond.5"
pow_loop_end.5:
  %"pow_result_val.5" = load i32, i32* %"pow_result.5"
  %"multmp.1" = mul i32 %"pow_result_val.5", 3
  %"fmtptr.4" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.4" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.4", i32 %"multmp.1")
  ret void
}

declare i32 @"printf"(i8* %".1", ...)

@".printf_fmt_int" = internal constant [3 x i8] c"%d\00"
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
