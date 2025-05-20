import ply.yacc as yacc
from lexer import tokens
import aguda_ast as ast
from errors import SyntaxError

# --- Precedência dos operadores ---
precedence = (
    ('right', 'SEMICOLON'),
    ('left', 'OR'),
    ('left', 'AND'),
    ('nonassoc', 'EQ', 'NEQ'),
    ('nonassoc', 'LT', 'LE', 'GT', 'GE'),
    ('left', 'PLUS', 'MINUS'),
    ('left', 'TIMES', 'DIVIDE', 'MOD'),
    ('right', 'POW'),
    ('right', 'NOT', 'UMINUS'),
    ('left', 'LBRACK'),
)

# --- Funções auxiliares ---
def find_column(input, token):
    line_start = input.rfind('\n', 0, token.lexpos) + 1
    return (token.lexpos - line_start) + 1

# --- Programa principal ---
def p_program(p):
    'program : declarations'
    p[0] = ast.Program(p[1])

# --- Declarations ---
def p_declarations(p):
    '''declarations : declaration declarations
                    | declaration'''
    if len(p) == 3:
        p[0] = [p[1]] + p[2]
    else:
        p[0] = [p[1]]

def p_declaration_fun(p):
    'declaration : LET ID LPAREN params RPAREN COLON type ASSIGN fun_body'
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    param_types = p[7].param_types if isinstance(p[7], ast.FuncType) else [p[7]]
    return_type = p[7].return_type if isinstance(p[7], ast.FuncType) else p[7]
    p[0] = ast.FunDecl(p[2], p[4], param_types, return_type, p[9], lineno, col)

def p_declaration_var(p):
    'declaration : LET ID COLON type ASSIGN var_body'
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    p[0] = ast.VarDecl(p[2], p[4], p[6], lineno, col)
    


def p_var_body_expr(p):
    'var_body : expression'
    p[0] = p[1]

def p_var_body_block(p):
    'var_body : block'
    p[0] = p[1]

def p_var_body_statements(p):
    'var_body : statement_list'
    p[0] = build_seq(p[1])


# --- Funções e Blocos ---
def p_fun_body(p):
    '''fun_body : statement_list
                | block'''
    if isinstance(p[1], list):
        p[0] = build_seq(p[1])
    else:
        p[0] = p[1]



def p_block(p):
    'block : LPAREN statement_list RPAREN'
    p[0] = build_seq(p[2])

def build_seq(stmts):
    if not stmts:
        return ast.UnitLiteral(0, 0)
    result = stmts[0]
    for stmt in stmts[1:]:
        result = ast.Seq(result, stmt)
    return result

# --- Statement lists ---
def p_statement_list(p):
    '''statement_list : statement SEMICOLON statement_list
                      | statement_no_semicolon'''
    if len(p) == 4:
        p[0] = [p[1]] + p[3]
    else:
        p[0] = [p[1]]

# --- Statements ---
def p_statement(p):
    '''statement : declaration
                 | command
                 | expression'''
    p[0] = p[1]

def p_statement_no_semicolon(p):
    '''statement_no_semicolon : declaration
                               | command
                               | expression'''
    p[0] = p[1]


# --- Params ---
def p_params(p):
    '''params : param_list
              | empty'''
    p[0] = p[1]

def p_param_list(p):
    '''param_list : ID COMMA param_list
                  | ID'''
    if len(p) == 4:
        p[0] = [p[1]] + p[3]
    else:
        p[0] = [p[1]]

# --- Tipos ---
def p_type(p):
    'type : ID'
    valid = ['Int', 'Bool', 'String', 'Unit']
    if p[1] not in valid:
        column = find_column(p.lexer.lexdata, p.slice[1])
        raise SyntaxError(f"Unknown type '{p[1]}' at line {p.lineno(1)}, column {column}")
    p[0] = ast.Type(p[1])

def p_type_array(p):
    'type : type LBRACK RBRACK'
    p[0] = ast.ArrayType(p[1])

def p_type_func(p):
    'type : type ARROW type'
    param_types = p[1] if isinstance(p[1], list) else [p[1]]
    p[0] = ast.FuncType(param_types, p[3])

def p_type_paren_list(p):
    'type : LPAREN type_list RPAREN'
    p[0] = p[2]

def p_type_list(p):
    '''type_list : type COMMA type_list
                 | type'''
    if len(p) == 4:
        p[0] = [p[1]] + p[3]
    else:
        p[0] = [p[1]]

# --- Commands ---
def p_command(p):
    '''command : WHILE expression DO simple_expr
               | WHILE expression DO block
               | SET lvalue ASSIGN expression'''
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    if p[1] == 'while':
        p[0] = ast.WhileExpr(p[2], p[4], lineno, col)
    else:
        p[0] = ast.Assign(p[2], p[4], lineno, col)
        
def p_simple_expr_command(p):
    'simple_expr : command'
    p[0] = p[1]

def p_simple_expr_expression(p):
    'simple_expr : expression'
    p[0] = p[1]


# --- Expressões ---
def p_expression_if(p):
    '''expression : IF expression THEN simple_expr
                  | IF expression THEN block
                  | IF expression THEN LPAREN statement_list RPAREN
                  | IF expression THEN simple_expr ELSE simple_expr
                  | IF expression THEN simple_expr ELSE block
                  | IF expression THEN simple_expr ELSE LPAREN statement_list RPAREN
                  | IF expression THEN block ELSE simple_expr
                  | IF expression THEN block ELSE block
                  | IF expression THEN block ELSE LPAREN statement_list RPAREN
                  | IF expression THEN LPAREN statement_list RPAREN ELSE simple_expr
                  | IF expression THEN LPAREN statement_list RPAREN ELSE block
                  | IF expression THEN LPAREN statement_list RPAREN ELSE LPAREN statement_list RPAREN'''
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    p[0] = ast.IfExpr(p[2], p[4], p[6] if len(p) == 7 else ast.UnitLiteral(lineno, col), lineno, col)


def p_expression_binop(p):
    '''expression : expression PLUS expression
                  | expression MINUS expression
                  | expression TIMES expression
                  | expression DIVIDE expression
                  | expression MOD expression
                  | expression POW expression
                  | expression EQ expression
                  | expression NEQ expression
                  | expression LT expression
                  | expression LE expression
                  | expression GT expression
                  | expression GE expression
                  | expression AND expression
                  | expression OR expression'''
    lineno = p.lineno(2)
    col = find_column(p.lexer.lexdata, p.slice[2])
    p[0] = ast.BinOp(p[2], p[1], p[3], lineno, col)

def p_expression_unary(p):
    '''expression : MINUS expression %prec UMINUS
                  | NOT expression'''
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    p[0] = ast.UnaryOp(p[1], p[2], lineno, col)
    
#resolve o teste do stor while + 5    
def p_expression_command_paren(p):
    'expression : LPAREN command RPAREN'
    p[0] = p[2]


def p_expression_literals(p):
    '''expression : INT_LITERAL
                  | STRING_LITERAL
                  | TRUE
                  | FALSE
                  | UNIT
                  | NULL'''
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    value = p[1]
    if isinstance(value, int):
        p[0] = ast.IntLiteral(value, lineno, col)
    elif value == 'true':
        p[0] = ast.BoolLiteral(True, lineno, col)
    elif value == 'false':
        p[0] = ast.BoolLiteral(False, lineno, col)
    elif value == 'unit':
        p[0] = ast.UnitLiteral(lineno, col)
    elif value == 'null':
        p[0] = ast.NullLiteral(lineno, col)
    else:
        p[0] = ast.StringLiteral(value, lineno, col)

def p_expression_paren(p):
    'expression : LPAREN expression RPAREN'
    p[0] = p[2]

def p_expression_call(p):
    'expression : ID LPAREN args RPAREN'
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    p[0] = ast.FuncCall(p[1], p[3], lineno, col)

def p_args(p):
    '''args : expression COMMA args
            | expression'''
    if len(p) == 4:
        p[0] = [p[1]] + p[3]
    else:
        p[0] = [p[1]]

def p_expression_new_array_expr(p):
    'expression : NEW type LBRACK expression PIPE expression RBRACK'
    p[0] = ast.NewArray(p[2], p[4], p[6])

def p_expression_new_array_block(p):
    'expression : NEW type LBRACK expression PIPE command RBRACK'
    p[0] = ast.NewArray(p[2], p[4], p[6])


def p_expression_array_access(p):
    'expression : expression LBRACK expression RBRACK'
    lineno = p.lineno(2)
    col = find_column(p.lexer.lexdata, p.slice[2])
    p[0] = ast.ArrayAccess(p[1], p[3], lineno, col)

def p_expression_var(p):
    'expression : ID'
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    p[0] = ast.Var(p[1], lineno, col)

# --- Lvalues ---
def p_lvalue_var(p):
    'lvalue : ID'
    lineno = p.lineno(1)
    col = find_column(p.lexer.lexdata, p.slice[1])
    p[0] = ast.Var(p[1], lineno, col)

def p_lvalue_array_access(p):
    'lvalue : lvalue LBRACK expression RBRACK'
    p[0] = ast.ArrayAccess(p[1], p[3])

# --- Empty rule ---
def p_empty(p):
    'empty :'
    p[0] = []

# --- Erro ---
def p_error(p):
    if p:
        column = find_column(p.lexer.lexdata, p)
        expected = parser.symstack[-1].type if parser.symstack else "EOF"
        print(f"[DEBUG] Unexpected token: {p}")
        print(f"[DEBUG] Expected something like: {expected}")
        raise SyntaxError(f"Syntax error at line {p.lineno}, column {column} near '{p.value}'")
    else:
        raise SyntaxError("Syntax error at EOF")

# --- Construir parser ---
parser = yacc.yacc()
