import sys
import os

from lexer import lexer
from parser import parser
from errors import LexicalError, SemanticError, SyntaxError, CodeGenNotImplementedError
from validator import Validator
import pretty_printer  # (opcional)
from codegen import generate_llvm_code  # Importar a função de geração de código LLVM

def read_file(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        return f.read()

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 main.py <source_file.agu>")
        sys.exit(1)

    filename = sys.argv[1]
    base_filename, _ = os.path.splitext(filename)
    llvm_output_filename = base_filename + ".ll"  # Nome do ficheiro de saída LLVM

    try:
        source_code = read_file(filename)

        # Reset de novo o input para que o parser possa usá-lo
        lexer.input(source_code)

        # Parse e construção da AST
        ast_root = parser.parse(source_code, lexer=lexer)

        # Validação semântica
        validator = Validator(max_errors=5)
        validator.source_lines = source_code.splitlines()
        validator.validate(ast_root)

        print("\nValidation successful!")
        #pretty_printer.print_ast(ast_root)
        print("\n")

        # Geração de código LLVM
        print(f"Generating LLVM code to: {llvm_output_filename}")
        generate_llvm_code(ast_root, validator, llvm_output_filename)
        print("DEBUG: generate_llvm_code retornou")

    except LexicalError as e:
        print(f"Lexical Error: {e}")
        sys.exit(1)

    except SyntaxError as e:
        print(f"Syntax Error: {e}")
        sys.exit(1)

    except SemanticError as e:
        print(f"Semantic Error: {e}")
        sys.exit(1)

    except CodeGenNotImplementedError as e:
        print(str(e))  # Mensagem já formatada corretamente
        sys.exit(1)

    except FileNotFoundError:
        print(f"File not found: {filename}")
        sys.exit(1)

    except Exception as e:
        print(f"An unexpected error occurred:\n {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()
