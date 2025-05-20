from errors import SemanticError
import aguda_ast as ast

# === Tipos de dados (robustos) ===

class Type: 
    def __str__(self): return "<type>"
    
class ErrorType(Type):
    def __str__(self): return "<error>"
    def __eq__(self, other): return isinstance(other, ErrorType)


class IntType(Type):
    def __str__(self): return "Int"
    def __eq__(self, other): return isinstance(other, IntType)

class BoolType(Type):
    def __str__(self): return "Bool"
    def __eq__(self, other): return isinstance(other, BoolType)

class StringType(Type):
    def __str__(self): return "String"
    def __eq__(self, other): return isinstance(other, StringType)

class UnitType(Type):
    def __str__(self): return "Unit"
    def __eq__(self, other): return isinstance(other, UnitType)

class NullType(Type):
    def __str__(self): return "Null"
    def __eq__(self, other): return isinstance(other, NullType)

class ArrayType(Type):
    def __init__(self, base_type, size=None):
        self.base_type = base_type
        self.size = size  # <-- adicionado!
        
    def __str__(self):
        if self.size is not None:
            return f"{self.base_type}[{self.size}]"
        return f"{self.base_type}[]"

    def __eq__(self, other):
        return (isinstance(other, ArrayType)
                and self.base_type == other.base_type
                and (self.size == other.size or self.size is None or other.size is None))


class FuncType(Type):
    def __init__(self, param_types, return_type):
        self.param_types = param_types
        self.return_type = return_type
    def __str__(self):
        params = ','.join(str(t) for t in self.param_types)
        return f"({params})->{self.return_type}"
    def __eq__(self, other):
        return (isinstance(other, FuncType) and
                self.param_types == other.param_types and
                self.return_type == other.return_type)


class Validator:
    def __init__(self, max_errors=5):
        self.max_errors = max_errors
        self.errors = []
        self.ctx = [{}]  # Lista de escopos (pilha)
        self.functions = {}  # Tabela global de funções

    def error(self, node, msg):
        lineno = getattr(node, 'lineno', 1)
        col = getattr(node, 'col', 1)

        if len(self.errors) < self.max_errors:
            expr_text = self.expr_to_str(node) if hasattr(self, "expr_to_str") else "<unknown expr>"

            if expr_text == "<unknown expr>":
                # Se não consegues imprimir a expressão, imprime a linha toda
                if hasattr(self, 'source_lines') and 1 <= lineno <= len(self.source_lines):
                    expr_text = self.source_lines[lineno-1].strip()
                else:
                    expr_text = "<source line unavailable>"

            self.errors.append(f"Error: ({lineno},{col}) {msg}\n{expr_text}")




            
    def expr_to_str(self, node):
        if isinstance(node, ast.Var):
            return node.name
        if isinstance(node, ast.IntLiteral):
            return str(node.value)
        if isinstance(node, ast.StringLiteral):
            return f'"{node.value}"'
        if isinstance(node, ast.BoolLiteral):
            return "true" if node.value else "false"
        if isinstance(node, ast.UnitLiteral):
            return "unit"
        if isinstance(node, ast.NullLiteral):
            return "null"
        if isinstance(node, ast.BinOp):
            return f"({self.expr_to_str(node.left)} {node.op} {self.expr_to_str(node.right)})"
        if isinstance(node, ast.UnaryOp):
            return f"({node.op}{self.expr_to_str(node.expr)})"
        if isinstance(node, ast.FuncCall):
            args = ', '.join(self.expr_to_str(arg) for arg in node.args)
            return f"{node.func_name}({args})"
        if isinstance(node, ast.ArrayAccess):
            return f"{self.expr_to_str(node.array_expr)}[{self.expr_to_str(node.index_expr)}]"
        if isinstance(node, ast.IfExpr):
            return f"(if {self.expr_to_str(node.cond)} then {self.expr_to_str(node.then_expr)} else {self.expr_to_str(node.else_expr)})"
        if isinstance(node, ast.WhileExpr):
            return f"(while {self.expr_to_str(node.cond)} do {self.expr_to_str(node.body)})"
        if isinstance(node, ast.Seq):
            return f"({self.expr_to_str(node.first)}; {self.expr_to_str(node.second)})"
        if isinstance(node, ast.NewArray):
            return f"new {self.expr_to_str(node.type)}[{self.expr_to_str(node.size_expr)} | {self.expr_to_str(node.init_expr)}]"
        if isinstance(node, ast.Type):
            return node.name
        if isinstance(node, ast.ArrayType):
            return f"{self.expr_to_str(node.base_type)}[]"
        if isinstance(node, ast.FuncType):
            params = ', '.join(self.expr_to_str(p) for p in node.param_types)
            return f"({params}) -> {self.expr_to_str(node.return_type)}"
        return "<unknown expr>"



    def validate(self, program):
        # Primeiro registar todas as funções
        for decl in program.declarations:
            if isinstance(decl, ast.FunDecl):
                if decl.name in self.functions:
                    self.error(decl, f"Function '{decl.name}' already defined")
                    continue  # evitar sobreposição
                if isinstance(decl.param_types, list):
                    param_types = [self._type_from_ast(t) for t in decl.param_types]
                else:
                    param_types = [self._type_from_ast(decl.param_types)]
                ret_type = self._type_from_ast(decl.return_type)
                self.functions[decl.name] = (param_types, ret_type)

        # Agora validar todas as declarações
        for decl in program.declarations:
            if isinstance(decl, ast.VarDecl):
                self.validate_var_decl(decl)
            elif isinstance(decl, ast.FunDecl):
                self.validate_fun_decl(decl)

        if self.errors:
            raise SemanticError('\n'.join(self.errors))



    def validate_var_decl(self, decl):
        expected_type = self._type_from_ast(decl.type)
        actual_type = self.typeof(decl.expr)
        
       
        
        if expected_type != actual_type:
            self.error(decl, f"Expected type {expected_type}, got {actual_type}")
        self.ctx[-1][decl.name] = actual_type

        
    

    def validate_fun_decl(self, decl):
        if isinstance(decl.param_types, list):
            param_types = [self._type_from_ast(t) for t in decl.param_types]
        else:
            param_types = [self._type_from_ast(decl.param_types)]

        ret_type = self._type_from_ast(decl.return_type)
        self.functions[decl.name] = (param_types, ret_type)

        self.ctx.append({name: typ for name, typ in zip(decl.params, param_types)})

        actual_type = self.typeof(decl.expr)

        if actual_type != ret_type:
            self.error(decl, f"Function body has type {actual_type}, expected {ret_type}")
            
        decl.expr.inferred_type = actual_type

        self.ctx.pop()

    def typeof(self, expr):
        
        
        if isinstance(expr, str):
            return StringType()

        
        if isinstance(expr, ast.IntLiteral): return IntType()
        if isinstance(expr, ast.BoolLiteral): return BoolType()
        if isinstance(expr, ast.StringLiteral): return StringType()
        if isinstance(expr, ast.UnitLiteral): return UnitType()
        if isinstance(expr, ast.NullLiteral): return NullType()

        if isinstance(expr, ast.Var):
            for scope in reversed(self.ctx):
                if expr.name in scope:
                    return scope[expr.name]
            if expr.name in self.functions:
                param_types, ret_type = self.functions[expr.name]
                return FuncType(param_types, ret_type)
            else:
                self.error(expr, f"Undefined variable '{expr.name}'")
            return ErrorType()  # erro silencioso com tipo genérico

        if isinstance(expr, ast.VarDecl):
            
            expected = self._type_from_ast(expr.type)
            actual = self.typeof(expr.expr)

            # --- ALTERAÇÃO AQUI ---
            if not isinstance(actual, ErrorType):
                if not isinstance(expected, UnitType):
                    if expected != actual:
                        self.error(expr, f"Type mismatch in declaration: expected {expected}, got {actual}")
            # --- FIM ALTERAÇÃO ---

            self.ctx[-1][expr.name] = expected
            return UnitType()

        if isinstance(expr, ast.BinOp):
             # Verificação especial: não permitir usar o wildcard '_'
            if (isinstance(expr.left, ast.Var) and expr.left.name == "_") or \
            (isinstance(expr.right, ast.Var) and expr.right.name == "_"):
                self.error(expr, "Wildcard '_' cannot be used in expressions")
                return ErrorType()
            
            left = self.typeof(expr.left)
            right = self.typeof(expr.right)
    
            op = expr.op

            if isinstance(left, Type) and isinstance(right, Type):  # apenas se não for erro
                if op in ['+', '-', '*', '/', '%', '^']:
                    if isinstance(left, IntType) and isinstance(right, IntType):
                        return IntType()
                    self.error(expr, f"Operator '{op}' needs Int operands")
                    return ErrorType()
                
                if op in ['==', '!=', '<', '<=', '>', '>=']:
                    if type(left) == type(right):
                        return BoolType()
                    self.error(expr, f"Cannot compare {left} with {right}")
                    return ErrorType()
                
                if op in ['&&', '||']:
                    if isinstance(left, BoolType) and isinstance(right, BoolType):
                        return BoolType()
                    self.error(expr, f"Logical operator '{op}' needs Bool operands")
                    return ErrorType()
            return ErrorType()

        if isinstance(expr, ast.UnaryOp):
            t = self.typeof(expr.expr)
            if expr.op == '-' and isinstance(t, IntType): return IntType()
            if expr.op == '!' and isinstance(t, BoolType): return BoolType()
            self.error(expr, f"Unary '{expr.op}' expects proper operand type")
            return ErrorType()

        if isinstance(expr, ast.FuncCall):
            # Primeiro, procurar se func_name é uma variável no contexto (ctx)
            for scope in reversed(self.ctx):
                if expr.func_name in scope:
                    func_type = scope[expr.func_name]
                    if not isinstance(func_type, FuncType):
                        self.error(expr, f"Variable '{expr.func_name}' is not a function")
                        return ErrorType()
                    if len(func_type.param_types) != len(expr.args):
                        self.error(expr, f"Function '{expr.func_name}' expects {len(func_type.param_types)} arguments")
                        return ErrorType()
                    for arg, expected in zip(expr.args, func_type.param_types):
                        self.checkAgainst(arg, expected)
                    return func_type.return_type

            # Depois, procurar nas funções globais (self.functions)
            if expr.func_name in self.functions:
                param_types, ret_type = self.functions[expr.func_name]
                if len(param_types) != len(expr.args):
                    self.error(expr, f"Function '{expr.func_name}' expects {len(param_types)} arguments")
                else:
                    for arg, expected in zip(expr.args, param_types):
                        self.checkAgainst(arg, expected)
                return ret_type

            # Casos especiais como "print" e "length"
            elif expr.func_name == "print":
                self.typeof(expr.args[0])
                return UnitType()

            elif expr.func_name == "length":
                t = self.typeof(expr.args[0])
                if not isinstance(t, ArrayType):
                    self.error(expr, f"length expects array, got {t}")
                    return ErrorType()
                return IntType()

            # Se não encontrar em lado nenhum, erro
            else:
                self.error(expr, f"Function '{expr.func_name}' not defined")
                return ErrorType()


        
        if isinstance(expr, ast.Seq):
            first_type = None

            if isinstance(expr.first, ast.VarDecl):
                self.validate_var_decl(expr.first)
                first_type = UnitType()
            else:
                first_type = self.typeof(expr.first)

            if isinstance(expr.second, ast.VarDecl):
                self.validate_var_decl(expr.second)
                return UnitType()  # <- sequência termina em VarDecl => tipo Unit
            else:
                return self.typeof(expr.second)



        if isinstance(expr, ast.IfExpr):
            cond = self.typeof(expr.cond)
            if not isinstance(cond, BoolType):
                self.error(expr.cond, f"If condition must be Bool")

            self.ctx.append({})
            t1 = self.typeof(expr.then_expr)
            self.ctx.pop()

            self.ctx.append({})
            t2 = self.typeof(expr.else_expr)
            self.ctx.pop()
            
            print(f"DEBUG VALIDATOR: IfExpr => then: {t1}, else: {t2}, cond: {cond}")


            if isinstance(t1, ErrorType) or isinstance(t2, ErrorType):
                expr.inferred_type = ErrorType()
                return ErrorType()

            if t1 != t2:
                self.error(expr, f"Branches must have same type, got {t1} and {t2}")
                expr.inferred_type = ErrorType()
                return ErrorType()
            
            expr.inferred_type = t1
            return t1


        if isinstance(expr, ast.WhileExpr):
            cond = self.typeof(expr.cond)
            if not isinstance(cond, BoolType):
                self.error(expr, f"While condition must be Bool")
            self.typeof(expr.body)
            return UnitType()
        

        if isinstance(expr, ast.Assign):
            lhs = self.typeof(expr.target)
            rhs = self.typeof(expr.expr)
            if lhs != rhs:
                self.error(expr, f"Type mismatch in assignment: {lhs} vs {rhs}")
            return UnitType()

        

        if isinstance(expr, ast.NewArray):
            if isinstance(expr.size_expr, ast.IntLiteral):
                array_size = expr.size_expr.value
            else:
                array_size = None

            size_t = self.typeof(expr.size_expr)
            if not isinstance(size_t, IntType):
                self.error(expr, f"Array size must be Int")

            init_t = self.typeof(expr.init_expr)
            base_t = self._type_from_ast(expr.type)

            if init_t != base_t:
                self.error(expr, f"Init type {init_t} doesn't match base type {base_t}")

            return ArrayType(base_t, array_size)



        if isinstance(expr, ast.ArrayAccess):
            arr_t = self.typeof(expr.array_expr)
            idx_t = self.typeof(expr.index_expr)
            
            if isinstance(arr_t, ArrayType) and arr_t.size is not None:
                if isinstance(expr.index_expr, ast.IntLiteral):
                    if expr.index_expr.value >= arr_t.size:
                        self.error(expr, f"Index {expr.index_expr.value} out of bounds for array of size {arr_t.size}")

                    
            
            
            if not isinstance(arr_t, ArrayType):
                self.error(expr, f"Tried to index non-array type {arr_t}")
                return ErrorType()
            if not isinstance(idx_t, IntType):
                self.error(expr, f"Array index must be Int")
                return ErrorType()
            return arr_t.base_type

        self.error(expr, f"Unknown expression {type(expr).__name__}")
        return ErrorType()
    
    def checkAgainst(self, expr, expected_type):
        actual_type = self.typeof(expr)
        if actual_type != expected_type:
            self.error(expr, f"Expected type {expected_type}, found type {actual_type}")


    def _type_from_ast(self, typ):
        if isinstance(typ, ast.Type):
            if typ.name == "Int":
                return IntType()
            elif typ.name == "Bool":
                return BoolType()
            elif typ.name == "String":
                return StringType()
            elif typ.name == "Unit":
                return UnitType()
            elif typ.name == "Null":
                return NullType()
            else:
                return ErrorType()  # tipo desconhecido genérico
        elif isinstance(typ, ast.ArrayType):
            return ArrayType(self._type_from_ast(typ.base_type))
        elif isinstance(typ, ast.FuncType):
            param_types = [self._type_from_ast(t) for t in typ.param_types]
            return_type = self._type_from_ast(typ.return_type)
            return FuncType(param_types, return_type)
        else:
            return ErrorType()  # fallback genérico
