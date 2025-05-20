; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define void @"storeWhile"(i32 %"n")
{
entry:
  %"n_ptr" = alloca i32
  store i32 %"n", i32* %"n_ptr"
  %"i" = alloca i32
  %"n_val" = load i32, i32* %"n_ptr"
  store i32 %"n_val", i32* %"i"
  ret void
}

define void @"aguda_main"()
{
entry:
  call void @"storeWhile"(i32 3)
  ret void
}

define i32 @"wrapper_main"()
{
entry:
  call void @"aguda_main"()
  ret i32 0
}

declare i32 @"printf"(i8* %".1", ...)

define i32 @"main"()
{
entry:
  %".2" = call i32 @"wrapper_main"()
  ret i32 %".2"
}
