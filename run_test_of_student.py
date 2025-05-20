#!/usr/bin/env python3

import os
import sys
import subprocess

# Diretório onde estão os testes
TEST_DIR = 'test/valid'

def run_test(test_path):
    print(f"=== Running {test_path} ===")
    try:
        result = subprocess.run(
            ['python3', 'src/aguda-cabal/aguda/main.py', test_path],
            capture_output=True, text=True
        )
        print(result.stdout)
        if result.stderr:
            print(result.stderr)
    except Exception as e:
        print(f"Failed to run {test_path}: {e}")

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 run_tests_for_student.py <student_number>")
        sys.exit(1)

    student_number = sys.argv[1]

    # Procurar todas as pastas começando pelo número
    matches = []
    for folder in os.listdir(TEST_DIR):
        if folder.startswith(student_number):
            matches.append(os.path.join(TEST_DIR, folder))

    if not matches:
        print(f"No tests found for student {student_number}.")
        sys.exit(1)

    # Dentro de cada pasta encontrada, procurar ficheiros .agu
    for match in matches:
        for file in os.listdir(match):
            if file.endswith('.agu'):
                test_path = os.path.join(match, file)
                run_test(test_path)

if __name__ == "__main__":
    main()
