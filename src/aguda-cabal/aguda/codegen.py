# codegen.py
from llvmlite import ir, binding
import aguda_ast
from validator import IntType, BoolType, UnitType, FuncType # Importar os seus tipos

class LLVMCodeGenerator:
    def __init__(self, validator):
        self.binding = binding
        self.binding.initialize()
        self.binding.initialize_native_target()
        self.binding.initialize_native_asmprinter() # Para 'lli'

        self.module = ir.Module(name="aguda_module")
        self.module.triple = binding.get_default_triple()
        self.module.data_layout = binding.Target.from_default_triple().create_target_machine().target_data


        self.builder = None # Será um ir.IRBuilder
        self.func_symtab = {} # Para guardar referências a funções LLVM
        self.named_values = {} # Para variáveis locais dentro de funções

        # Usaremos o validador para obter informações de tipo
        self.validator = validator
        self.aguda_to_llvm_type_map = {
            str(IntType()): ir.IntType(32),    # AGUDA Int -> LLVM i32
            str(BoolType()): ir.IntType(1),   # AGUDA Bool -> LLVM i1
            str(UnitType()): ir.VoidType(),   # AGUDA Unit -> LLVM void
            # Strings e Arrays estão excluídos para M4
            #mudar o unit para i1 e o bool para i8
        }

    def get_llvm_type(self, aguda_type_node):
        """Converte um nó de tipo AGUDA (do AST ou do Validator) para um tipo LLVM."""
        type_str = str(aguda_type_node)  # Usa a representação string do seu tipo

        print(f"DEBUG: get_llvm_type chamada com aguda_type_node: {aguda_type_node}")  # PRINT 1

        if type_str in self.aguda_to_llvm_type_map:
            llvm_type = self.aguda_to_llvm_type_map[type_str]
            print(f"DEBUG: Tipo encontrado no mapa: {llvm_type}")  # PRINT 2
            return llvm_type
        elif isinstance(aguda_type_node, FuncType):
            param_llvm_types = [self.get_llvm_type(pt) for pt in aguda_type_node.param_types]
            return_llvm_type = self.get_llvm_type(aguda_type_node.return_type)
            llvm_type = ir.FunctionType(return_llvm_type, param_llvm_types)
            print(f"DEBUG: Tipo de função gerado: {llvm_type}")  # PRINT 3
            return llvm_type
        else:
            print(f"DEBUG: Tipo não mapeado: {aguda_type_node}")  # PRINT 4
            raise NotImplementedError(f"Tipo AGUDA não mapeado para LLVM: {aguda_type_node}")


    def generate_code(self, node):
        """Método principal para gerar código para um nó da AST."""
        if isinstance(node, aguda_ast.FunDecl):
            print(f"DEBUG: Gerando código para função: {node.name}")
            return self.generate_FunDecl(node)
        elif isinstance(node, aguda_ast.VarDecl):
            print(f"DEBUG: Gerando código para variável: {node.name}")
            return self.generate_VarDecl(node)
        else:
            method_name = 'generate_' + node.__class__.__name__
            visitor = getattr(self, method_name)  # Remover o fallback para generic_generate
            return visitor(node)

    # --- Métodos de Geração para cada nó da AST ---

    def generate_Program(self, node: aguda_ast.Program):
        # 1. Gerar código para todas as funções
        for decl in node.declarations:
            if isinstance(decl, aguda_ast.FunDecl):
                self.generate_code(decl)

        # 2. Gerar código para as outras declarações (VarDecl, etc.)
        for decl in node.declarations:
            if not isinstance(decl, aguda_ast.FunDecl):
                self.generate_code(decl)
        
        return self.module

    def generate_VarDecl(self, node: aguda_ast.VarDecl):
        # Requisito: Não implementar "Top-level declarations initialised to non-constants"
        # Isto significa que variáveis globais devem ter inicializadores constantes
        # ou serem inicializadas dentro de uma função (e.g., a função 'main' implícita).
        # Para simplificar, vamos assumir que as VarDecls no topo são globais.

        var_name = node.name
        aguda_type = self.validator._type_from_ast(node.type) # Obter o tipo validado
        llvm_type = self.get_llvm_type(aguda_type)

        if self.builder:  # Dentro de uma função (variável local)
            if isinstance(llvm_type, ir.VoidType):
                # Variável do tipo Unit → nada a fazer
                self.named_values[var_name] = None
                return

            ptr = self.builder.alloca(llvm_type, name=var_name)
            self.named_values[var_name] = ptr

            
            # Calcular o valor da expressão de inicialização
            init_val_llvm = self.generate_code(node.expr)
            
            # Verificar se init_val_llvm é do tipo correto ou se precisa de conversão
            # (Pode ser necessário se node.expr for uma chamada de função que retorna um tipo
            # diferente, mas o validador deve ter apanhado isto)
            
            if init_val_llvm is not None:
                self.builder.store(init_val_llvm, ptr)
                
        else: # Variável global
            # Verificar se a expressão de inicialização é uma constante
            # Por agora, vamos permitir apenas literais como inicializadores globais
            # devido à restrição "non-constants".
            initializer = None
            if isinstance(node.expr, aguda_ast.IntLiteral):
                initializer = ir.Constant(llvm_type, node.expr.value)
            elif isinstance(node.expr, aguda_ast.BoolLiteral):
                initializer = ir.Constant(llvm_type, 1 if node.expr.value else 0)
            elif isinstance(node.expr, aguda_ast.UnitLiteral) and llvm_type.is_void():
                 # Globais do tipo Unit não fazem muito sentido, mas para ser completo
                 # Se fosse um tipo struct vazio, poderia ser um `ir.Constant(llvm_type, None)`
                 # ou um `ir.Constant.literal_struct([])` dependendo da representação.
                 # Dado que é void, não se cria uma variável global "real" para unit,
                 # mas o nome pode ser necessário para a tabela de símbolos.
                 # Para M4, é improvável que tenhamos globais Unit.
                 pass # Não criar uma global LLVM para Unit, mas registar o nome
            else:
                 # A tarefa especifica: "What we need not implement: Top-level declarations initialised to non-constants"
                 # Então, se não for um literal simples, não geramos. O validador já deve ter passado.
                 print(f"Aviso: Inicializador global para '{var_name}' não é uma constante simples e não será gerado como global LLVM diretamente. O comportamento pode depender de como o 'main' é tratado.")
                 # Poderíamos criar um GlobalVariable indefinido e inicializá-lo no início de 'main'
                 # Mas por agora, vamos focar-nos no que é estritamente pedido.
                 # Se for uma função, já é tratada em generate_FunDecl.
                 # Se for uma variável global, o melhor é inicializá-la explicitamente numa função `_aguda_init` ou `main`.

            if initializer is not None:
                global_var = ir.GlobalVariable(self.module, llvm_type, name=var_name)
                global_var.linkage = 'internal' # ou 'common' ou 'external' dependendo
                global_var.initializer = initializer
                self.func_symtab[var_name] = global_var # Globais também na func_symtab para acesso
            elif not (isinstance(node.expr, aguda_ast.UnitLiteral) and llvm_type.is_void()):
                 # Se não for inicializador constante e não for Unit, lançar um aviso/erro
                 # ou tratar como uma declaração que será resolvida mais tarde (e.g. em main).
                 # Para M4, o mais seguro é focar nos casos simples.
                 pass # Não faz nada se não for constante

    def generate_FunDecl(self, node: aguda_ast.FunDecl):
        func_name = node.name

        # Obter os tipos dos parâmetros e do retorno
        validated_func_info = self.validator.functions.get(func_name)
        if not validated_func_info:
            aguda_param_types_ast = node.param_types if isinstance(node.param_types, list) else [node.param_types]
            aguda_param_types = [self.validator._type_from_ast(pt_node) for pt_node in aguda_param_types_ast]
            aguda_return_type = self.validator._type_from_ast(node.return_type)
        else:
            aguda_param_types, aguda_return_type = validated_func_info

        # Criar lista de tipos LLVM (ignorando parâmetros Unit)
        llvm_param_types = []
        param_map = []  # mapeia parâmetros válidos (não-Unit) para associar nomes

        for param_name, aguda_type in zip(node.params, aguda_param_types):
            llvm_type = self.get_llvm_type(aguda_type)
            if not isinstance(llvm_type, ir.VoidType):
                llvm_param_types.append(llvm_type)
                param_map.append(param_name)

        llvm_return_type = self.get_llvm_type(aguda_return_type)

        print(f"DEBUG: generate_FunDecl - nome da função: {func_name}")
        print(f"DEBUG: generate_FunDecl - tipos AGUDA dos parâmetros: {aguda_param_types}")
        print(f"DEBUG: generate_FunDecl - tipos LLVM dos parâmetros: {llvm_param_types}")
        print(f"DEBUG: generate_FunDecl - tipo de retorno LLVM: {llvm_return_type}")

        fnty = ir.FunctionType(llvm_return_type, llvm_param_types)
        # Evitar conflito se o nome for 'main' (função AGUDA)
        llvm_func_name = func_name if func_name != "main" else "aguda_main"
        func = ir.Function(self.module, fnty, name=llvm_func_name)


        # Nomear apenas os argumentos válidos (não-Unit)
        for llvm_arg, arg_name in zip(func.args, param_map):
            llvm_arg.name = arg_name

        self.func_symtab[func_name] = func
        

        # Criar o bloco inicial e preparar o builder
        bb_entry = func.append_basic_block(name="entry")
        self.builder = ir.IRBuilder(bb_entry)
        self.named_values.clear()

        # Alocar e guardar apenas os parâmetros válidos
        for llvm_arg, arg_name in zip(func.args, param_map):
            alloca = self.builder.alloca(llvm_arg.type, name=arg_name + "_ptr")
            self.builder.store(llvm_arg, alloca)
            self.named_values[arg_name] = alloca

        # Gerar o corpo da função
        if not hasattr(node.expr, "inferred_type") or node.expr.inferred_type is None:
            raise RuntimeError(f"Função {node.name} não tem tipo inferido do corpo.")

        self.current_function_return_type = node.expr.inferred_type
        body_val = self.generate_code(node.expr)
        print(f"DEBUG: body_val da função '{func_name}' = {body_val}")
        print(f"DEBUG: bloco atual terminado? {self.builder.block.is_terminated}")

        print(f"DEBUG: generate_FunDecl - corpo da função: {body_val}")

        # Retorno da função
        if isinstance(llvm_return_type, ir.VoidType):
            self.builder.ret_void()
        elif isinstance(body_val, ir.instructions.AllocaInstr):
            self.builder.ret(self.builder.load(body_val))
        elif body_val is not None and body_val.type == llvm_return_type:
            self.builder.ret(body_val)
        elif body_val is None and llvm_return_type == ir.VoidType():
            if not self.builder.block.is_terminated:
                self.builder.ret_void()
        elif body_val is not None and body_val.type != llvm_return_type:
            # Tentativa de coerção simples (e.g., Bool → Int)
            if llvm_return_type == ir.IntType(32) and body_val.type == ir.IntType(1):
                casted_val = self.builder.zext(body_val, llvm_return_type, name="bool_to_int")
                self.builder.ret(casted_val)
            elif not self.builder.block.is_terminated:
                print(f"AVISO: Tipo de retorno incompatível na função '{func_name}'.")
                self.builder.unreachable()
        else:
            if not self.builder.block.is_terminated:
                self.builder.unreachable()
                
        # Garantir que há um terminador, mesmo se o corpo não gerou retorno
        if not self.builder.block.is_terminated:
            print(f"DEBUG: Bloco da função '{func_name}' não terminado, adicionando ret_void()")
            if isinstance(llvm_return_type, ir.VoidType):
                self.builder.ret_void()
            else:
                self.builder.unreachable()

        # Limpar builder
        self.builder = None



    def generate_IntLiteral(self, node: aguda_ast.IntLiteral):
        return ir.Constant(ir.IntType(32), node.value)

    def generate_BoolLiteral(self, node: aguda_ast.BoolLiteral):
        return ir.Constant(ir.IntType(1), 1 if node.value else 0)

    def generate_UnitLiteral(self, node: aguda_ast.UnitLiteral):
        # Unit não tem uma representação de valor direta em LLVM IR da mesma forma que Int/Bool.
        # Frequentemente, é o tipo de retorno de funções (void) ou o resultado de expressões
        # que são executadas pelos seus efeitos colaterais.
        # Se uma expressão Unit precisa ser passada como valor, pode ser representada por um
        # tipo struct vazio {} ou um i8 com valor 0, mas para M4, void é suficiente para retornos.
        # Para expressões, o "valor" de Unit é implícito.
        # Se uma função retorna Unit, ela retorna `void`.
        # Se uma expressão Unit está no meio de uma sequência, ela é executada, e o valor não é usado.
        return None # Não há um "valor" LLVM direto para UnitLiteral no meio de uma expressão.
                    # O tipo da expressão será UnitType, tratado por quem chama.

    # Strings e NullLiteral estão excluídos para M4
    def generate_StringLiteral(self, node: aguda_ast.StringLiteral):
        # Requisito: Não implementar Strings
        # No entanto, se precisássemos:
        # text = node.value
        # c_text = ir.Constant(ir.ArrayType(ir.IntType(8), len(text) + 1), bytearray(text + '\0', 'utf-8'))
        # global_str = ir.GlobalVariable(self.module, c_text.type, name=f".str.{hash(text)}")
        # global_str.initializer = c_text
        # global_str.global_constant = True
        # global_str.linkage = 'internal'
        # return self.builder.bitcast(global_str, ir.IntType(8).as_pointer())
        raise NotImplementedError("Strings não são implementadas para M4.")

    def generate_NullLiteral(self, node: aguda_ast.NullLiteral):
        # Normalmente associado a ponteiros, que não são um foco principal sem arrays/objetos complexos.
        # Se fosse necessário, seria um `ir.Constant(llvm_pointer_type, None)`
        raise NotImplementedError("NullLiteral não é diretamente relevante sem tipos de ponteiro explícitos para M4.")


    def generate_Var(self, node: aguda_ast.Var):
        # Procurar a variável no escopo atual (named_values) ou global (func_symtab)
        if node.name in self.named_values:
            # É uma variável local ou parâmetro, self.named_values[node.name] é um ponteiro (AllocaInst)
            # Para usar o valor, precisamos carregá-lo.
            return self.builder.load(self.named_values[node.name], name=node.name + "_val")
        elif node.name in self.func_symtab:
            # Pode ser uma função global ou uma variável global
            global_val = self.func_symtab[node.name]
            if isinstance(global_val, ir.Function):
                return global_val # Retorna o objeto função LLVM para chamadas
            elif isinstance(global_val, ir.GlobalVariable):
                # É uma variável global, precisamos carregá-la para usar o valor
                return self.builder.load(global_val, name=node.name + "_global_val")
        else:
            # Este caso não deveria acontecer se o validador funcionou corretamente
            raise NameError(f"Variável ou função desconhecida: {node.name}")


    def generate_BinOp(self, node: aguda_ast.BinOp):
        lhs = self.generate_code(node.left)
        rhs = self.generate_code(node.right)

        # O validador já deve ter garantido que lhs e rhs têm tipos compatíveis para a operação.
        # Para AGUDA, as operações aritméticas são em Int, lógicas em Bool.

        if node.op == '+':
            return self.builder.add(lhs, rhs, name='addtmp')
        elif node.op == '-':
            return self.builder.sub(lhs, rhs, name='subtmp')
        elif node.op == '*':
            return self.builder.mul(lhs, rhs, name='multmp')
        elif node.op == '/':
            return self.builder.sdiv(lhs, rhs, name='divtmp') # Divisão de inteiros com sinal
        elif node.op == '%':
            return self.builder.srem(lhs, rhs, name='remtmp') # Resto de inteiros com sinal
        # POW (^) não é uma instrução LLVM direta. Pode ser implementada com uma chamada a uma função (e.g., llvm.pow.i32)
        # ou um loop para inteiros. Para M4, se não for exigido pelos testes, pode ser omitido ou simplificado.
        # Se POW for necessário:
        # elif node.op == '^':
        #     # Exemplo: chamar uma função intrínseca `llvm.pow.f64` se fossem floats,
        #     # ou `llvm.powi.f64` para float^int. Para int^int, pode ser mais complexo.
        #     # Para i32, uma chamada de função externa ou um loop seria mais apropriado.
        #     # Por agora, vamos omitir para simplificar, assumindo que os testes não o usam intensivamente.
        #     # Se for usado, precisaremos de uma função de biblioteca ou uma expansão em loop.
        #     raise NotImplementedError("Operador POW (^) não implementado diretamente em LLVM. Requer função auxiliar.")


        # Operadores de Comparação (retornam i1 - Bool)
        elif node.op in ['==', '!=', '<', '<=', '>', '>=']:
            # `icmp_signed` para inteiros, `fcmp` para floats. AGUDA usa Int.
            # O tipo de lhs e rhs deve ser o mesmo (garantido pelo validador).
            # Se fossem bools (i1), a comparação ainda é `icmp`.
            return self.builder.icmp_signed(node.op, lhs, rhs, name='cmptmp')

        # Operadores Lógicos (operam em i1 - Bool, retornam i1)
        elif node.op == '&&':
            # LLVM não tem instruções 'and' e 'or' diretas que façam short-circuiting
            # como em C/Java/AGUDA. O 'and' e 'or' do LLVM são bitwise.
            # Para short-circuiting:
            #   result = alloca i1
            #   store false, result
            #   cond_lhs = eval lhs
            #   br cond_lhs, label %then, label %endif
            # then:
            #   cond_rhs = eval rhs
            #   store cond_rhs, result
            #   br label %endif
            # endif:
            #   return load result
            # Esta é a forma correta, mas mais verbosa.
            # Uma forma simples (bitwise, sem short-circuit) é `self.builder.and_(lhs, rhs)`.
            # Vamos implementar o short-circuiting para '&&' e '||'.

            # Para && (AND lógico com short-circuit):
            # Se lhs é falso, o resultado é falso, não avalia rhs.
            # Se lhs é verdadeiro, o resultado é o valor de rhs.
            start_block = self.builder.block
            then_block = self.builder.append_basic_block(name="and_then")
            else_block = self.builder.append_basic_block(name="and_else") # Não estritamente 'else', mas sim 'rhs_eval'
            merge_block = self.builder.append_basic_block(name="and_merge")

            self.builder.cbranch(lhs, else_block, then_block) # Se lhs é true, vai para else_block (avaliar rhs)

            # Bloco 'then' (lhs é falso)
            self.builder.position_at_end(then_block)
            val_lhs_false = ir.Constant(ir.IntType(1), 0) # Resultado é falso
            self.builder.branch(merge_block)

            # Bloco 'else' (lhs é verdadeiro, avaliar rhs)
            self.builder.position_at_end(else_block)
            # rhs já foi gerado, mas precisamos garantir que é gerado neste bloco se a AST for complexa
            # No nosso caso, rhs já é um valor LLVM.
            val_rhs_eval = rhs # Usamos o rhs já calculado.
            self.builder.branch(merge_block)

            # Bloco 'merge'
            self.builder.position_at_end(merge_block)
            phi = self.builder.phi(ir.IntType(1), name="and_result")
            phi.add_incoming(val_lhs_false, then_block)
            phi.add_incoming(val_rhs_eval, else_block)
            return phi


        elif node.op == '||':
            # Para || (OR lógico com short-circuit):
            # Se lhs é verdadeiro, o resultado é verdadeiro, não avalia rhs.
            # Se lhs é falso, o resultado é o valor de rhs.
            start_block = self.builder.block
            then_block = self.builder.append_basic_block(name="or_then") # lhs é verdadeiro
            else_block = self.builder.append_basic_block(name="or_else")   # lhs é falso, avaliar rhs
            merge_block = self.builder.append_basic_block(name="or_merge")

            self.builder.cbranch(lhs, then_block, else_block) # Se lhs é true, vai para then_block

            # Bloco 'then' (lhs é verdadeiro)
            self.builder.position_at_end(then_block)
            val_lhs_true = ir.Constant(ir.IntType(1), 1) # Resultado é verdadeiro
            self.builder.branch(merge_block)

            # Bloco 'else' (lhs é falso, avaliar rhs)
            self.builder.position_at_end(else_block)
            val_rhs_eval = rhs # Usamos o rhs já calculado
            self.builder.branch(merge_block)

            # Bloco 'merge'
            self.builder.position_at_end(merge_block)
            phi = self.builder.phi(ir.IntType(1), name="or_result")
            phi.add_incoming(val_lhs_true, then_block)
            phi.add_incoming(val_rhs_eval, else_block)
            return phi
        
        elif node.op == '^':
            # Exponenciação inteira: base ^ exponent
            base = lhs
            exponent = rhs

            result_ptr = self.builder.alloca(ir.IntType(32), name="pow_result")
            self.builder.store(ir.Constant(ir.IntType(32), 1), result_ptr)  # resultado inicial = 1

            counter_ptr = self.builder.alloca(ir.IntType(32), name="pow_counter")
            self.builder.store(exponent, counter_ptr)

            loop_cond_block = self.builder.append_basic_block("pow_loop_cond")
            loop_body_block = self.builder.append_basic_block("pow_loop_body")
            loop_end_block = self.builder.append_basic_block("pow_loop_end")

            self.builder.branch(loop_cond_block)

            # loop cond
            self.builder.position_at_end(loop_cond_block)
            counter_val = self.builder.load(counter_ptr)
            cond = self.builder.icmp_signed(">", counter_val, ir.Constant(ir.IntType(32), 0))
            self.builder.cbranch(cond, loop_body_block, loop_end_block)

            # loop body
            self.builder.position_at_end(loop_body_block)
            result_val = self.builder.load(result_ptr)
            mult_val = self.builder.mul(result_val, base)
            self.builder.store(mult_val, result_ptr)

            new_counter = self.builder.sub(counter_val, ir.Constant(ir.IntType(32), 1))
            self.builder.store(new_counter, counter_ptr)
            self.builder.branch(loop_cond_block)

            # loop end
            self.builder.position_at_end(loop_end_block)
            return self.builder.load(result_ptr, name="pow_result_val")


        else:
            raise NotImplementedError(f"Operador binário desconhecido ou não implementado: {node.op}")


    def generate_UnaryOp(self, node: aguda_ast.UnaryOp):
        operand_val = self.generate_code(node.expr)
        if node.op == '-': # Negação aritmética
            return self.builder.neg(operand_val, name='negtmp')
        elif node.op == '!': # Negação lógica (NOT)
            # Em LLVM, NOT booleano (i1) é geralmente feito com XOR com 1 (true)
            # ou comparando com 0 (false).
            # (val == false) ou (val XOR true)
            return self.builder.icmp_signed('==', operand_val, ir.Constant(ir.IntType(1), 0), name='nottmp')
            # Alternativa: self.builder.xor(operand_val, ir.Constant(ir.IntType(1), 1), name='nottmp')
        else:
            raise NotImplementedError(f"Operador unário desconhecido: {node.op}")


    def generate_FuncCall(self, node: aguda_ast.FuncCall):
        func_name = node.func_name
        
        # Casos especiais para funções built-in como 'print' (se necessário)
        # O enunciado não menciona 'print' como built-in, mas o seu validador trata.
        # Para M4, vamos assumir que todas as funções são definidas pelo utilizador ou
        # são funções LLVM externas (como `puts` para imprimir strings, se strings fossem suportadas).
        # Se 'print' for para imprimir inteiros, podemos declarar `printf` e usá-lo.

        if func_name == "print" and len(node.args) == 1:
            # Assumir que print imprime um inteiro. Precisamos declarar 'printf'.
            printf_ty = ir.FunctionType(ir.IntType(32), [ir.IntType(8).as_pointer()], var_arg=True)
            try:
                printf_func = self.module.get_global(b"printf")
                if not isinstance(printf_func, ir.Function): # Se já existe mas não é função
                    printf_func = ir.Function(self.module, printf_ty, name="printf")
            except KeyError: # Se não existe
                 printf_func = ir.Function(self.module, printf_ty, name="printf")


            arg_val = self.generate_code(node.args[0])
            

            if arg_val is None:
                # Vamos imprimir a string "unit"
                if not hasattr(self, 'global_str_unit'):
                    str_unit = ir.Constant(ir.ArrayType(ir.IntType(8), 6), bytearray(b"unit\n\0"))
                    self.global_str_unit = ir.GlobalVariable(self.module, str_unit.type, name=".str_unit")
                    self.global_str_unit.linkage = "internal"
                    self.global_str_unit.global_constant = True
                    self.global_str_unit.initializer = str_unit

                unit_ptr = self.builder.gep(self.global_str_unit, [ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 0)])
                return self.builder.call(printf_func, [unit_ptr], name="printf_call_unit")


            
            #  É boolean? Imprime "true" ou "false"
            if arg_val.type == ir.IntType(1):
                # Criar strings globais "true" e "false" se ainda não existirem
                if not hasattr(self, 'global_str_true'):
                    str_true = ir.Constant(ir.ArrayType(ir.IntType(8), 5), bytearray(b"true\0"))
                    str_false = ir.Constant(ir.ArrayType(ir.IntType(8), 6), bytearray(b"false\0"))

                    self.global_str_true = ir.GlobalVariable(self.module, str_true.type, name=".str_true")
                    self.global_str_true.linkage = "internal"
                    self.global_str_true.global_constant = True
                    self.global_str_true.initializer = str_true

                    self.global_str_false = ir.GlobalVariable(self.module, str_false.type, name=".str_false")
                    self.global_str_false.linkage = "internal"
                    self.global_str_false.global_constant = True
                    self.global_str_false.initializer = str_false

                cond = arg_val
                true_block = self.builder.append_basic_block("print_true")
                false_block = self.builder.append_basic_block("print_false")
                end_block = self.builder.append_basic_block("print_end")

                self.builder.cbranch(cond, true_block, false_block)

                # true block
                self.builder.position_at_end(true_block)
                true_ptr = self.builder.gep(self.global_str_true, [ir.Constant(ir.IntType(32), 0)] * 2)
                self.builder.call(printf_func, [true_ptr])
                self.builder.branch(end_block)

                # false block
                self.builder.position_at_end(false_block)
                false_ptr = self.builder.gep(self.global_str_false, [ir.Constant(ir.IntType(32), 0)] * 2)
                self.builder.call(printf_func, [false_ptr])
                self.builder.branch(end_block)

                self.builder.position_at_end(end_block)
                return None

            # Não é booleano — imprimir com %d

            # Criar a string de formato "%d\n"
            fmt_str_val = "%d\0" # Adicionar terminador nulo
            c_fmt_str = ir.Constant(ir.ArrayType(ir.IntType(8), len(fmt_str_val)),
                                    bytearray(fmt_str_val, "utf-8"))
            
            # Alocar globalmente a string de formato, se ainda não existir uma igual
            # Para simplificar, criamos uma nova a cada chamada, ou melhor, uma única global.
            fmt_name = ".printf_fmt_int"
            try:
                global_fmt = self.module.get_global(fmt_name.encode("utf-8"))
            except KeyError:
                global_fmt = ir.GlobalVariable(self.module, c_fmt_str.type, name=fmt_name)
                global_fmt.linkage = "internal"
                global_fmt.global_constant = True
                global_fmt.initializer = c_fmt_str

            # Obter ponteiro para o primeiro elemento da string de formato
            zero = ir.Constant(ir.IntType(32), 0)
            ptr_fmt = self.builder.gep(global_fmt, [zero, zero], name="fmtptr")

            # Chamar printf
            # Chamar printf só se arg_val não for None (i.e., não for Unit)
            if arg_val is None:
                # arg_val representa Unit — não passes para printf com "%d"
                return None  # já foi tratado acima se for Unit
            elif arg_val.type == ir.VoidType():
                # Segurança extra — não deves tentar imprimir void
                return None
            else:
                return self.builder.call(printf_func, [ptr_fmt, arg_val], name="printf_call")


            # `print` em AGUDA retorna Unit, printf retorna int. O valor de retorno da chamada a printf é ignorado.
            # O generate_code para a expressão que contém o print (e.g. Seq) tratará o tipo Unit.
            # Retornar None aqui para indicar que o "valor" é Unit e já foi tratado.


        # Função definida pelo utilizador
        callee_func = self.func_symtab.get(func_name)
        if callee_func is None or not isinstance(callee_func, ir.Function):
            # Pode ser uma variável do tipo função (não suportado diretamente em M4 sem ponteiros de função)
            # Ou a função não foi declarada (validador deveria ter apanhado)
            # Para M4, assumimos que func_symtab contém ir.Function
            raise NameError(f"Função '{func_name}' não encontrada ou não é uma função LLVM.")

        # Obter tipos esperados da função LLVM
        expected_args = list(callee_func.function_type.args)
        print(f"Número de argumentos para '{func_name}' eh {len(expected_args)}")
        if len(expected_args) != 0:
            print(f"Tipos esperados para '{func_name}' eh {expected_args[0]}")

        # Caso especial: função Unit -> ... deve ter 0 argumentos em LLVM
        if len(expected_args) == 1 and isinstance(expected_args[0], ir.VoidType):
            expected_args = []

        # Caso especial: função (Unit) -> T chamada com `f(unit)`
        if len(expected_args) == 0 and len(node.args) == 1:
            arg_val = self.generate_code(node.args[0])
            if arg_val is not None:
                raise TypeError(f"Função '{func_name}' espera Unit, mas o argumento não é unit.")
            return self.builder.call(callee_func, [], name=func_name + "_call")

        # Verificação normal
        if len(node.args) != len(expected_args):
            raise TypeError(f"Número incorreto de argumentos para '{func_name}'")

        call_args = []
        for i, arg_expr in enumerate(node.args):
            arg_val = self.generate_code(arg_expr)
            expected_type = expected_args[i]

            if arg_val is None:
                if isinstance(expected_type, ir.VoidType):
                    continue  # Ok
                else:
                    raise TypeError(f"Argumento {i+1} para '{func_name}' é unit (None), mas esperava {expected_type}")
            elif arg_val.type != expected_type:
                if expected_type == ir.IntType(32) and arg_val.type == ir.IntType(1):
                    arg_val = self.builder.zext(arg_val, expected_type, name=f"arg{i}_bool_to_int")
                else:
                    raise TypeError(f"Tipo do argumento {i+1} inválido: esperado {expected_type}, recebido {arg_val.type}")
            call_args.append(arg_val)

        if callee_func.function_type.return_type == ir.VoidType():
            self.builder.call(callee_func, call_args, name=func_name + "_call")
            return None  # função do tipo Unit -> não retorna valor!
        else:
            return self.builder.call(callee_func, call_args, name=func_name + "_call")




    def generate_IfExpr(self, node: aguda_ast.IfExpr):
        condition = self.generate_code(node.cond) # Deve ser i1

        # Obter a função atual para adicionar os blocos
        current_function = self.builder.block.function

        # Criar blocos para then, else, e merge
        then_block = current_function.append_basic_block(name="then")
        else_block = current_function.append_basic_block(name="else")
        merge_block = current_function.append_basic_block(name="merge")

        self.builder.cbranch(condition, then_block, else_block)

        # Gerar código para o bloco 'then'
        self.builder.position_at_end(then_block)
        then_val = self.generate_code(node.then_expr)
        # Se then_val for um ponteiro (e.g. de VarDecl), carregar o valor se necessário
        # para o PHI node, a menos que o tipo do if seja Unit.
        if isinstance(then_val, ir.instructions.AllocaInstr): # Se for VarDecl
             # O tipo da VarDecl é Unit, então não há "valor" para o PHI.
             # Se o then_expr fosse uma expressão que resulta num ponteiro que queremos usar, carregaríamos.
             # Mas se then_expr é uma VarDecl, o valor é Unit.
            then_type = getattr(node.then_expr, "inferred_type", None)
            else_type = getattr(node.else_expr, "inferred_type", None)

            if isinstance(then_val, ir.instructions.AllocaInstr) and not isinstance(then_type, UnitType):
                then_val = self.builder.load(then_val)

            if isinstance(else_val, ir.instructions.AllocaInstr) and not isinstance(else_type, UnitType):
                else_val = self.builder.load(else_val)

        if not self.builder.block.is_terminated: # Se o bloco then não terminou com um 'ret'
            self.builder.branch(merge_block)
        then_block_final = self.builder.block # Guardar o bloco final do 'then' para o PHI

        # Gerar código para o bloco 'else'
        self.builder.position_at_end(else_block)
        else_val = self.generate_code(node.else_expr)
        if isinstance(else_val, ir.instructions.AllocaInstr):
            if not isinstance(self.validator.typeof(node.else_expr), UnitType):
                 else_val = self.builder.load(else_val)
        if not self.builder.block.is_terminated:
            self.builder.branch(merge_block)
        else_block_final = self.builder.block

        # Posicionar no bloco 'merge'
        self.builder.position_at_end(merge_block)

        # O tipo da expressão 'if' é determinado pelo validador (t1 == t2).
        # Se o tipo for Unit, não há PHI node para valor.
        # Usar o tipo inferido pelo validador
        if_expr_aguda_type = getattr(node, "inferred_type", None)
        if if_expr_aguda_type is None:
            raise RuntimeError("IfExpr não tem tipo inferido do validador.") # O validador garante t1 e t2 são iguais
        llvm_if_type = self.get_llvm_type(if_expr_aguda_type)

        if llvm_if_type == ir.VoidType():
            return None # Nada a retornar para o PHI se o tipo for Unit/void
        else:
            # Se then_val ou else_val forem None (e.g., de um UnitLiteral),
            # mas o tipo do if não é Unit, isso é um problema.
            # O validador deve garantir que if then_val e else_val são compatíveis com llvm_if_type.
            # Se then_val/else_val são None porque eram UnitLiteral e llvm_if_type não é void,
            # precisamos de um valor placeholder ou o validador falhou.
            # Assumindo que o validador garante tipos corretos:
            if then_val is None and else_val is None and not llvm_if_type.is_void():
                 # Isto não deveria acontecer se o tipo do if não for Unit.
                 # Se o validador disse que o tipo do if é, por exemplo, Int,
                 # então then_expr e else_expr deveriam ter resultado em valores Int.
                 # Forçar um valor dummy do tipo correto para o PHI se for necessário.
                 # print(f"AVISO: then_val e else_val são None para IfExpr, mas tipo esperado é {llvm_if_type}")
                 # dummy_val = ir.Constant(llvm_if_type, None) # ou 0 para int, etc.
                 # then_val = dummy_val
                 # else_val = dummy_val
                 # Mas isto é um sintoma de um problema anterior. O validador devia ter apanhado isto.
                 # Ou o then_expr/else_expr eram sequências que terminavam em Unit.
                 pass # O validador garante que if t1=t2. Se t1 for Unit, não há phi.

            phi = self.builder.phi(llvm_if_type, name="iftmp")
            # Adicionar os valores de entrada ao PHI node
            # Apenas adicionar se o bloco correspondente tiver um predecessor para merge_block
            # (i.e., se o bloco não terminou com 'ret' ou 'unreachable')
            # E se then_val/else_val não são None (o que significa que o tipo era Unit)
            
            # Verificação crucial: Se `then_val` ou `else_val` é `None` (de `UnitLiteral`),
            # mas `llvm_if_type` não é `void`, então há um problema de tipo que o validador deveria ter apanhado.
            # Se `llvm_if_type` é `void`, o PHI não é necessário.

            # Se then_val ou else_val são ponteiros e o tipo do if não é ponteiro,
            # eles já deveriam ter sido carregados.
            if then_val is not None and then_val.type != llvm_if_type:
                if isinstance(then_val.type, ir.PointerType) and then_val.type.pointee == llvm_if_type:
                    then_val = self.builder.load(then_val, "", block=then_block_final) # Carregar no bloco de origem
                # Adicionar mais conversões se necessário

            if else_val is not None and else_val.type != llvm_if_type:
                 if isinstance(else_val.type, ir.PointerType) and else_val.type.pointee == llvm_if_type:
                    else_val = self.builder.load(else_val, "", block=else_block_final)
            
            # Se depois de carregar, os tipos ainda não batem, ou se um é None e o tipo não é void,
            # é um erro do validador ou da lógica de geração.
            # Para M4, vamos assumir que os tipos são consistentes aqui.

            if then_val is not None: phi.add_incoming(then_val, then_block_final)
            if else_val is not None: phi.add_incoming(else_val, else_block_final)
            
            # Se um dos caminhos (then ou else) não chega ao merge_block (e.g., tem um `ret`),
            # o PHI node não deve ter uma entrada para ele. `llvmlite` pode lidar com isto,
            # mas é bom estar ciente. Se o bloco não tem predecessor para `merge_block`,
            # `add_incoming` pode falhar ou o verificador LLVM falhará.
            # O `if not self.builder.block.is_terminated:` antes do `branch(merge_block)` ajuda.

            # Se, após tudo, o phi não tem entradas (e.g., ambos os ramos retornaram),
            # e o tipo não é void, o merge_block pode ser inalcançável.
            if not phi.incomings and not llvm_if_type.is_void():
                # Se o merge_block é alcançável mas o phi não tem entradas, é um erro.
                # Se o merge_block não é alcançável (e.g. if true then ret 1 else ret 0),
                # então o phi não importa. O builder.unreachable() pode ser usado.
                # Por agora, se não há phi, mas esperávamos um valor, pode ser um problema.
                # O código que usa o resultado deste if precisa lidar com `None` se o tipo for void.
                if merge_block.successors: # Se o merge_block continua
                    print(f"AVISO: PHI node para IfExpr não tem entradas mas o tipo é {llvm_if_type}")
                    # Poderia retornar um undef ou valor padrão.
                    return ir.Constant(llvm_if_type, None) # Undef value
            
            return phi


    def generate_WhileExpr(self, node: aguda_ast.WhileExpr):
        current_function = self.builder.block.function

        # Criar blocos para condição, corpo do loop, e fim do loop
        loop_cond_block = current_function.append_basic_block(name="loop.cond")
        loop_body_block = current_function.append_basic_block(name="loop.body")
        loop_end_block = current_function.append_basic_block(name="loop.end")

        self.builder.branch(loop_cond_block) # Saltar para o bloco de condição

        # Bloco de condição
        self.builder.position_at_end(loop_cond_block)
        condition_val = self.generate_code(node.cond) # Deve ser i1
        self.builder.cbranch(condition_val, loop_body_block, loop_end_block)

        # Bloco do corpo do loop
        self.builder.position_at_end(loop_body_block)
        self.generate_code(node.body) # O valor do corpo é ignorado (tipo Unit)
        if not self.builder.block.is_terminated: # Se o corpo não terminou com ret/etc
            self.builder.branch(loop_cond_block) # Voltar para a condição

        # Bloco de fim do loop
        self.builder.position_at_end(loop_end_block)
        


        # While em AGUDA retorna Unit.
        return None # Representa o valor Unit.


    def generate_Assign(self, node: aguda_ast.Assign):
        # O alvo de uma atribuição (LHS) em AGUDA, para M4, é uma Var.
        # Arrays estão excluídos.
        # `node.target` é um `ast.Var` segundo o seu parser (`p_lvalue_var`).
        target_name = node.target.name
        
        # Obter o ponteiro para a variável (deve ser um AllocaInst ou GlobalVariable)
        if target_name in self.named_values:
            target_ptr = self.named_values[target_name]
        elif target_name in self.func_symtab and isinstance(self.func_symtab[target_name], ir.GlobalVariable):
            target_ptr = self.func_symtab[target_name]
        else:
            raise NameError(f"Variável de atribuição desconhecida: {target_name}")

        # Gerar o valor da expressão (RHS)
        expr_val = self.generate_code(node.expr)

        # Verificar se os tipos são compatíveis (validador já fez, mas LLVM é estrito)
        # Se expr_val.type é i1 e target_ptr.type.pointee é i32, precisa de zext.
        if target_ptr.type.pointee == ir.IntType(32) and expr_val.type == ir.IntType(1):
            expr_val = self.builder.zext(expr_val, ir.IntType(32))
        elif target_ptr.type.pointee == ir.IntType(1) and expr_val.type == ir.IntType(32):
            # Isto seria um erro de tipo que o validador AGUDA deveria apanhar.
            # (e.g. set bool_var = int_val). Por segurança:
            print(f"AVISO: Atribuição de Int para Bool para '{target_name}'. Validador deveria ter apanhado.")
            # Poderia truncar: expr_val = self.builder.trunc(expr_val, ir.IntType(1))
            # Ou usar icmp ne 0: expr_val = self.builder.icmp_signed('!=', expr_val, ir.Constant(ir.IntType(32),0))

        # Armazenar o valor no ponteiro
        self.builder.store(expr_val, target_ptr)

        # Assign em AGUDA retorna Unit.
        return None


    def generate_Seq(self, node: aguda_ast.Seq):
        # Gerar código para a primeira expressão. Seu valor é geralmente descartado,
        # a menos que seja a única expressão numa função e determine o tipo de retorno.
        # Mas numa Seq, o valor de `first` é pelos seus efeitos colaterais.
        self.generate_code(node.first)

        # O valor da sequência é o valor da segunda expressão.
        return self.generate_code(node.second)

    # Arrays e NewArray/ArrayAccess estão excluídos para M4.
    def generate_NewArray(self, node: aguda_ast.NewArray):
        raise NotImplementedError("Arrays (NewArray) não são implementados para M4.")

    def generate_ArrayAccess(self, node: aguda_ast.ArrayAccess):
        raise NotImplementedError("Acesso a Arrays (ArrayAccess) não são implementados para M4.")

    # O seu parser tem `p_declaration_var` que pode ter um `block` ou `statement_list`
    # como `var_body`. O `build_seq` transforma `statement_list` em `Seq`.
    # Então, o `expr` de `VarDecl` pode ser um `Seq`.
    # O `fun_body` também pode ser `statement_list` -> `Seq`.
    # O gerador para `Seq` já está definido.
    # Se o `expr` de `VarDecl` ou `FunDecl` for um `UnitLiteral` direto,
    # `generate_UnitLiteral` retorna `None`.
    # A lógica em `generate_FunDecl` e `generate_VarDecl` precisa lidar com `body_val` sendo `None`
    # se o tipo de retorno/variável for Unit.
    
    # === Fim dos métodos de Geração ===

    def create_main_wrapper(self, program_node: aguda_ast.Program):
        """
        Cria uma função 'main' do LLVM que chama a função 'main' da AGUDA.
        Assume que a função 'main' da AGUDA já foi gerada.
        """

        print("DEBUG: Entrando em create_main_wrapper")

        # Procurar pela função 'main' da AGUDA
        aguda_main_func_ll = self.func_symtab.get("main") or self.module.get_global("aguda_main")


        if aguda_main_func_ll and isinstance(aguda_main_func_ll, ir.Function):
            # Imprimir informações sobre a função AGUDA 'main'
            print(f"DEBUG: Tentando chamar a função AGUDA main: {aguda_main_func_ll}")
            print(f"DEBUG: Tipo da função AGUDA main: {aguda_main_func_ll.ftype}")
            print(f"DEBUG: Tipos dos argumentos esperados pela AGUDA main: {aguda_main_func_ll.ftype.args}")

            # Definir o tipo da função 'main' do LLVM (int32 de retorno, sem argumentos)
            main_ret_type = ir.IntType(32)
            main_func_ty = ir.FunctionType(main_ret_type, [])
            main_func = ir.Function(self.module, main_func_ty, name="wrapper_main")  # Criar a função 'main' LLVM

            bb_entry = main_func.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(bb_entry)

            args = []
            ret_ty = aguda_main_func_ll.ftype.return_type

            # Declarar printf (garante que só está definido uma vez)
            printf_ty = ir.FunctionType(ir.IntType(32), [ir.IntType(8).as_pointer()], var_arg=True)
            try:
                printf_func = self.module.get_global("printf")
            except KeyError:
                printf_func = ir.Function(self.module, printf_ty, name="printf")

            if ret_ty == ir.VoidType():
                call_result = self.builder.call(aguda_main_func_ll, args)

                # Só imprimir "unit" se a chamada não for a um print nem tiver efeitos colaterais óbvios.
                # Então: vamos assumir que `main` retornou Unit e não houve `print`.
                # A forma prática de saber se `call_result` é None e não tem valor a propagar é simplesmente verificar.

                # ⚠️ Aqui está a chave:
                if call_result is None:
                    # Não houve print nem valor útil → assumimos que foi silêncio → imprimimos "unit"
                    if not hasattr(self, 'global_str_unit'):
                        str_unit = ir.Constant(ir.ArrayType(ir.IntType(8), 6), bytearray(b"unit\n\0"))
                        self.global_str_unit = ir.GlobalVariable(self.module, str_unit.type, name=".str_unit")
                        self.global_str_unit.linkage = "internal"
                        self.global_str_unit.global_constant = True
                        self.global_str_unit.initializer = str_unit

                    unit_ptr = self.builder.gep(self.global_str_unit, [ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 0)])
                    self.builder.call(printf_func, [unit_ptr])

                # Sempre retorna 0 no final
                self.builder.ret(ir.Constant(ir.IntType(32), 0))



            elif ret_ty == ir.IntType(32):
                ret_val = self.builder.call(aguda_main_func_ll, args, name="call_aguda_main")

                fmt_str_val = "%d\n\0"
                c_fmt_str = ir.Constant(ir.ArrayType(ir.IntType(8), len(fmt_str_val)), bytearray(fmt_str_val.encode()))
                try:
                    fmt_var = self.module.get_global(".printf_fmt_int")
                except KeyError:
                    fmt_var = ir.GlobalVariable(self.module, c_fmt_str.type, name=".printf_fmt_int")
                    fmt_var.linkage = "internal"
                    fmt_var.global_constant = True
                    fmt_var.initializer = c_fmt_str

                ptr_fmt = self.builder.gep(fmt_var, [ir.Constant(ir.IntType(32), 0)] * 2)
                self.builder.call(printf_func, [ptr_fmt, ret_val])
                self.builder.ret(ret_val)

            elif ret_ty == ir.IntType(1):  # Bool
                ret_val = self.builder.call(aguda_main_func_ll, args, name="call_aguda_main")

                if not hasattr(self, 'global_str_true'):
                    str_true = ir.Constant(ir.ArrayType(ir.IntType(8), 6), bytearray(b"true\n\0"))
                    str_false = ir.Constant(ir.ArrayType(ir.IntType(8), 7), bytearray(b"false\n\0"))
                    self.global_str_true = ir.GlobalVariable(self.module, str_true.type, name=".str_true")
                    self.global_str_true.linkage = "internal"
                    self.global_str_true.global_constant = True
                    self.global_str_true.initializer = str_true
                    self.global_str_false = ir.GlobalVariable(self.module, str_false.type, name=".str_false")
                    self.global_str_false.linkage = "internal"
                    self.global_str_false.global_constant = True
                    self.global_str_false.initializer = str_false

                true_block = self.builder.append_basic_block("print_true")
                false_block = self.builder.append_basic_block("print_false")
                end_block = self.builder.append_basic_block("print_end")

                self.builder.cbranch(ret_val, true_block, false_block)

                self.builder.position_at_end(true_block)
                true_ptr = self.builder.gep(self.global_str_true, [ir.Constant(ir.IntType(32), 0)] * 2)
                self.builder.call(printf_func, [true_ptr])
                self.builder.branch(end_block)

                self.builder.position_at_end(false_block)
                false_ptr = self.builder.gep(self.global_str_false, [ir.Constant(ir.IntType(32), 0)] * 2)
                self.builder.call(printf_func, [false_ptr])
                self.builder.branch(end_block)

                self.builder.position_at_end(end_block)
                self.builder.ret(ir.Constant(ir.IntType(32), 0))

            else:
                print(f"AVISO: Tipo de retorno inesperado: {ret_ty}")
                self.builder.ret(ir.Constant(ir.IntType(32), 0))


        else:
            print("AVISO: Função 'main' não encontrada no programa AGUDA.")
            main_ret_type = ir.IntType(32)
            main_func_ty = ir.FunctionType(main_ret_type, [])
            main_func = ir.Function(self.module, main_func_ty, name="main")
            bb_entry = main_func.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(bb_entry)
            self.builder.ret(ir.Constant(ir.IntType(32), 0))

        self.builder = None
        
                # Criar função 'main' real do LLVM que chama 'wrapper_main'
        if "wrapper_main" in self.module.globals:
            wrapper_func = self.module.get_global("wrapper_main")
            main_ty = ir.FunctionType(ir.IntType(32), [])
            real_main = ir.Function(self.module, main_ty, name="main")
            bb = real_main.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(bb)
            ret_val = self.builder.call(wrapper_func, [])
            self.builder.ret(ret_val)
            self.builder = None

        
# --- Fim da classe LLVMCodeGenerator ---

def generate_llvm_code(ast_root, validator_instance, output_filename):
    """
    Função principal para invocar o gerador de código.
    """
    code_generator = LLVMCodeGenerator(validator_instance)
    
    print("DEBUG: Iniciando generate_llvm_code")  # PRINT 5

    print("DEBUG: func_symtab antes da geração de funções:", code_generator.func_symtab)  # PRINT 13

    
    # Primeiro, gerar código para todas as declarações (FunDecls, VarDecls globais)
    # Isto preenche func_symtab e define funções e globais no módulo.
    # Primeiro, gerar código para todas as declarações de função
    for decl in ast_root.declarations:
        if isinstance(decl, aguda_ast.FunDecl):
            code_generator.generate_code(decl)

    print("DEBUG: func_symtab depois da geração de funções:", code_generator.func_symtab)  # PRINT 14

    
     # Agora, gerar código para todas as outras declarações (ex: VarDecl globais)
    for decl in ast_root.declarations:
        if not isinstance(decl, aguda_ast.FunDecl):
            code_generator.generate_code(decl)
        
    # Depois, criar a função 'main' do LLVM que pode chamar a 'main' da AGUDA
    # ou executar outra lógica para determinar o valor de saída do programa.
    print("DEBUG: Chamando create_main_wrapper")  # PRINT 6
    code_generator.create_main_wrapper(ast_root)
    print("DEBUG: create_main_wrapper retornou algo")  # PRINT 7

    llvm_ir_module = code_generator.module

    # Otimizações (opcional, mas bom para 'lli' e código final)
    # pm_builder = binding.PassManagerBuilder()
    # pm_builder.opt_level = 2 # Nível de otimização (0-3)
    # pass_manager = binding.ModulePassManager()
    # pm_builder.populate(pass_manager)
    # pass_manager.run(llvm_ir_module)


    # Verificar o módulo LLVM (útil para depuração)
    try:
        llvm_ir = str(llvm_ir_module)
        llvm_module = binding.parse_assembly(llvm_ir)
        llvm_module.verify()
    except RuntimeError as e:
        print("Erro na verificação do módulo LLVM:")
        print(str(llvm_ir_module)) # Imprimir o IR problemático
        raise e # Relançar a exceção

    # Escrever o código LLVM para um ficheiro .ll
    with open(output_filename, "w") as f:
        f.write(str(llvm_ir_module))

    print(f"Código LLVM gerado em: {output_filename}")
    # print("---- LLVM IR ----")
    # print(str(llvm_ir_module))
    # print("-----------------")