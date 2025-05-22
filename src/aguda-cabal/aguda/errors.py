

class LexicalError(Exception):
    pass

class SyntaxError(Exception):
    pass

class SemanticError(Exception): 
    pass

class CodeGenNotImplementedError(Exception):
    def __init__(self, node, kind, validator=None):
        lineno = getattr(node, 'lineno', 0)
        col = getattr(node, 'col', 0)
        
        if validator:
            try:
                expr_text = validator.expr_to_str(node)
            except Exception:
                expr_text = "<unknown expr>"
        else:
            expr_text = "<unknown expr>"

        msg = f"Not implemented: Generating code for ({lineno},{col}) {kind} '{expr_text}'"
        super().__init__(msg)

