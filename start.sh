#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_error() {
    echo -e "${RED}✗ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    log_success "Java instalado: $JAVA_VERSION"
else
    log_error "Java não encontrado! Instale Java 11+ primeiro."
    echo "  → https://adoptium.net/"
    exit 1
fi

# Clojure CLI
if command -v clj &> /dev/null; then
    CLJ_VERSION=$(clj --version 2>&1 | head -n 1)
    log_success "Clojure CLI instalado: $CLJ_VERSION"
else
    log_error "Clojure CLI não encontrado! Instale primeiro."
    echo "  → https://clojure.org/guides/install_clojure"
    exit 1
fi

# Bun
if command -v node &> /dev/null; then
    BUN_VERSION=$(bun --version)
    log_success "Node.js instalado: $BUN_VERSION"
else
    log_error "Node.js não encontrado! Instale Node.js 16+ primeiro."
    echo "  → https://nodejs.org/"
    exit 1
fi

# bun
if command -v bun &> /dev/null; then
    BUN_VERSION=$(bun --version)
    log_success "bun instalado: v$BUN_VERSION"
else
    log_error "bun não encontrado!"
    exit 1
fi

echo ""
echo "📦 Instalando dependências..."
echo "--------------------------------"

if [ -f "package.json" ]; then
    log_info "Instalando dependências do frontend (bun)..."
    bun install
    if [ $? -eq 0 ]; then
        log_success "Dependências bun instaladas"
    else
        log_error "Falha ao instalar dependências bun"
        exit 1
    fi
else
    log_warning "package.json não encontrado"
fi

if [ -f "deps.edn" ]; then
    log_info "Baixando dependências Clojure..."
    clj -P
    if [ $? -eq 0 ]; then
        log_success "Dependências Clojure baixadas"
    else
        log_error "Falha ao baixar dependências Clojure"
        exit 1
    fi
else
    log_warning "deps.edn não encontrado"
fi

echo ""
echo "Como iniciar o projeto:"
echo "--------------------------------"
echo ""
echo "  ${GREEN}Terminal 1 - Backend:${NC}"
echo "    clj -M:run"
echo ""
echo "  ${BLUE}Terminal 2 - Frontend:${NC}"
echo "    bunx --bun shadow-cljs watch app"
echo ""
echo "  ${YELLOW}Acesso:${NC}"
echo "    Backend API: http://localhost:3000/api/todos"
echo "    Frontend:    http://localhost:8020"
echo ""

read -p "Deseja iniciar o projeto agora? (s/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Ss]$ ]]; then
    log_info "Iniciando backend e frontend..."
    echo ""
    
    mkdir -p logs
    
    log_info "Iniciando backend (porta 3000)..."
    nohup clj -M:run > logs/backend.log 2>&1 &
    BACKEND_PID=$!
    echo $BACKEND_PID > logs/backend.pid
    sleep 3
    
    if ps -p $BACKEND_PID > /dev/null; then
        log_success "Backend iniciado (PID: $BACKEND_PID)"
        echo "  Log: logs/backend.log"
    else
        log_error "Falha ao iniciar backend"
        cat logs/backend.log
        exit 1
    fi
    
    log_info "Iniciando frontend (porta 8020)..."
    nohup bunx --bun shadow-cljs watch app > logs/frontend.log 2>&1 &
    FRONTEND_PID=$!
    echo $FRONTEND_PID > logs/frontend.pid
    sleep 5
    
    if ps -p $FRONTEND_PID > /dev/null; then
        log_success "Frontend iniciado (PID: $FRONTEND_PID)"
        echo "  Log: logs/frontend.log"
    else
        log_error "Falha ao iniciar frontend"
        cat logs/frontend.log
        exit 1
    fi
    
    echo ""
    log_success "Projeto iniciado com sucesso!"
    echo ""
    echo "URLs de acesso:"
    echo "  Frontend:    http://localhost:8020"
    echo "  Backend API: http://localhost:3000/api/todos"
    echo ""
    echo "Comandos úteis:"
    echo "  Ver logs backend:  tail -f logs/backend.log"
    echo "  Ver logs frontend: tail -f logs/frontend.log"
    echo "  Parar tudo:        ./stop.sh"
    echo ""
    echo "Abrindo navegador..."
    sleep 3
    
    if command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:8020
    elif command -v open &> /dev/null; then
        open http://localhost:8020
    elif command -v start &> /dev/null; then
        start http://localhost:8020
    else
        log_warning "Não foi possível abrir o navegador automaticamente"
        echo "  Abra manualmente: http://localhost:8020"
    fi
    
else
    log_info "Setup concluído! Use os comandos acima para iniciar manualmente."
fi

echo ""
log_success "Pronto! Bom desenvolvimento! 🚀"
echo ""
