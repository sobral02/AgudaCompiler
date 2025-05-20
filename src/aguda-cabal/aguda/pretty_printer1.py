import ast

INDENT_SIZE = 3

def print_ast(node, indent=0, in_block=False, is_last_in_block=False):
    space = ' ' * (indent * INDENT_SIZE)

    if isinstance(node, ast.Program):
        for i, decl in enumerate(node.declarations):
            print_ast(decl, indent)
            if i != len(node.declarations) - 1:
                print()

    elif isinstance(node, ast.VarDecl):
        print()
        print(f"{space}let {node.name} : {format_type(node.type)} =")
        print_ast(node.expr, indent + 1)
        print()

    elif isinstance(node, ast.Assign):
        print()
        print(f"{space}set {node.target.name} = ", end='')
        print_ast_inline(node.expr)
        if is_last_in_block:
            print(";")  # Ponto e vírgula apenas na última instrução do bloco
        else:
            print()

    elif isinstance(node, ast.FunDecl):
        print()
        params = ', '.join(node.params)
        print(f"{space}let {node.name} ({params}) : {format_type(node.type)} =")
        print_ast(node.expr, indent + 1)

    elif isinstance(node, ast.IntLiteral):
        print(f"{node.value}", end='')

    elif isinstance(node, ast.BoolLiteral):
        print(f"{str(node.value).lower()}", end='')

    elif isinstance(node, ast.StringLiteral):
        print(f'"{node.value}"', end='')

    elif isinstance(node, ast.UnitLiteral):
        print(f"unit", end='')

    elif isinstance(node, ast.NullLiteral):
        print(f"null", end='')

    elif isinstance(node, ast.Var):
        print(f"{node.name}", end='')

    elif isinstance(node, ast.BinOp):
        print("(", end='')
        print_ast_inline(node.left)
        print(f" {node.op} ", end='')
        print_ast_inline(node.right)
        print(")", end='')

    elif isinstance(node, ast.UnaryOp):
        print(f"{node.op}", end='')
        print_ast_inline(node.expr)

    elif isinstance(node, ast.IfExpr):
        print()
        print(f"{space}if")
        print_ast(node.cond, indent + 1)
        print(f"\n{space}then")
        print_ast(node.then_expr, indent + 1)
        if not isinstance(node.else_expr, ast.UnitLiteral):
            print(f"\n{space}else")
            print_ast(node.else_expr, indent + 1)

    elif isinstance(node, ast.WhileExpr):
        print()
        print(f"{space}while ", end='')
        print_ast_inline(node.cond)
        print(f" do")
        print_ast_block(node.body, indent + 1)

    elif isinstance(node, ast.FuncCall):
        print(f"{node.func_name}(", end='')
        print(', '.join(flatten_expression(arg) for arg in node.args), end='')
        print(f")", end='')

    elif isinstance(node, ast.Seq):
        seq = flatten_seq(node)
        for i, expr in enumerate(seq):
            is_last = (i == len(seq) - 1)
            print_ast(expr, indent, in_block=True, is_last_in_block=is_last)

    elif isinstance(node, ast.NewArray):
        print(f"new {format_type(node.type)}[", end='')
        print_ast_inline(node.size_expr)
        print("|", end='')
        print_ast_inline(node.init_expr)
        print("]", end='')

    elif isinstance(node, ast.ArrayAccess):
        print_ast_inline(node.array_expr)
        print(f"[", end='')
        print_ast_inline(node.index_expr)
        print(f"]", end='')

    else:
        print(f"<Unknown Node {type(node).__name__}>", end='')


def print_ast_block(node, indent):
    """Imprime bloco de código (tipo corpo do while)."""
    print_ast(node, indent, in_block=True)


def flatten_seq(node):
    """Desfaz sequência de Seq nodes numa lista."""
    if isinstance(node, ast.Seq):
        return flatten_seq(node.first) + flatten_seq(node.second)
    else:
        return [node]


def format_type(t):
    if isinstance(t, ast.Type):
        return t.name
    elif isinstance(t, ast.ArrayType):
        return format_type(t.base_type) + "[]"
    elif isinstance(t, ast.FuncType):
        params = ', '.join(format_type(param) for param in t.param_types)
        return f"({params}) -> {format_type(t.return_type)}"
    else:
        return "<unknown type>"


def flatten_expression(expr):
    if isinstance(expr, ast.Var):
        return expr.name
    elif isinstance(expr, ast.IntLiteral):
        return str(expr.value)
    elif isinstance(expr, ast.BoolLiteral):
        return str(expr.value).lower()
    elif isinstance(expr, ast.StringLiteral):
        return f'"{expr.value}"'
    elif isinstance(expr, ast.FuncCall):
        args = ', '.join(flatten_expression(arg) for arg in expr.args)
        return f"{expr.func_name}({args})"
    elif isinstance(expr, ast.ArrayAccess):
        return f"{flatten_expression(expr.array_expr)}[{flatten_expression(expr.index_expr)}]"
    elif isinstance(expr, ast.BinOp):
        return f"({flatten_expression(expr.left)} {expr.op} {flatten_expression(expr.right)})"
    else:
        return "<expr>"


def print_ast_inline(node):
    if isinstance(node, (ast.Var, ast.IntLiteral, ast.BoolLiteral, ast.StringLiteral)):
        print(flatten_expression(node), end='')
    elif isinstance(node, ast.BinOp):
        print("(", end='')
        print_ast_inline(node.left)
        print(f" {node.op} ", end='')
        print_ast_inline(node.right)
        print(")", end='')
    elif isinstance(node, ast.UnaryOp):
        print(f"{node.op}", end='')
        print_ast_inline(node.expr)
    elif isinstance(node, ast.FuncCall):
        print(flatten_expression(node), end='')
    elif isinstance(node, ast.ArrayAccess):
        print(flatten_expression(node), end='')
    elif isinstance(node, ast.NewArray):
        print(f"new {format_type(node.type)}[", end='')
        print_ast_inline(node.size_expr)
        print("|", end='')
        print_ast_inline(node.init_expr)
        print("]", end='')
    else:
        print_ast(node, indent=0)


