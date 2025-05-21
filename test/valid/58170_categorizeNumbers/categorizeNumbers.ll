; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i32 @"categorizeNumber"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"result" = alloca i32
  store i32 0, i32* %"result"
  %"isEven" = alloca i1
  %"n_val" = load i32, i32* %"n_ptr"
  %"remtmp" = srem i32 %"n_val", 2
  %"cmptmp" = icmp eq i32 %"remtmp", 0
  store i1 %"cmptmp", i1* %"isEven"
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"remtmp.1" = srem i32 %"n_val.1", 2
  %"cmptmp.1" = icmp eq i32 %"remtmp.1", 0
  %"isPositive" = alloca i1
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"cmptmp.2" = icmp sgt i32 %"n_val.2", 0
  store i1 %"cmptmp.2", i1* %"isPositive"
  %"n_val.3" = load i32, i32* %"n_ptr"
  %"cmptmp.3" = icmp sgt i32 %"n_val.3", 0
  %"isBig" = alloca i1
  %"n_val.4" = load i32, i32* %"n_ptr"
  %"cmptmp.4" = icmp sgt i32 %"n_val.4", 100
  store i1 %"cmptmp.4", i1* %"isBig"
  %"n_val.5" = load i32, i32* %"n_ptr"
  %"cmptmp.5" = icmp sgt i32 %"n_val.5", 100
  %"isEven_val" = load i1, i1* %"isEven"
  br i1 %"isEven_val", label %"then", label %"else"
then:
  %"isPositive_val" = load i1, i1* %"isPositive"
  br i1 %"isPositive_val", label %"then.1", label %"else.1"
else:
  %"isPositive_val.1" = load i1, i1* %"isPositive"
  br i1 %"isPositive_val.1", label %"then.4", label %"else.4"
merge:
  %"n_val.7" = load i32, i32* %"n_ptr"
  %"remtmp.2" = srem i32 %"n_val.7", 5
  %"cmptmp.7" = icmp eq i32 %"remtmp.2", 0
  br i1 %"cmptmp.7", label %"then.5", label %"else.5"
then.1:
  %"isBig_val" = load i1, i1* %"isBig"
  br i1 %"isBig_val", label %"then.2", label %"else.2"
else.1:
  %"n_val.6" = load i32, i32* %"n_ptr"
  %"cmptmp.6" = icmp eq i32 %"n_val.6", 0
  br i1 %"cmptmp.6", label %"then.3", label %"else.3"
merge.1:
  br label %"merge"
then.2:
  store i32 1, i32* %"result"
  br label %"merge.2"
else.2:
  store i32 2, i32* %"result"
  br label %"merge.2"
merge.2:
  br label %"merge.1"
then.3:
  store i32 5, i32* %"result"
  br label %"merge.3"
else.3:
  store i32 3, i32* %"result"
  br label %"merge.3"
merge.3:
  br label %"merge.1"
then.4:
  store i32 4, i32* %"result"
  br label %"merge.4"
else.4:
  br label %"merge.4"
merge.4:
  br label %"merge"
then.5:
  store i32 6, i32* %"result"
  br label %"merge.5"
else.5:
  store i32 7, i32* %"result"
  br label %"merge.5"
merge.5:
  %"n_val.8" = load i32, i32* %"n_ptr"
  %"negtmp" = sub i32 0, 50
  %"cmptmp.8" = icmp slt i32 %"n_val.8", %"negtmp"
  br i1 %"cmptmp.8", label %"then.6", label %"else.6"
then.6:
  store i32 8, i32* %"result"
  br label %"merge.6"
else.6:
  br label %"merge.6"
merge.6:
  %"result_val" = load i32, i32* %"result"
  ret i32 %"result_val"
}

define void @"aguda_main"()
{
entry:
  %"categorizeNumber_call" = call i32 @"categorizeNumber"(i32 150)
  %"fmtptr" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr", i32 %"categorizeNumber_call")
  %"categorizeNumber_call.1" = call i32 @"categorizeNumber"(i32 24)
  %"fmtptr.1" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.1" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.1", i32 %"categorizeNumber_call.1")
  %"categorizeNumber_call.2" = call i32 @"categorizeNumber"(i32 0)
  %"fmtptr.2" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.2" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.2", i32 %"categorizeNumber_call.2")
  %"negtmp" = sub i32 0, 12
  %"categorizeNumber_call.3" = call i32 @"categorizeNumber"(i32 %"negtmp")
  %"fmtptr.3" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.3" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.3", i32 %"categorizeNumber_call.3")
  %"categorizeNumber_call.4" = call i32 @"categorizeNumber"(i32 15)
  %"fmtptr.4" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.4" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.4", i32 %"categorizeNumber_call.4")
  %"categorizeNumber_call.5" = call i32 @"categorizeNumber"(i32 7)
  %"fmtptr.5" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.5" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.5", i32 %"categorizeNumber_call.5")
  %"negtmp.1" = sub i32 0, 3
  %"categorizeNumber_call.6" = call i32 @"categorizeNumber"(i32 %"negtmp.1")
  %"fmtptr.6" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.6" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.6", i32 %"categorizeNumber_call.6")
  %"negtmp.2" = sub i32 0, 75
  %"categorizeNumber_call.7" = call i32 @"categorizeNumber"(i32 %"negtmp.2")
  %"fmtptr.7" = getelementptr [3 x i8], [3 x i8]* @".printf_fmt_int", i32 0, i32 0
  %"printf_call.7" = call i32 (i8*, ...) @"printf"(i8* %"fmtptr.7", i32 %"categorizeNumber_call.7")
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
