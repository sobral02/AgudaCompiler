import ply.lex as lex
from errors import LexicalError

paren_level = 0

tokens = [
    'ID', 'INT_LITERAL', 'STRING_LITERAL',
    'PLUS', 'MINUS', 'TIMES', 'DIVIDE', 'MOD', 'POW',
    'EQ', 'NEQ', 'LT', 'LE', 'GT', 'GE',
    'ASSIGN', 'SEMICOLON', 'COLON', 'COMMA',
    'LPAREN', 'RPAREN', 'LBRACK', 'RBRACK',
    'OR', 'AND', 'NOT', 'PIPE', 'ARROW',
    'NULL'
]

reserved = {
    'let': 'LET',
    'set': 'SET',
    'if': 'IF',
    'then': 'THEN',
    'else': 'ELSE',
    'while': 'WHILE',
    'do': 'DO',
    'true': 'TRUE',
    'false': 'FALSE',
    'unit': 'UNIT',
    'new': 'NEW',
}

tokens += list(reserved.values())

t_PLUS      = r'\+'
t_MINUS     = r'-'
t_TIMES     = r'\*'
t_DIVIDE    = r'/'
t_MOD       = r'%'
t_POW       = r'\^'
t_EQ        = r'=='
t_NEQ       = r'!='
t_LT        = r'<'
t_LE        = r'<='
t_GT        = r'>'
t_GE        = r'>='
t_ASSIGN    = r'='
t_SEMICOLON = r';'
t_COLON     = r':'
t_COMMA     = r','
t_LBRACK    = r'\['
t_RBRACK    = r'\]'
t_OR        = r'\|\|'
t_AND       = r'&&'
t_NOT       = r'!'
t_PIPE      = r'\|'
t_ARROW     = r'->'

t_ignore = ' \t\r'

def find_column(input, token):
    line_start = input.rfind('\n', 0, token.lexpos) + 1
    return (token.lexpos - line_start) + 1

def t_INT_LITERAL(t):
    r'[0-9]+'
    t.value = int(t.value)
    t.column = find_column(t.lexer.lexdata, t)
    return t

def t_UNCLOSED_STRING(t):
    r'"([^"\n]*)\n'
    column = find_column(t.lexer.lexdata, t)
    raise LexicalError(f"Lexical error at line {t.lineno}, column {column}: unclosed string literal")

def t_STRING_LITERAL(t):
    r'"([^"\n"]*)"'
    t.value = t.value[1:-1]
    t.column = find_column(t.lexer.lexdata, t)
    return t

def t_NULL(t):
    r'null'
    t.value = 'null'
    t.column = find_column(t.lexer.lexdata, t)
    return t

def t_ID(t):
    r'(_|[a-zA-Z][a-zA-Z0-9_\']*)'
    t.type = reserved.get(t.value, 'ID')
    t.column = find_column(t.lexer.lexdata, t)
    return t

def t_COMMENT(t):
    r'\-\-.*'
    pass

def t_LPAREN(t):
    r'\('
    global paren_level
    paren_level += 1
    t.column = find_column(t.lexer.lexdata, t)
    return t

def t_RPAREN(t):
    r'\)'
    global paren_level
    paren_level -= 1
    t.column = find_column(t.lexer.lexdata, t)
    return t

def t_NEWLINE(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")
    pass

def t_error(t):
    column = find_column(t.lexer.lexdata, t)
    raise LexicalError(f"Lexical error at line {t.lineno}, column {column}: illegal character '{t.value[0]}'")

lexer = lex.lex()
