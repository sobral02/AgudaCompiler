; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"sum" = alloca i32
  %"negtmp" = sub i32 0, 3
  %"addtmp" = add i32 5, %"negtmp"
  store i32 %"addtmp", i32* %"sum"
  %"negtmp.1" = sub i32 0, 3
  %"addtmp.1" = add i32 5, %"negtmp.1"
  %"sum_val" = load i32, i32* %"sum"
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"sum_val")
  %"sum_val.1" = load i32, i32* %"sum"
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 %"sum_val.1")
  %"difference" = alloca i32
  %"negtmp.2" = sub i32 0, 10
  %"subtmp" = sub i32 %"negtmp.2", 2
  store i32 %"subtmp", i32* %"difference"
  %"negtmp.3" = sub i32 0, 10
  %"subtmp.1" = sub i32 %"negtmp.3", 2
  %"difference_val" = load i32, i32* %"difference"
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 %"difference_val")
  %"product" = alloca i32
  %"pow_result" = alloca i32
  store i32 1, i32* %"pow_result"
  %"pow_counter" = alloca i32
  store i32 0, i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_cond:
  %".7" = load i32, i32* %"pow_counter"
  %".8" = icmp sgt i32 %".7", 0
  br i1 %".8", label %"pow_loop_body", label %"pow_loop_end"
pow_loop_body:
  %".10" = load i32, i32* %"pow_result"
  %".11" = mul i32 %".10", 5
  store i32 %".11", i32* %"pow_result"
  %".13" = sub i32 %".7", 1
  store i32 %".13", i32* %"pow_counter"
  br label %"pow_loop_cond"
pow_loop_end:
  %"pow_result_val" = load i32, i32* %"pow_result"
  %"multmp" = mul i32 4, %"pow_result_val"
  store i32 %"multmp", i32* %"product"
  %"pow_result.1" = alloca i32
  store i32 1, i32* %"pow_result.1"
  %"pow_counter.1" = alloca i32
  store i32 0, i32* %"pow_counter.1"
  br label %"pow_loop_cond.1"
pow_loop_cond.1:
  %".20" = load i32, i32* %"pow_counter.1"
  %".21" = icmp sgt i32 %".20", 0
  br i1 %".21", label %"pow_loop_body.1", label %"pow_loop_end.1"
pow_loop_body.1:
  %".23" = load i32, i32* %"pow_result.1"
  %".24" = mul i32 %".23", 5
  store i32 %".24", i32* %"pow_result.1"
  %".26" = sub i32 %".20", 1
  store i32 %".26", i32* %"pow_counter.1"
  br label %"pow_loop_cond.1"
pow_loop_end.1:
  %"pow_result_val.1" = load i32, i32* %"pow_result.1"
  %"multmp.1" = mul i32 4, %"pow_result_val.1"
  %"product_val" = load i32, i32* %"product"
  %"fmtptr.3" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.3" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.3", i32 %"product_val")
  %"quotient" = alloca i32
  %"divtmp" = sdiv i32 20, 3
  store i32 %"divtmp", i32* %"quotient"
  %"divtmp.1" = sdiv i32 20, 3
  %"quotient_val" = load i32, i32* %"quotient"
  %"fmtptr.4" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.4" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.4", i32 %"quotient_val")
  %"remainder" = alloca i32
  %"remtmp" = srem i32 20, 4
  store i32 %"remtmp", i32* %"remainder"
  %"remtmp.1" = srem i32 20, 4
  %"remainder_val" = load i32, i32* %"remainder"
  %"fmtptr.5" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.5" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.5", i32 %"remainder_val")
  %"complex" = alloca i32
  %"negtmp.4" = sub i32 0, 2
  %"pow_result.2" = alloca i32
  store i32 1, i32* %"pow_result.2"
  %"pow_counter.2" = alloca i32
  store i32 %"negtmp.4", i32* %"pow_counter.2"
  br label %"pow_loop_cond.2"
pow_loop_cond.2:
  %".34" = load i32, i32* %"pow_counter.2"
  %".35" = icmp sgt i32 %".34", 0
  br i1 %".35", label %"pow_loop_body.2", label %"pow_loop_end.2"
pow_loop_body.2:
  %".37" = load i32, i32* %"pow_result.2"
  %".38" = mul i32 %".37", 2
  store i32 %".38", i32* %"pow_result.2"
  %".40" = sub i32 %".34", 1
  store i32 %".40", i32* %"pow_counter.2"
  br label %"pow_loop_cond.2"
pow_loop_end.2:
  %"pow_result_val.2" = load i32, i32* %"pow_result.2"
  %"multmp.2" = mul i32 8, %"pow_result_val.2"
  %"divtmp.2" = sdiv i32 %"multmp.2", 2
  %"addtmp.2" = add i32 3, 1
  %"pow_result.3" = alloca i32
  store i32 1, i32* %"pow_result.3"
  %"pow_counter.3" = alloca i32
  store i32 %"addtmp.2", i32* %"pow_counter.3"
  br label %"pow_loop_cond.3"
pow_loop_cond.3:
  %".46" = load i32, i32* %"pow_counter.3"
  %".47" = icmp sgt i32 %".46", 0
  br i1 %".47", label %"pow_loop_body.3", label %"pow_loop_end.3"
pow_loop_body.3:
  %".49" = load i32, i32* %"pow_result.3"
  %".50" = mul i32 %".49", 4
  store i32 %".50", i32* %"pow_result.3"
  %".52" = sub i32 %".46", 1
  store i32 %".52", i32* %"pow_counter.3"
  br label %"pow_loop_cond.3"
pow_loop_end.3:
  %"pow_result_val.3" = load i32, i32* %"pow_result.3"
  %"multmp.3" = mul i32 3, %"pow_result_val.3"
  %"addtmp.3" = add i32 %"divtmp.2", %"multmp.3"
  store i32 %"addtmp.3", i32* %"complex"
  %"negtmp.5" = sub i32 0, 2
  %"pow_result.4" = alloca i32
  store i32 1, i32* %"pow_result.4"
  %"pow_counter.4" = alloca i32
  store i32 %"negtmp.5", i32* %"pow_counter.4"
  br label %"pow_loop_cond.4"
pow_loop_cond.4:
  %".59" = load i32, i32* %"pow_counter.4"
  %".60" = icmp sgt i32 %".59", 0
  br i1 %".60", label %"pow_loop_body.4", label %"pow_loop_end.4"
pow_loop_body.4:
  %".62" = load i32, i32* %"pow_result.4"
  %".63" = mul i32 %".62", 2
  store i32 %".63", i32* %"pow_result.4"
  %".65" = sub i32 %".59", 1
  store i32 %".65", i32* %"pow_counter.4"
  br label %"pow_loop_cond.4"
pow_loop_end.4:
  %"pow_result_val.4" = load i32, i32* %"pow_result.4"
  %"multmp.4" = mul i32 8, %"pow_result_val.4"
  %"divtmp.3" = sdiv i32 %"multmp.4", 2
  %"addtmp.4" = add i32 3, 1
  %"pow_result.5" = alloca i32
  store i32 1, i32* %"pow_result.5"
  %"pow_counter.5" = alloca i32
  store i32 %"addtmp.4", i32* %"pow_counter.5"
  br label %"pow_loop_cond.5"
pow_loop_cond.5:
  %".71" = load i32, i32* %"pow_counter.5"
  %".72" = icmp sgt i32 %".71", 0
  br i1 %".72", label %"pow_loop_body.5", label %"pow_loop_end.5"
pow_loop_body.5:
  %".74" = load i32, i32* %"pow_result.5"
  %".75" = mul i32 %".74", 4
  store i32 %".75", i32* %"pow_result.5"
  %".77" = sub i32 %".71", 1
  store i32 %".77", i32* %"pow_counter.5"
  br label %"pow_loop_cond.5"
pow_loop_end.5:
  %"pow_result_val.5" = load i32, i32* %"pow_result.5"
  %"multmp.5" = mul i32 3, %"pow_result_val.5"
  %"addtmp.5" = add i32 %"divtmp.3", %"multmp.5"
  %"complex_val" = load i32, i32* %"complex"
  %"fmtptr.6" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.6" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.6", i32 %"complex_val")
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
