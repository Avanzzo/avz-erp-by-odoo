# Guia: executar o Odoo localmente com Docker

Este guia descreve como iniciar o Odoo e o PostgreSQL definidos neste repositório no commit `53dae17cf82f17a5db9201b804a0fac3d26e52b1`.

## 1. Pré-requisitos

Instale e inicie o Docker Engine ou Docker Desktop. O comando `docker compose` (Compose v2) também precisa estar disponível. Confira no terminal:

```sh
docker --version
docker compose version
```

## 2. Abra o projeto no commit esperado

No terminal, entre na pasta raiz do repositório, onde estão `Dockerfile` e `docker-compose.yml`:

```sh
cd /caminho/para/voigt-erp-by-odoo
git checkout 53dae17cf82f17a5db9201b804a0fac3d26e52b1
```

Se esse commit já for o checkout atual, não é necessário executar o `git checkout` novamente. O comando pode deixar o Git em estado *detached HEAD*, o que é suficiente para executar esta versão do projeto.

## 3. Crie o arquivo de ambiente

Copie o modelo:

```sh
cp .env.example .env
```

Abra `.env` e substitua `POSTGRES_PASSWORD` e `ODOO_MASTER_PASSWORD` por senhas fortes e diferentes. Esses valores são usados, respectivamente, na conexão do Odoo com o PostgreSQL e no gerenciamento de bancos de dados do Odoo. Não compartilhe nem versione o arquivo `.env`.

As portas publicadas por padrão são `8069` para a interface web e `8072` para o serviço gevent/bus. Se alguma estiver ocupada, altere `ODOO_HTTP_PORT` ou `ODOO_GEVENT_PORT` no `.env`, por exemplo:

```dotenv
ODOO_HTTP_PORT=18069
ODOO_GEVENT_PORT=18072
```

Nesse exemplo, o navegador acessará o Odoo em `http://localhost:18069`.

## 4. Construa a imagem e inicie os serviços

Na raiz do repositório, execute:

```sh
docker compose up --build -d
```

Na primeira execução, o Docker baixa as imagens base, instala as dependências e constrói a imagem do Odoo. Esse processo pode levar alguns minutos. O Compose inicia o Odoo depois que o PostgreSQL estiver respondendo à verificação de saúde.

Confira os serviços:

```sh
docker compose ps
```

Para acompanhar a inicialização do Odoo:

```sh
docker compose logs -f odoo
```

Pressione `Ctrl+C` para parar de acompanhar os logs; isso não encerra os containers.

## 5. Crie o primeiro banco e acesse o Odoo

Abra <http://localhost:8069> (ou a porta configurada em `ODOO_HTTP_PORT`). Na tela inicial de criação do banco:

1. Informe a senha mestra definida em `ODOO_MASTER_PASSWORD` no `.env`.
2. Escolha um nome para o banco de dados.
3. Informe o e-mail e a senha do usuário administrador do Odoo. Esses dados serão usados para entrar na aplicação e são diferentes da senha mestra.
4. Escolha o idioma e o país e, se desejar uma base de demonstração, habilite os dados de demonstração.
5. Crie o banco e aguarde a conclusão da instalação inicial.

Depois, entre com o e-mail e a senha do administrador que acabou de cadastrar. A porta `8072` fica publicada para o tráfego gevent/bus usado por recursos de atualização em tempo real.

## 6. Comandos úteis

Na raiz do repositório:

```sh
# Acompanhar logs dos dois serviços
docker compose logs -f

# Reiniciar os serviços
docker compose restart

# Parar e remover os containers e a rede, preservando os dados
docker compose down

# Iniciar novamente após parar
docker compose up -d
```

O banco PostgreSQL e os arquivos do Odoo ficam em volumes Docker nomeados, então `docker compose down` preserva esses dados. Para apagar também o banco e o filestore e recomeçar do zero, use:

```sh
docker compose down -v
```

Esse último comando remove permanentemente os volumes `postgres-data` e `odoo-data` deste projeto.

## 7. Alterações no código-fonte

O Dockerfile copia o código do repositório para dentro da imagem durante a construção. Portanto, mudanças no código ou nos addons exigem uma nova construção e reinício:

```sh
docker compose up --build -d
```

## 8. Solução de problemas

- **A porta já está em uso:** ajuste `ODOO_HTTP_PORT` e/ou `ODOO_GEVENT_PORT` no `.env` e recrie os containers com `docker compose up -d`.
- **O Odoo não inicia:** consulte `docker compose logs odoo` e confirme que o PostgreSQL ficou saudável com `docker compose ps`.
- **Senha alterada, mas a conexão do banco falha:** o PostgreSQL mantém a senha inicializada no volume. Alterar `POSTGRES_PASSWORD` depois da primeira execução não atualiza a senha dentro de um banco já existente. Em ambiente local descartável, `docker compose down -v` remove os dados e permite inicializar novamente com a nova senha.
- **A página não abre:** confirme que o Docker está em execução, que o serviço `odoo` está ativo e que está usando a porta host definida em `ODOO_HTTP_PORT`.

## Serviços e persistência

O Compose executa dois serviços: `odoo`, que publica a interface HTTP e o gevent/bus, e `db`, baseado em PostgreSQL 16, acessível apenas pela rede interna do Compose. O volume `postgres-data` guarda os dados do banco; `odoo-data` guarda os dados persistidos pelo Odoo, incluindo o filestore.
