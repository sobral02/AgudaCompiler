import subprocess
from pathlib import Path
import contextlib
import io
import re

passed = 0
failed = 0

def run_test(agu_path):
    global passed, failed

    agu_path = Path(agu_path)
    ll_path = agu_path.with_suffix(".ll")
    expect_path = agu_path.with_suffix(".expect")

    try:
        f = io.StringIO()
        with contextlib.redirect_stdout(f):
            subprocess.run(
                ["python3", "src/aguda-cabal/aguda/main.py", str(agu_path)],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                check=True
            )
    except subprocess.CalledProcessError:
        print(f"[FAIL] {agu_path.name} - erro ao compilar")
        failed += 1
        return

    if not expect_path.exists():
        print(f"[FAIL] {agu_path.name} - ficheiro .expect não encontrado")
        failed += 1
        return

    expected = expect_path.read_text().splitlines()[0].strip()
    result = subprocess.run(["lli", str(ll_path)], capture_output=True, text=True)
    output = result.stdout.strip()

    if output == expected:
        print(f"[PASS] {agu_path.name} -> {output}")
        passed += 1
    else:
        print(f"[FAIL] {agu_path.name}")
        print(f"  Expected: {expected}")
        print(f"  Got     : {output}")
        failed += 1

def main():
    log_path = Path("test/test.log")
    if not log_path.exists():
        print("Ficheiro test.log não encontrado.")
        return

    valid_paths = []

    with open(log_path) as f:
        for line in f:
            if "[✔]" in line:
                match = re.search(r"(/.*?test/valid/.*?\.agu)", line)
                if match:
                    full_path = match.group(1)
                    rel_index = full_path.find("test/")
                    relative_path = full_path[rel_index:]
                    valid_paths.append(relative_path)

    print(f"🧪 A correr {len(valid_paths)} testes validados pelo professor...\n")
    for path in valid_paths:
        run_test(path)

    print("\n📊 Resumo dos Resultados:")
    print(f"  ✅ Passaram: {passed}")
    print(f"  ❌ Falharam: {failed}")
    print(f"  🔢 Total   : {passed + failed}")

if __name__ == "__main__":
    main()
