; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"nrNegativoEPar"(i32 %"x")
{
entry:
  %"x_ptr" = alloca i32
  store i32 %"x", i32* %"x_ptr"
  %"x_val" = load i32, i32* %"x_ptr"
  %"cmptmp" = icmp slt i32 %"x_val", 0
  %"x_val.1" = load i32, i32* %"x_ptr"
  %"remtmp" = srem i32 %"x_val.1", 2
  %"cmptmp.1" = icmp eq i32 %"remtmp", 0
  br i1 %"cmptmp", label %"and_else", label %"and_then"
and_then:
  br label %"and_merge"
and_else:
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"and_then"], [%"cmptmp.1", %"and_else"]
  ret i1 %"and_result"
}

define i32 @"main"()
{
entry:
  ret i32 0
}
