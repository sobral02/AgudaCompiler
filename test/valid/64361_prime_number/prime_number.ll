; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"is_prime"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"result" = alloca i1
  store i1 1, i1* %"result"
  %"n_val" = load i32, i32* %"n_ptr"
  %"cmptmp" = icmp slt i32 %"n_val", 2
  br i1 %"cmptmp", label %"then", label %"else"
then:
  store i1 0, i1* %"result"
  br label %"merge"
else:
  %"i" = alloca i32
  store i32 2, i32* %"i"
  br label %"loop.cond"
merge:
  %"result_val" = load i1, i1* %"result"
  ret i1 %"result_val"
loop.cond:
  %"i_val" = load i32, i32* %"i"
  %"i_val.1" = load i32, i32* %"i"
  %"multmp" = mul i32 %"i_val", %"i_val.1"
  %"n_val.1" = load i32, i32* %"n_ptr"
  %"cmptmp.1" = icmp sle i32 %"multmp", %"n_val.1"
  br i1 %"cmptmp.1", label %"loop.body", label %"loop.end"
loop.body:
  %"n_val.2" = load i32, i32* %"n_ptr"
  %"i_val.2" = load i32, i32* %"i"
  %"remtmp" = srem i32 %"n_val.2", %"i_val.2"
  %"cmptmp.2" = icmp eq i32 %"remtmp", 0
  br i1 %"cmptmp.2", label %"then.1", label %"else.1"
loop.end:
  br label %"merge"
then.1:
  store i1 0, i1* %"result"
  br label %"merge.1"
else.1:
  br label %"merge.1"
merge.1:
  %"i_val.3" = load i32, i32* %"i"
  %"addtmp" = add i32 %"i_val.3", 1
  store i32 %"addtmp", i32* %"i"
  br label %"loop.cond"
}

define void @"aguda_main"()
{
entry:
  %"is_prime_call" = call i1 @"is_prime"(i32 1)
  br i1 %"is_prime_call", label %"print_true", label %"print_false"
print_true:
  %".3" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".4" = call i32 (i8*, ...) @"printf"(i8* %".3")
  br label %"print_end"
print_false:
  %".6" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".7" = call i32 (i8*, ...) @"printf"(i8* %".6")
  br label %"print_end"
print_end:
  %"is_prime_call.1" = call i1 @"is_prime"(i32 2)
  br i1 %"is_prime_call.1", label %"print_true.1", label %"print_false.1"
print_true.1:
  %".10" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".11" = call i32 (i8*, ...) @"printf"(i8* %".10")
  br label %"print_end.1"
print_false.1:
  %".13" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".14" = call i32 (i8*, ...) @"printf"(i8* %".13")
  br label %"print_end.1"
print_end.1:
  %"is_prime_call.2" = call i1 @"is_prime"(i32 9)
  br i1 %"is_prime_call.2", label %"print_true.2", label %"print_false.2"
print_true.2:
  %".17" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".18" = call i32 (i8*, ...) @"printf"(i8* %".17")
  br label %"print_end.2"
print_false.2:
  %".20" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".21" = call i32 (i8*, ...) @"printf"(i8* %".20")
  br label %"print_end.2"
print_end.2:
  %"is_prime_call.3" = call i1 @"is_prime"(i32 13)
  br i1 %"is_prime_call.3", label %"print_true.3", label %"print_false.3"
print_true.3:
  %".24" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".25" = call i32 (i8*, ...) @"printf"(i8* %".24")
  br label %"print_end.3"
print_false.3:
  %".27" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".28" = call i32 (i8*, ...) @"printf"(i8* %".27")
  br label %"print_end.3"
print_end.3:
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
