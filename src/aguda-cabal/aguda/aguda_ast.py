

class Program:
    def __init__(self, declarations):
        self.declarations = declarations

class VarDecl:
    def __init__(self, name, type, expr, lineno=None, col=None):
        self.name = name
        self.type = type
        self.expr = expr
        self.lineno = lineno
        self.col = col

class FunDecl:
    def __init__(self, name, params, param_types, return_type, expr, lineno=None, col=None):
        self.name = name
        self.params = params
        self.param_types = param_types
        self.return_type = return_type
        self.expr = expr
        self.lineno = lineno
        self.col = col

class IntLiteral:
    def __init__(self, value, lineno=None, col=None):
        self.value = value
        self.lineno = lineno
        self.col = col

class BoolLiteral:
    def __init__(self, value, lineno=None, col=None):
        self.value = value
        self.lineno = lineno
        self.col = col

class StringLiteral:
    def __init__(self, value, lineno=None, col=None):
        self.value = value
        self.lineno = lineno
        self.col = col

class UnitLiteral:
    def __init__(self, lineno=None, col=None):
        self.lineno = lineno
        self.col = col

class NullLiteral:
    def __init__(self, lineno=None, col=None):
        self.lineno = lineno
        self.col = col

class Var:
    def __init__(self, name, lineno=None, col=None):
        self.name = name
        self.lineno = lineno
        self.col = col

class BinOp:
    def __init__(self, op, left, right, lineno=None, col=None):
        self.op = op
        self.left = left
        self.right = right
        self.lineno = lineno
        self.col = col

class UnaryOp:
    def __init__(self, op, expr, lineno=None, col=None):
        self.op = op
        self.expr = expr
        self.lineno = lineno
        self.col = col

class IfExpr:
    def __init__(self, cond, then_expr, else_expr, lineno=None, col=None):
        self.cond = cond
        self.then_expr = then_expr
        self.else_expr = else_expr
        self.lineno = lineno
        self.col = col

class WhileExpr:
    def __init__(self, cond, body, lineno=None, col=None):
        self.cond = cond
        self.body = body
        self.lineno = lineno
        self.col = col

class Seq:
    def __init__(self, first, second, lineno=None, col=None):
        self.first = first
        self.second = second
        self.lineno = lineno
        self.col = col

class Assign:
    def __init__(self, target, expr, lineno=None, col=None):
        self.target = target
        self.expr = expr
        self.lineno = lineno
        self.col = col

class FuncCall:
    def __init__(self, func_name, args, lineno=None, col=None):
        self.func_name = func_name
        self.args = args
        self.lineno = lineno
        self.col = col

class NewArray:
    def __init__(self, type, size_expr, init_expr, lineno=None, col=None):
        self.type = type
        self.size_expr = size_expr
        self.init_expr = init_expr
        self.lineno = lineno
        self.col = col

class ArrayAccess:
    def __init__(self, array_expr, index_expr, lineno=None, col=None):
        self.array_expr = array_expr
        self.index_expr = index_expr
        self.lineno = lineno
        self.col = col

class Type:
    def __init__(self, name):
        self.name = name

class ArrayType:
    def __init__(self, base_type):
        self.base_type = base_type

class FuncType:
    def __init__(self, param_types, return_type):
        self.param_types = param_types
        self.return_type = return_type
