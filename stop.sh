#!/bin/bash

echo "Parando Todo List Clojure..."
echo "================================"
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -f "logs/backend.pid" ]; then
    BACKEND_PID=$(cat logs/backend.pid)
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        kill $BACKEND_PID
        echo -e "${GREEN}✓${NC} Backend parado (PID: $BACKEND_PID)"
    else
        echo -e "${YELLOW}⚠️${NC}  Backend já estava parado"
    fi
    rm logs/backend.pid
else
    echo -e "${YELLOW}⚠️${NC}  PID do backend não encontrado"
fi

if [ -f "logs/frontend.pid" ]; then
    FRONTEND_PID=$(cat logs/frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✓${NC} Frontend parado (PID: $FRONTEND_PID)"
    else
        echo -e "${YELLOW}⚠️${NC}  Frontend já estava parado"
    fi
    rm logs/frontend.pid
else
    echo -e "${YELLOW}⚠️${NC}  PID do frontend não encontrado"
fi

echo ""
echo "🔍 Verificando portas 3000 e 8020..."

# Porta 3000 (backend)
if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️${NC}  Processo ainda na porta 3000, tentando matar..."
    lsof -ti:3000 | xargs kill -9 2>/dev/null
    echo -e "${GREEN}✓${NC} Porta 3000 liberada"
fi

# Porta 8020 (frontend)
if lsof -Pi :8020 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️${NC}  Processo ainda na porta 8020, tentando matar..."
    lsof -ti:8020 | xargs kill -9 2>/dev/null
    echo -e "${GREEN}✓${NC} Porta 8020 liberada"
fi

echo ""
echo -e "${GREEN}✓${NC} Processos parados com sucesso!"
echo ""
echo "💡 Para reiniciar, execute: ./start.sh"
echo ""
