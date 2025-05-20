import os
import subprocess

# Diretório onde estão os testes validos
tests_dir = "test/valid"

# Caminho para o compilador
main_script = "src/aguda-cabal/aguda/main.py"

def extract_number(name):
    # Extrai número inicial da pasta (por exemplo "54394_qualquercoisa" -> 54394)
    for c in name:
        if not c.isdigit():
            break
    num_part = ""
    for c in name:
        if c.isdigit():
            num_part += c
        else:
            break
    return int(num_part) if num_part else float('inf')  # Para pastas tipo "tcomp000", põe no fim

# Apanha todas as pastas
folders = [f for f in os.listdir(tests_dir) if os.path.isdir(os.path.join(tests_dir, f))]

#folders.sort(key=extract_number) #para correr estes do menor numero de aluno para o maior

# Ordena pelo número extraído
folders.sort(key=extract_number,reverse=True) #reserve=true para ver os testes restantes no terminal...

# Agora percorre em ordem
for folder in folders:
    folder_path = os.path.join(tests_dir, folder)
    for file in os.listdir(folder_path):
        if file.endswith(".agu"):
            agu_file = os.path.join(folder_path, file)
            print(f"\n=== Running {agu_file} ===")
            subprocess.run(["python3", main_script, agu_file])
