# Tutorial Clojure/ClojureScript - Todo List Full-Stack

## Sobre o Projeto

Este é um projeto do tutorial "Tutorial Clojure/ClojureScript: Construindo uma Aplicação Persistente e Reativa".

Uma aplicação Todo List completa construída com:
- **Backend**: Clojure, Ring, Reitit, next.jdbc
- **Frontend**: ClojureScript, Reagent 2.0 (React 18), Shadow-CLJS
- **Banco de Dados**: SQLite para persistência

## 🔗 Link do Tutorial Original

[Tutorial Completo no Notion](https://profsergiocosta.notion.site/Tutorial-Clojure-ClojureScript-Construindo-uma-Aplica-o-Persistente-e-Reativa-2a5cce975093807aa9f0f0cb0cf69645)

## 🛠️ Tecnologias Utilizadas

- **Clojure 1.11+** - Linguagem funcional para o backend
- **ClojureScript** - Clojure compilado para JavaScript
- **Ring** - Abstração HTTP para Clojure
- **Reitit** - Roteamento moderno
- **next.jdbc** - Acesso a banco de dados
- **SQLite** - Banco de dados leve e portátil
- **Reagent 2.0** - Interface reativa com React 18
- **Shadow-CLJS** - Build tool para ClojureScript

## 📋 Pré-requisitos

Antes de começar, você precisa ter instalado:

- **Java JDK 11+** ([Download](https://adoptium.net/))
- **Clojure CLI tools** ([Instruções](https://clojure.org/guides/install_clojure))
- **Bun** ([Download](https://bun.com/))

### Verificando as instalações:

```bash
java -version    # deve mostrar Java 11 ou superior
clj --version    # deve mostrar Clojure CLI
bun --version   # deve mostrar Node 16 ou superior
```

## 🚀 Como Rodar o Projeto

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd todo-clojure-tutorial
```

### 2. Instale as dependências do frontend

```bash
bun install
```

### 3. Inicie o Backend (Terminal 1)

```bash
clj -M:run
```

O backend estará rodando em: http://localhost:3000

### 4. Inicie o Frontend (Terminal 2)

```bash
bunx --bun shadow-cljs watch app
```

O frontend estará disponível em: http://localhost:8020

## 📝 Estrutura do Projeto

```
todo-list/
├── src/
│   ├── backend/
│   │   ├── core.clj         # Servidor e rotas
│   │   └── db.clj           # Camada de banco de dados
│   └── frontend/
│       └── app.cljs         # Interface React/Reagent
├── resources/
│   └── public/
│       └── index.html       # HTML base
├── deps.edn                 # Dependências Clojure
├── shadow-cljs.edn         # Configuração Shadow-CLJS
├── package.json            # Dependências bun
└── README.md
```

## ✨ Funcionalidades

- ✅ Adicionar novas tarefas
- ✅ Listar todas as tarefas
- ✅ Marcar tarefas como concluídas
- ✅ Remover tarefas
- ✅ Persistência em SQLite
- ✅ Interface reativa em tempo real

## 🐛 Problemas Comuns

### Backend não inicia
- Verifique se a porta 3000 está livre
- Confirme que o Java está instalado corretamente

### Frontend não compila
- Execute `bun install` novamente
- Limpe o cache: `bunx --bun shadow-cljs clean`

### Dados não persistem
- Verifique se o arquivo `todos.db` foi criado na raiz do projeto
- Confirme que o backend tem permissão de escrita

## Aprendizados Principais

Este tutorial ensina:
- Arquitetura full-stack funcional
- Comunicação via API REST
- Gerenciamento de estado reativo
- Persistência de dados com SQL
- Resolução de problemas comuns (CORS, formatos de dados)