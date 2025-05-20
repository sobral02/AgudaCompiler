import os
import subprocess
import re

# Diretório onde estão os testes
tests_dir = "test/valid"

# Caminho para o compilador
main_script = "src/aguda-cabal/aguda/main.py"

def extract_number(name):
    num_part = ""
    for c in name:
        if c.isdigit():
            num_part += c
        else:
            break
    return int(num_part) if num_part else float('inf')

def has_error(output):
    """Verifica se o output contém algum erro conhecido."""
    error_patterns = [
        r"Lexical Error",
        r"Syntax Error",
        r"Semantic Error"
    ]
    for pattern in error_patterns:
        if re.search(pattern, output, re.IGNORECASE):
            return True
    return False

# Apanha todas as pastas
folders = [f for f in os.listdir(tests_dir) if os.path.isdir(os.path.join(tests_dir, f))]

# Ordena pelo número
folders.sort(key=extract_number, reverse=True)

# Agora percorre em ordem
for folder in folders:
    folder_path = os.path.join(tests_dir, folder)
    for file in os.listdir(folder_path):
        if file.endswith(".agu"):
            relative_path = os.path.join(folder, file)  # <-- caminho relativo agora
            full_path = os.path.join(folder_path, file)

            print(f"\n=== Running {relative_path} ===")
            
            result = subprocess.run(["python3", main_script, full_path],
                                    capture_output=True, text=True)

            output = result.stdout + result.stderr

            if has_error(output):
                print("❌ ERROR")
            else:
                print("✅ OK")
