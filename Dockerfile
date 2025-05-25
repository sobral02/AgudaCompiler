FROM python:3.13-slim

WORKDIR /app

# Instalar LLVM e Clang (que inclui 'lli')
# 'wget' e 'gnupg' são necessários para adicionar o repositório LLVM.
# Você pode precisar de pacotes de runtime do LLVM dependendo da versão.
# Uma forma mais simples e direta pode ser instalar `llvm` e `clang`.
RUN apt-get update && \
    apt-get install -y llvm clang && \
    rm -rf /var/lib/apt/lists/*

# 1. Copia o ficheiro requirements.txt primeiro para otimizar o cache da build.
COPY requirements.txt .

# 2. Cria um NOVO ambiente virtual DENTRO do container.
RUN python3 -m venv venv

# 3. Configura o PATH do container para usar o Python e pip DESSE NOVO VENV.
ENV PATH="/app/venv/bin:$PATH"

# 4. Instala TODAS as dependências listadas no requirements.txt NESTE NOVO VENV.
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copia o restante do seu código (o .dockerignore impede que o venv local seja copiado).
COPY . .

# Essencial: Configura o PYTHONPATH para incluir o diretório pai do seu pacote 'aguda'.
ENV PYTHONPATH="${PYTHONPATH}:/app/src/aguda-cabal"

# O comando para iniciar sua aplicação (seja o main.py ou o run_valid_tests_expected.py)
# Se você quer executar o script de testes por padrão ao levantar o container:
CMD [ "bash" ]
# Se você ainda quer o main.py como padrão e executa o teste manualmente:
# CMD ["python", "src/aguda-cabal/aguda/main.py"]