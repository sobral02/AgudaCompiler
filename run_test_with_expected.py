import subprocess
from pathlib import Path
import contextlib
import io

def run_test(agu_path):
    agu_path = Path(agu_path)
    ll_path = agu_path.with_suffix(".ll")
    expect_path = agu_path.with_suffix(".expect")
    
    f = io.StringIO()
    with contextlib.redirect_stdout(f):
        subprocess.run(
            ["python3", "src/aguda-cabal/aguda/main.py", str(agu_path)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True
        )

    expected = expect_path.read_text().splitlines()[0].strip()
    result = subprocess.run(["lli", str(ll_path)], capture_output=True, text=True)
    output = result.stdout.strip()

    if output == expected:
        print(f"[PASS] {agu_path.name} -> {output}")
    else:
        print(f"[FAIL] {agu_path.name}")
        print(f"  Expected: {expected}")
        print(f"  Got     : {output}")


# testes passados com sucesso:
run_test("test/valid/56332_simple_sum/simple_sum.agu")
run_test("test/valid/56334_factorial/factorial.agu")
run_test("test/valid/56311_equals/equals_method.agu")
run_test("test/valid/56307_powerFunction/powerFunction.agu")
run_test("test/valid/56269_variables/variables.agu")
run_test("test/valid/56311_while_loop_with_mutations/while_loop_with_mutations.agu")
run_test("test/valid/54394_clamp/clamp.agu")
run_test("test/valid/58250_cube/58250_cube.agu")
run_test("test/valid/54394_semicolon_assignment/semicolon_assignment.agu")
run_test("test/valid/54394_string_printing/string_printing.agu")
run_test("test/valid/64854_printA/printA.agu")
run_test("test/valid/54394_identifier/identifier.agu")
run_test("test/valid/tcomp000_letOfLet/letOfLet.agu")
