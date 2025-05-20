import os
import subprocess

# Diretórios dos testes inválidos
invalid_dirs = ["test/invalid-syntax", "test/invalid-semantic"]

# Caminho para o teu compilador
main_script = "src/aguda-cabal/aguda/main.py"

for tests_dir in invalid_dirs:
    print(f"\n=== Running tests in {tests_dir} ===")
    
    for folder in sorted(os.listdir(tests_dir)):
        folder_path = os.path.join(tests_dir, folder)
        
        if os.path.isdir(folder_path):
            for file in os.listdir(folder_path):
                if file.endswith(".agu"):
                    agu_file = os.path.join(folder_path, file)
                    print(f"\n=== Running {agu_file} ===")
                    subprocess.run(["python3", main_script, agu_file])
