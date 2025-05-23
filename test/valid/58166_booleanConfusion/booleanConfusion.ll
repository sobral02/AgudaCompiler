; ModuleID = "aguda_module"
target triple = "arm64-apple-darwin22.6.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define i1 @"booleanConfusion"()
{
entry:
  %"a" = alloca i1
  store i1 1, i1* %"a"
  %"b" = alloca i1
  store i1 0, i1* %"b"
  %"c" = alloca i1
  %"a_val" = load i1, i1* %"a"
  %"nottmp" = icmp eq i1 %"a_val", 0
  store i1 %"nottmp", i1* %"c"
  %"a_val.1" = load i1, i1* %"a"
  %"nottmp.1" = icmp eq i1 %"a_val.1", 0
  %"d" = alloca i1
  %"b_val" = load i1, i1* %"b"
  %"nottmp.2" = icmp eq i1 %"b_val", 0
  store i1 %"nottmp.2", i1* %"d"
  %"b_val.1" = load i1, i1* %"b"
  %"nottmp.3" = icmp eq i1 %"b_val.1", 0
  %"e" = alloca i1
  %"a_val.2" = load i1, i1* %"a"
  %"b_val.2" = load i1, i1* %"b"
  br i1 %"a_val.2", label %"and_rhs", label %"and_merge"
and_rhs:
  %"b_val.3" = load i1, i1* %"b"
  br label %"and_merge"
and_merge:
  %"and_result" = phi  i1 [0, %"entry"], [%"b_val.3", %"and_rhs"]
  store i1 %"and_result", i1* %"e"
  %"a_val.3" = load i1, i1* %"a"
  %"b_val.4" = load i1, i1* %"b"
  br i1 %"a_val.3", label %"and_rhs.1", label %"and_merge.1"
and_rhs.1:
  %"b_val.5" = load i1, i1* %"b"
  br label %"and_merge.1"
and_merge.1:
  %"and_result.1" = phi  i1 [0, %"and_merge"], [%"b_val.5", %"and_rhs.1"]
  %"f" = alloca i1
  %"a_val.4" = load i1, i1* %"a"
  %"b_val.6" = load i1, i1* %"b"
  br i1 %"a_val.4", label %"or_merge", label %"or_rhs"
or_rhs:
  %"b_val.7" = load i1, i1* %"b"
  br label %"or_merge"
or_merge:
  %"or_result" = phi  i1 [1, %"and_merge.1"], [%"b_val.7", %"or_rhs"]
  store i1 %"or_result", i1* %"f"
  %"a_val.5" = load i1, i1* %"a"
  %"b_val.8" = load i1, i1* %"b"
  br i1 %"a_val.5", label %"or_merge.1", label %"or_rhs.1"
or_rhs.1:
  %"b_val.9" = load i1, i1* %"b"
  br label %"or_merge.1"
or_merge.1:
  %"or_result.1" = phi  i1 [1, %"or_merge"], [%"b_val.9", %"or_rhs.1"]
  %"g" = alloca i1
  %"a_val.6" = load i1, i1* %"a"
  %"b_val.10" = load i1, i1* %"b"
  br i1 %"a_val.6", label %"and_rhs.2", label %"and_merge.2"
and_rhs.2:
  %"b_val.11" = load i1, i1* %"b"
  br label %"and_merge.2"
and_merge.2:
  %"and_result.2" = phi  i1 [0, %"or_merge.1"], [%"b_val.11", %"and_rhs.2"]
  %"nottmp.4" = icmp eq i1 %"and_result.2", 0
  store i1 %"nottmp.4", i1* %"g"
  %"a_val.7" = load i1, i1* %"a"
  %"b_val.12" = load i1, i1* %"b"
  br i1 %"a_val.7", label %"and_rhs.3", label %"and_merge.3"
and_rhs.3:
  %"b_val.13" = load i1, i1* %"b"
  br label %"and_merge.3"
and_merge.3:
  %"and_result.3" = phi  i1 [0, %"and_merge.2"], [%"b_val.13", %"and_rhs.3"]
  %"nottmp.5" = icmp eq i1 %"and_result.3", 0
  %"h" = alloca i1
  %"a_val.8" = load i1, i1* %"a"
  %"b_val.14" = load i1, i1* %"b"
  br i1 %"a_val.8", label %"or_merge.2", label %"or_rhs.2"
or_rhs.2:
  %"b_val.15" = load i1, i1* %"b"
  br label %"or_merge.2"
or_merge.2:
  %"or_result.2" = phi  i1 [1, %"and_merge.3"], [%"b_val.15", %"or_rhs.2"]
  %"nottmp.6" = icmp eq i1 %"or_result.2", 0
  store i1 %"nottmp.6", i1* %"h"
  %"a_val.9" = load i1, i1* %"a"
  %"b_val.16" = load i1, i1* %"b"
  br i1 %"a_val.9", label %"or_merge.3", label %"or_rhs.3"
or_rhs.3:
  %"b_val.17" = load i1, i1* %"b"
  br label %"or_merge.3"
or_merge.3:
  %"or_result.3" = phi  i1 [1, %"or_merge.2"], [%"b_val.17", %"or_rhs.3"]
  %"nottmp.7" = icmp eq i1 %"or_result.3", 0
  %"i" = alloca i1
  %"a_val.10" = load i1, i1* %"a"
  %"g_val" = load i1, i1* %"g"
  br i1 %"a_val.10", label %"and_rhs.4", label %"and_merge.4"
and_rhs.4:
  %"g_val.1" = load i1, i1* %"g"
  br label %"and_merge.4"
and_merge.4:
  %"and_result.4" = phi  i1 [0, %"or_merge.3"], [%"g_val.1", %"and_rhs.4"]
  store i1 %"and_result.4", i1* %"i"
  %"a_val.11" = load i1, i1* %"a"
  %"g_val.2" = load i1, i1* %"g"
  br i1 %"a_val.11", label %"and_rhs.5", label %"and_merge.5"
and_rhs.5:
  %"g_val.3" = load i1, i1* %"g"
  br label %"and_merge.5"
and_merge.5:
  %"and_result.5" = phi  i1 [0, %"and_merge.4"], [%"g_val.3", %"and_rhs.5"]
  %"j" = alloca i1
  %"a_val.12" = load i1, i1* %"a"
  %"c_val" = load i1, i1* %"c"
  br i1 %"a_val.12", label %"or_merge.4", label %"or_rhs.4"
or_rhs.4:
  %"c_val.1" = load i1, i1* %"c"
  br label %"or_merge.4"
or_merge.4:
  %"or_result.4" = phi  i1 [1, %"and_merge.5"], [%"c_val.1", %"or_rhs.4"]
  %"d_val" = load i1, i1* %"d"
  br i1 %"or_result.4", label %"and_rhs.6", label %"and_merge.6"
and_rhs.6:
  %"d_val.1" = load i1, i1* %"d"
  br label %"and_merge.6"
and_merge.6:
  %"and_result.6" = phi  i1 [0, %"or_merge.4"], [%"d_val.1", %"and_rhs.6"]
  %"f_val" = load i1, i1* %"f"
  %"d_val.2" = load i1, i1* %"d"
  %"h_val" = load i1, i1* %"h"
  %"c_val.2" = load i1, i1* %"c"
  %"i_val" = load i1, i1* %"i"
  br i1 %"c_val.2", label %"or_merge.5", label %"or_rhs.5"
or_rhs.5:
  %"i_val.1" = load i1, i1* %"i"
  br label %"or_merge.5"
or_merge.5:
  %"or_result.5" = phi  i1 [1, %"and_merge.6"], [%"i_val.1", %"or_rhs.5"]
  br i1 %"h_val", label %"and_rhs.7", label %"and_merge.7"
and_rhs.7:
  %"c_val.3" = load i1, i1* %"c"
  %"i_val.2" = load i1, i1* %"i"
  br i1 %"c_val.3", label %"or_merge.6", label %"or_rhs.6"
and_merge.7:
  %"and_result.7" = phi  i1 [0, %"or_merge.5"], [%"or_result.6", %"or_merge.6"]
  br i1 %"d_val.2", label %"or_merge.7", label %"or_rhs.7"
or_rhs.6:
  %"i_val.3" = load i1, i1* %"i"
  br label %"or_merge.6"
or_merge.6:
  %"or_result.6" = phi  i1 [1, %"and_rhs.7"], [%"i_val.3", %"or_rhs.6"]
  br label %"and_merge.7"
or_rhs.7:
  %"h_val.1" = load i1, i1* %"h"
  %"c_val.4" = load i1, i1* %"c"
  %"i_val.4" = load i1, i1* %"i"
  br i1 %"c_val.4", label %"or_merge.8", label %"or_rhs.8"
or_merge.7:
  %"or_result.9" = phi  i1 [1, %"and_merge.7"], [%"and_result.8", %"and_merge.8"]
  br i1 %"f_val", label %"and_rhs.9", label %"and_merge.9"
or_rhs.8:
  %"i_val.5" = load i1, i1* %"i"
  br label %"or_merge.8"
or_merge.8:
  %"or_result.7" = phi  i1 [1, %"or_rhs.7"], [%"i_val.5", %"or_rhs.8"]
  br i1 %"h_val.1", label %"and_rhs.8", label %"and_merge.8"
and_rhs.8:
  %"c_val.5" = load i1, i1* %"c"
  %"i_val.6" = load i1, i1* %"i"
  br i1 %"c_val.5", label %"or_merge.9", label %"or_rhs.9"
and_merge.8:
  %"and_result.8" = phi  i1 [0, %"or_merge.8"], [%"or_result.8", %"or_merge.9"]
  br label %"or_merge.7"
or_rhs.9:
  %"i_val.7" = load i1, i1* %"i"
  br label %"or_merge.9"
or_merge.9:
  %"or_result.8" = phi  i1 [1, %"and_rhs.8"], [%"i_val.7", %"or_rhs.9"]
  br label %"and_merge.8"
and_rhs.9:
  %"d_val.3" = load i1, i1* %"d"
  %"h_val.2" = load i1, i1* %"h"
  %"c_val.6" = load i1, i1* %"c"
  %"i_val.8" = load i1, i1* %"i"
  br i1 %"c_val.6", label %"or_merge.10", label %"or_rhs.10"
and_merge.9:
  %"and_result.11" = phi  i1 [0, %"or_merge.7"], [%"or_result.14", %"or_merge.12"]
  br i1 %"and_result.6", label %"or_merge.15", label %"or_rhs.15"
or_rhs.10:
  %"i_val.9" = load i1, i1* %"i"
  br label %"or_merge.10"
or_merge.10:
  %"or_result.10" = phi  i1 [1, %"and_rhs.9"], [%"i_val.9", %"or_rhs.10"]
  br i1 %"h_val.2", label %"and_rhs.10", label %"and_merge.10"
and_rhs.10:
  %"c_val.7" = load i1, i1* %"c"
  %"i_val.10" = load i1, i1* %"i"
  br i1 %"c_val.7", label %"or_merge.11", label %"or_rhs.11"
and_merge.10:
  %"and_result.9" = phi  i1 [0, %"or_merge.10"], [%"or_result.11", %"or_merge.11"]
  br i1 %"d_val.3", label %"or_merge.12", label %"or_rhs.12"
or_rhs.11:
  %"i_val.11" = load i1, i1* %"i"
  br label %"or_merge.11"
or_merge.11:
  %"or_result.11" = phi  i1 [1, %"and_rhs.10"], [%"i_val.11", %"or_rhs.11"]
  br label %"and_merge.10"
or_rhs.12:
  %"h_val.3" = load i1, i1* %"h"
  %"c_val.8" = load i1, i1* %"c"
  %"i_val.12" = load i1, i1* %"i"
  br i1 %"c_val.8", label %"or_merge.13", label %"or_rhs.13"
or_merge.12:
  %"or_result.14" = phi  i1 [1, %"and_merge.10"], [%"and_result.10", %"and_merge.11"]
  br label %"and_merge.9"
or_rhs.13:
  %"i_val.13" = load i1, i1* %"i"
  br label %"or_merge.13"
or_merge.13:
  %"or_result.12" = phi  i1 [1, %"or_rhs.12"], [%"i_val.13", %"or_rhs.13"]
  br i1 %"h_val.3", label %"and_rhs.11", label %"and_merge.11"
and_rhs.11:
  %"c_val.9" = load i1, i1* %"c"
  %"i_val.14" = load i1, i1* %"i"
  br i1 %"c_val.9", label %"or_merge.14", label %"or_rhs.14"
and_merge.11:
  %"and_result.10" = phi  i1 [0, %"or_merge.13"], [%"or_result.13", %"or_merge.14"]
  br label %"or_merge.12"
or_rhs.14:
  %"i_val.15" = load i1, i1* %"i"
  br label %"or_merge.14"
or_merge.14:
  %"or_result.13" = phi  i1 [1, %"and_rhs.11"], [%"i_val.15", %"or_rhs.14"]
  br label %"and_merge.11"
or_rhs.15:
  %"f_val.1" = load i1, i1* %"f"
  %"d_val.4" = load i1, i1* %"d"
  %"h_val.4" = load i1, i1* %"h"
  %"c_val.10" = load i1, i1* %"c"
  %"i_val.16" = load i1, i1* %"i"
  br i1 %"c_val.10", label %"or_merge.16", label %"or_rhs.16"
or_merge.15:
  %"or_result.25" = phi  i1 [1, %"and_merge.9"], [%"and_result.16", %"and_merge.14"]
  store i1 %"or_result.25", i1* %"j"
  %"a_val.13" = load i1, i1* %"a"
  %"c_val.18" = load i1, i1* %"c"
  br i1 %"a_val.13", label %"or_merge.26", label %"or_rhs.26"
or_rhs.16:
  %"i_val.17" = load i1, i1* %"i"
  br label %"or_merge.16"
or_merge.16:
  %"or_result.15" = phi  i1 [1, %"or_rhs.15"], [%"i_val.17", %"or_rhs.16"]
  br i1 %"h_val.4", label %"and_rhs.12", label %"and_merge.12"
and_rhs.12:
  %"c_val.11" = load i1, i1* %"c"
  %"i_val.18" = load i1, i1* %"i"
  br i1 %"c_val.11", label %"or_merge.17", label %"or_rhs.17"
and_merge.12:
  %"and_result.12" = phi  i1 [0, %"or_merge.16"], [%"or_result.16", %"or_merge.17"]
  br i1 %"d_val.4", label %"or_merge.18", label %"or_rhs.18"
or_rhs.17:
  %"i_val.19" = load i1, i1* %"i"
  br label %"or_merge.17"
or_merge.17:
  %"or_result.16" = phi  i1 [1, %"and_rhs.12"], [%"i_val.19", %"or_rhs.17"]
  br label %"and_merge.12"
or_rhs.18:
  %"h_val.5" = load i1, i1* %"h"
  %"c_val.12" = load i1, i1* %"c"
  %"i_val.20" = load i1, i1* %"i"
  br i1 %"c_val.12", label %"or_merge.19", label %"or_rhs.19"
or_merge.18:
  %"or_result.19" = phi  i1 [1, %"and_merge.12"], [%"and_result.13", %"and_merge.13"]
  br i1 %"f_val.1", label %"and_rhs.14", label %"and_merge.14"
or_rhs.19:
  %"i_val.21" = load i1, i1* %"i"
  br label %"or_merge.19"
or_merge.19:
  %"or_result.17" = phi  i1 [1, %"or_rhs.18"], [%"i_val.21", %"or_rhs.19"]
  br i1 %"h_val.5", label %"and_rhs.13", label %"and_merge.13"
and_rhs.13:
  %"c_val.13" = load i1, i1* %"c"
  %"i_val.22" = load i1, i1* %"i"
  br i1 %"c_val.13", label %"or_merge.20", label %"or_rhs.20"
and_merge.13:
  %"and_result.13" = phi  i1 [0, %"or_merge.19"], [%"or_result.18", %"or_merge.20"]
  br label %"or_merge.18"
or_rhs.20:
  %"i_val.23" = load i1, i1* %"i"
  br label %"or_merge.20"
or_merge.20:
  %"or_result.18" = phi  i1 [1, %"and_rhs.13"], [%"i_val.23", %"or_rhs.20"]
  br label %"and_merge.13"
and_rhs.14:
  %"d_val.5" = load i1, i1* %"d"
  %"h_val.6" = load i1, i1* %"h"
  %"c_val.14" = load i1, i1* %"c"
  %"i_val.24" = load i1, i1* %"i"
  br i1 %"c_val.14", label %"or_merge.21", label %"or_rhs.21"
and_merge.14:
  %"and_result.16" = phi  i1 [0, %"or_merge.18"], [%"or_result.24", %"or_merge.23"]
  br label %"or_merge.15"
or_rhs.21:
  %"i_val.25" = load i1, i1* %"i"
  br label %"or_merge.21"
or_merge.21:
  %"or_result.20" = phi  i1 [1, %"and_rhs.14"], [%"i_val.25", %"or_rhs.21"]
  br i1 %"h_val.6", label %"and_rhs.15", label %"and_merge.15"
and_rhs.15:
  %"c_val.15" = load i1, i1* %"c"
  %"i_val.26" = load i1, i1* %"i"
  br i1 %"c_val.15", label %"or_merge.22", label %"or_rhs.22"
and_merge.15:
  %"and_result.14" = phi  i1 [0, %"or_merge.21"], [%"or_result.21", %"or_merge.22"]
  br i1 %"d_val.5", label %"or_merge.23", label %"or_rhs.23"
or_rhs.22:
  %"i_val.27" = load i1, i1* %"i"
  br label %"or_merge.22"
or_merge.22:
  %"or_result.21" = phi  i1 [1, %"and_rhs.15"], [%"i_val.27", %"or_rhs.22"]
  br label %"and_merge.15"
or_rhs.23:
  %"h_val.7" = load i1, i1* %"h"
  %"c_val.16" = load i1, i1* %"c"
  %"i_val.28" = load i1, i1* %"i"
  br i1 %"c_val.16", label %"or_merge.24", label %"or_rhs.24"
or_merge.23:
  %"or_result.24" = phi  i1 [1, %"and_merge.15"], [%"and_result.15", %"and_merge.16"]
  br label %"and_merge.14"
or_rhs.24:
  %"i_val.29" = load i1, i1* %"i"
  br label %"or_merge.24"
or_merge.24:
  %"or_result.22" = phi  i1 [1, %"or_rhs.23"], [%"i_val.29", %"or_rhs.24"]
  br i1 %"h_val.7", label %"and_rhs.16", label %"and_merge.16"
and_rhs.16:
  %"c_val.17" = load i1, i1* %"c"
  %"i_val.30" = load i1, i1* %"i"
  br i1 %"c_val.17", label %"or_merge.25", label %"or_rhs.25"
and_merge.16:
  %"and_result.15" = phi  i1 [0, %"or_merge.24"], [%"or_result.23", %"or_merge.25"]
  br label %"or_merge.23"
or_rhs.25:
  %"i_val.31" = load i1, i1* %"i"
  br label %"or_merge.25"
or_merge.25:
  %"or_result.23" = phi  i1 [1, %"and_rhs.16"], [%"i_val.31", %"or_rhs.25"]
  br label %"and_merge.16"
or_rhs.26:
  %"c_val.19" = load i1, i1* %"c"
  br label %"or_merge.26"
or_merge.26:
  %"or_result.26" = phi  i1 [1, %"or_merge.15"], [%"c_val.19", %"or_rhs.26"]
  %"d_val.6" = load i1, i1* %"d"
  br i1 %"or_result.26", label %"and_rhs.17", label %"and_merge.17"
and_rhs.17:
  %"d_val.7" = load i1, i1* %"d"
  br label %"and_merge.17"
and_merge.17:
  %"and_result.17" = phi  i1 [0, %"or_merge.26"], [%"d_val.7", %"and_rhs.17"]
  %"f_val.2" = load i1, i1* %"f"
  %"d_val.8" = load i1, i1* %"d"
  %"h_val.8" = load i1, i1* %"h"
  %"c_val.20" = load i1, i1* %"c"
  %"i_val.32" = load i1, i1* %"i"
  br i1 %"c_val.20", label %"or_merge.27", label %"or_rhs.27"
or_rhs.27:
  %"i_val.33" = load i1, i1* %"i"
  br label %"or_merge.27"
or_merge.27:
  %"or_result.27" = phi  i1 [1, %"and_merge.17"], [%"i_val.33", %"or_rhs.27"]
  br i1 %"h_val.8", label %"and_rhs.18", label %"and_merge.18"
and_rhs.18:
  %"c_val.21" = load i1, i1* %"c"
  %"i_val.34" = load i1, i1* %"i"
  br i1 %"c_val.21", label %"or_merge.28", label %"or_rhs.28"
and_merge.18:
  %"and_result.18" = phi  i1 [0, %"or_merge.27"], [%"or_result.28", %"or_merge.28"]
  br i1 %"d_val.8", label %"or_merge.29", label %"or_rhs.29"
or_rhs.28:
  %"i_val.35" = load i1, i1* %"i"
  br label %"or_merge.28"
or_merge.28:
  %"or_result.28" = phi  i1 [1, %"and_rhs.18"], [%"i_val.35", %"or_rhs.28"]
  br label %"and_merge.18"
or_rhs.29:
  %"h_val.9" = load i1, i1* %"h"
  %"c_val.22" = load i1, i1* %"c"
  %"i_val.36" = load i1, i1* %"i"
  br i1 %"c_val.22", label %"or_merge.30", label %"or_rhs.30"
or_merge.29:
  %"or_result.31" = phi  i1 [1, %"and_merge.18"], [%"and_result.19", %"and_merge.19"]
  br i1 %"f_val.2", label %"and_rhs.20", label %"and_merge.20"
or_rhs.30:
  %"i_val.37" = load i1, i1* %"i"
  br label %"or_merge.30"
or_merge.30:
  %"or_result.29" = phi  i1 [1, %"or_rhs.29"], [%"i_val.37", %"or_rhs.30"]
  br i1 %"h_val.9", label %"and_rhs.19", label %"and_merge.19"
and_rhs.19:
  %"c_val.23" = load i1, i1* %"c"
  %"i_val.38" = load i1, i1* %"i"
  br i1 %"c_val.23", label %"or_merge.31", label %"or_rhs.31"
and_merge.19:
  %"and_result.19" = phi  i1 [0, %"or_merge.30"], [%"or_result.30", %"or_merge.31"]
  br label %"or_merge.29"
or_rhs.31:
  %"i_val.39" = load i1, i1* %"i"
  br label %"or_merge.31"
or_merge.31:
  %"or_result.30" = phi  i1 [1, %"and_rhs.19"], [%"i_val.39", %"or_rhs.31"]
  br label %"and_merge.19"
and_rhs.20:
  %"d_val.9" = load i1, i1* %"d"
  %"h_val.10" = load i1, i1* %"h"
  %"c_val.24" = load i1, i1* %"c"
  %"i_val.40" = load i1, i1* %"i"
  br i1 %"c_val.24", label %"or_merge.32", label %"or_rhs.32"
and_merge.20:
  %"and_result.22" = phi  i1 [0, %"or_merge.29"], [%"or_result.36", %"or_merge.34"]
  br i1 %"and_result.17", label %"or_merge.37", label %"or_rhs.37"
or_rhs.32:
  %"i_val.41" = load i1, i1* %"i"
  br label %"or_merge.32"
or_merge.32:
  %"or_result.32" = phi  i1 [1, %"and_rhs.20"], [%"i_val.41", %"or_rhs.32"]
  br i1 %"h_val.10", label %"and_rhs.21", label %"and_merge.21"
and_rhs.21:
  %"c_val.25" = load i1, i1* %"c"
  %"i_val.42" = load i1, i1* %"i"
  br i1 %"c_val.25", label %"or_merge.33", label %"or_rhs.33"
and_merge.21:
  %"and_result.20" = phi  i1 [0, %"or_merge.32"], [%"or_result.33", %"or_merge.33"]
  br i1 %"d_val.9", label %"or_merge.34", label %"or_rhs.34"
or_rhs.33:
  %"i_val.43" = load i1, i1* %"i"
  br label %"or_merge.33"
or_merge.33:
  %"or_result.33" = phi  i1 [1, %"and_rhs.21"], [%"i_val.43", %"or_rhs.33"]
  br label %"and_merge.21"
or_rhs.34:
  %"h_val.11" = load i1, i1* %"h"
  %"c_val.26" = load i1, i1* %"c"
  %"i_val.44" = load i1, i1* %"i"
  br i1 %"c_val.26", label %"or_merge.35", label %"or_rhs.35"
or_merge.34:
  %"or_result.36" = phi  i1 [1, %"and_merge.21"], [%"and_result.21", %"and_merge.22"]
  br label %"and_merge.20"
or_rhs.35:
  %"i_val.45" = load i1, i1* %"i"
  br label %"or_merge.35"
or_merge.35:
  %"or_result.34" = phi  i1 [1, %"or_rhs.34"], [%"i_val.45", %"or_rhs.35"]
  br i1 %"h_val.11", label %"and_rhs.22", label %"and_merge.22"
and_rhs.22:
  %"c_val.27" = load i1, i1* %"c"
  %"i_val.46" = load i1, i1* %"i"
  br i1 %"c_val.27", label %"or_merge.36", label %"or_rhs.36"
and_merge.22:
  %"and_result.21" = phi  i1 [0, %"or_merge.35"], [%"or_result.35", %"or_merge.36"]
  br label %"or_merge.34"
or_rhs.36:
  %"i_val.47" = load i1, i1* %"i"
  br label %"or_merge.36"
or_merge.36:
  %"or_result.35" = phi  i1 [1, %"and_rhs.22"], [%"i_val.47", %"or_rhs.36"]
  br label %"and_merge.22"
or_rhs.37:
  %"f_val.3" = load i1, i1* %"f"
  %"d_val.10" = load i1, i1* %"d"
  %"h_val.12" = load i1, i1* %"h"
  %"c_val.28" = load i1, i1* %"c"
  %"i_val.48" = load i1, i1* %"i"
  br i1 %"c_val.28", label %"or_merge.38", label %"or_rhs.38"
or_merge.37:
  %"or_result.47" = phi  i1 [1, %"and_merge.20"], [%"and_result.27", %"and_merge.25"]
  %"j_val" = load i1, i1* %"j"
  ret i1 %"j_val"
or_rhs.38:
  %"i_val.49" = load i1, i1* %"i"
  br label %"or_merge.38"
or_merge.38:
  %"or_result.37" = phi  i1 [1, %"or_rhs.37"], [%"i_val.49", %"or_rhs.38"]
  br i1 %"h_val.12", label %"and_rhs.23", label %"and_merge.23"
and_rhs.23:
  %"c_val.29" = load i1, i1* %"c"
  %"i_val.50" = load i1, i1* %"i"
  br i1 %"c_val.29", label %"or_merge.39", label %"or_rhs.39"
and_merge.23:
  %"and_result.23" = phi  i1 [0, %"or_merge.38"], [%"or_result.38", %"or_merge.39"]
  br i1 %"d_val.10", label %"or_merge.40", label %"or_rhs.40"
or_rhs.39:
  %"i_val.51" = load i1, i1* %"i"
  br label %"or_merge.39"
or_merge.39:
  %"or_result.38" = phi  i1 [1, %"and_rhs.23"], [%"i_val.51", %"or_rhs.39"]
  br label %"and_merge.23"
or_rhs.40:
  %"h_val.13" = load i1, i1* %"h"
  %"c_val.30" = load i1, i1* %"c"
  %"i_val.52" = load i1, i1* %"i"
  br i1 %"c_val.30", label %"or_merge.41", label %"or_rhs.41"
or_merge.40:
  %"or_result.41" = phi  i1 [1, %"and_merge.23"], [%"and_result.24", %"and_merge.24"]
  br i1 %"f_val.3", label %"and_rhs.25", label %"and_merge.25"
or_rhs.41:
  %"i_val.53" = load i1, i1* %"i"
  br label %"or_merge.41"
or_merge.41:
  %"or_result.39" = phi  i1 [1, %"or_rhs.40"], [%"i_val.53", %"or_rhs.41"]
  br i1 %"h_val.13", label %"and_rhs.24", label %"and_merge.24"
and_rhs.24:
  %"c_val.31" = load i1, i1* %"c"
  %"i_val.54" = load i1, i1* %"i"
  br i1 %"c_val.31", label %"or_merge.42", label %"or_rhs.42"
and_merge.24:
  %"and_result.24" = phi  i1 [0, %"or_merge.41"], [%"or_result.40", %"or_merge.42"]
  br label %"or_merge.40"
or_rhs.42:
  %"i_val.55" = load i1, i1* %"i"
  br label %"or_merge.42"
or_merge.42:
  %"or_result.40" = phi  i1 [1, %"and_rhs.24"], [%"i_val.55", %"or_rhs.42"]
  br label %"and_merge.24"
and_rhs.25:
  %"d_val.11" = load i1, i1* %"d"
  %"h_val.14" = load i1, i1* %"h"
  %"c_val.32" = load i1, i1* %"c"
  %"i_val.56" = load i1, i1* %"i"
  br i1 %"c_val.32", label %"or_merge.43", label %"or_rhs.43"
and_merge.25:
  %"and_result.27" = phi  i1 [0, %"or_merge.40"], [%"or_result.46", %"or_merge.45"]
  br label %"or_merge.37"
or_rhs.43:
  %"i_val.57" = load i1, i1* %"i"
  br label %"or_merge.43"
or_merge.43:
  %"or_result.42" = phi  i1 [1, %"and_rhs.25"], [%"i_val.57", %"or_rhs.43"]
  br i1 %"h_val.14", label %"and_rhs.26", label %"and_merge.26"
and_rhs.26:
  %"c_val.33" = load i1, i1* %"c"
  %"i_val.58" = load i1, i1* %"i"
  br i1 %"c_val.33", label %"or_merge.44", label %"or_rhs.44"
and_merge.26:
  %"and_result.25" = phi  i1 [0, %"or_merge.43"], [%"or_result.43", %"or_merge.44"]
  br i1 %"d_val.11", label %"or_merge.45", label %"or_rhs.45"
or_rhs.44:
  %"i_val.59" = load i1, i1* %"i"
  br label %"or_merge.44"
or_merge.44:
  %"or_result.43" = phi  i1 [1, %"and_rhs.26"], [%"i_val.59", %"or_rhs.44"]
  br label %"and_merge.26"
or_rhs.45:
  %"h_val.15" = load i1, i1* %"h"
  %"c_val.34" = load i1, i1* %"c"
  %"i_val.60" = load i1, i1* %"i"
  br i1 %"c_val.34", label %"or_merge.46", label %"or_rhs.46"
or_merge.45:
  %"or_result.46" = phi  i1 [1, %"and_merge.26"], [%"and_result.26", %"and_merge.27"]
  br label %"and_merge.25"
or_rhs.46:
  %"i_val.61" = load i1, i1* %"i"
  br label %"or_merge.46"
or_merge.46:
  %"or_result.44" = phi  i1 [1, %"or_rhs.45"], [%"i_val.61", %"or_rhs.46"]
  br i1 %"h_val.15", label %"and_rhs.27", label %"and_merge.27"
and_rhs.27:
  %"c_val.35" = load i1, i1* %"c"
  %"i_val.62" = load i1, i1* %"i"
  br i1 %"c_val.35", label %"or_merge.47", label %"or_rhs.47"
and_merge.27:
  %"and_result.26" = phi  i1 [0, %"or_merge.46"], [%"or_result.45", %"or_merge.47"]
  br label %"or_merge.45"
or_rhs.47:
  %"i_val.63" = load i1, i1* %"i"
  br label %"or_merge.47"
or_merge.47:
  %"or_result.45" = phi  i1 [1, %"and_rhs.27"], [%"i_val.63", %"or_rhs.47"]
  br label %"and_merge.27"
}

define void @"aguda_main"()
{
entry:
  %"booleanConfusion_call" = call i1 @"booleanConfusion"()
  br i1 %"booleanConfusion_call", label %"print_true", label %"print_false"
print_true:
  %".3" = getelementptr [5 x i8], [5 x i8]* @".str_true", i32 0, i32 0
  %".4" = call i32 (i8*, ...) @"printf"(i8* %".3")
  br label %"print_end"
print_false:
  %".6" = getelementptr [6 x i8], [6 x i8]* @".str_false", i32 0, i32 0
  %".7" = call i32 (i8*, ...) @"printf"(i8* %".6")
  br label %"print_end"
print_end:
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
