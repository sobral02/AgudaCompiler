import os
import re

# Ficheiros de input
prof_log_file = "test/test.log"
my_log_file = "meu_teste_output.log"

# 1. Parse Log do Professor
expected_results = {}

with open(prof_log_file, "r") as f:
    for line in f:
        line = line.strip()
        match = re.search(r'/valid/(.+\.agu)\s+\[(✔|✘)\]', line)
        if match:
            relative_path = match.group(1)
            result = match.group(2)
            expected_results[relative_path] = result

# 2. Parse o teu Log
actual_results = {}

with open(my_log_file, "r") as f:
    lines = f.readlines()

current_test = None
for line in lines:
    line = line.strip()
    match = re.match(r"=== Running (.+\.agu) ===", line)
    if match:
        current_test = match.group(1)
    elif "✅ OK" in line and current_test:
        actual_results[current_test] = "✔"
        current_test = None
    elif "❌ ERROR" in line and current_test:
        actual_results[current_test] = "✘"
        current_test = None

# 3. Comparar
print("\n--- Comparação ---\n")

ok = 0
fail = 0

all_files = set(expected_results.keys()) | set(actual_results.keys())

for file in sorted(all_files):
    expected = expected_results.get(file)
    actual = actual_results.get(file)

    if expected == actual:
        print(f"{file}: ✅ OK (esperado {expected}, obtido {actual})")
        ok += 1
    elif expected == "✘" and actual is None:
        print(f"{file}: ✅ OK (esperado {expected}, obtido MISSING)")
        ok += 1
    elif expected is None and actual == "✘":
        print(f"{file}: ✅ OK (esperado MISSING, obtido {actual})")
        ok += 1
    elif expected is None and actual == "✔":
        print(f"{file}: ✅ OK (esperado MISSING, obtido {actual})")
        ok += 1
    else:
        print(f"{file}: ❌ ERROR (esperado {expected if expected else 'MISSING'}, obtido {actual if actual else 'MISSING'})")
        fail += 1

# 4. Resumo
print("\nResumo Final:")
print(f"✔️  {ok} testes corretos")
print(f"❌  {fail} testes incorretos")
