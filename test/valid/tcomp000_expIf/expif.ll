; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"aguda_main"()
{
entry:
  %"ola_global_val" = load i1, i1* @"ola"
  br i1 %"ola_global_val", label %"then", label %"else"
then:
  %"ola_global_val.1" = load i1, i1* @"ola"
  br label %"merge"
else:
  %"ola_global_val.2" = load i1, i1* @"ola"
  br label %"merge"
merge:
  %"iftmp" = phi  i1 [%"ola_global_val.1", %"then"], [%"ola_global_val.2", %"else"]
  br i1 %"iftmp", label %"then.1", label %"else.1"
then.1:
  %"ola_global_val.3" = load i1, i1* @"ola"
  br i1 %"ola_global_val.3", label %"then.2", label %"else.2"
else.1:
  %"ola_global_val.6" = load i1, i1* @"ola"
  br i1 %"ola_global_val.6", label %"then.3", label %"else.3"
merge.1:
  %"iftmp.3" = phi  i1 [%"iftmp.1", %"merge.2"], [%"iftmp.2", %"merge.3"]
  br i1 %"iftmp.3", label %"print_true", label %"print_false"
then.2:
  %"ola_global_val.4" = load i1, i1* @"ola"
  br label %"merge.2"
else.2:
  %"ola_global_val.5" = load i1, i1* @"ola"
  br label %"merge.2"
merge.2:
  %"iftmp.1" = phi  i1 [%"ola_global_val.4", %"then.2"], [%"ola_global_val.5", %"else.2"]
  br label %"merge.1"
then.3:
  %"ola_global_val.7" = load i1, i1* @"ola"
  br label %"merge.3"
else.3:
  %"ola_global_val.8" = load i1, i1* @"ola"
  br label %"merge.3"
merge.3:
  %"iftmp.2" = phi  i1 [%"ola_global_val.7", %"then.3"], [%"ola_global_val.8", %"else.3"]
  br label %"merge.1"
print_true:
  %".15" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".16" = call i32 (i8*, ...) @"printf"(i8* %".15")
  br label %"print_end"
print_false:
  %".18" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".19" = call i32 (i8*, ...) @"printf"(i8* %".18")
  br label %"print_end"
print_end:
  ret void
}

@"ola" = internal global i1 0
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
