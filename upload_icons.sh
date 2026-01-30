#!/bin/bash

# AWTRIX Icon Uploader Script for Linux/Mac
# Autore: Marco Dodaro
# GitHub: https://github.com/Raythekool/ha-awtrix-overview-app

# ========== CONFIGURAZIONE ==========
AWTRIX_IP="192.168.1.100"  # Cambia con l'IP del tuo AWTRIX
ICONS_FOLDER="icons"         # Cartella contenente le icone
# ====================================

# Colori per output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Header
echo -e "${BOLD}${BLUE}"
echo "=========================================================="
echo "  AWTRIX Icon Uploader"
echo "  Caricamento automatico icone"
echo "=========================================================="
echo -e "${NC}"

# Verifica se curl è installato
if ! command -v curl &> /dev/null; then
    echo -e "${RED}❌ curl non è installato!${NC}"
    echo -e "${YELLOW}   Installa curl con: sudo apt install curl${NC}"
    exit 1
fi

# Verifica connessione AWTRIX
echo -e "${BOLD}Verifica connessione ad AWTRIX ($AWTRIX_IP)...${NC}"
if curl -s --max-time 5 "http://$AWTRIX_IP/api/stats" > /dev/null; then
    echo -e "${GREEN}✅ Connessione riuscita!${NC}\n"
else
    echo -e "${RED}❌ Impossibile connettersi ad AWTRIX ($AWTRIX_IP)${NC}"
    echo -e "${YELLOW}   Verifica l'IP e che AWTRIX sia acceso${NC}\n"
    exit 1
fi

# Verifica esistenza cartella
if [ ! -d "$ICONS_FOLDER" ]; then
    echo -e "${RED}❌ Cartella '$ICONS_FOLDER' non trovata!${NC}"
    echo -e "${YELLOW}   Crea la cartella: mkdir $ICONS_FOLDER${NC}\n"
    exit 1
fi

# Conta icone
icon_count=$(find "$ICONS_FOLDER" -name "*.gif" -type f | wc -l)

if [ "$icon_count" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Nessuna icona .gif trovata in '$ICONS_FOLDER'${NC}"
    echo -e "${YELLOW}   Aggiungi file .gif alla cartella${NC}\n"
    exit 1
fi

echo -e "${BOLD}Trovate $icon_count icone${NC}\n"

# Lista icone
echo -e "${BOLD}Icone da caricare:${NC}"
for icon in "$ICONS_FOLDER"/*.gif; do
    if [ -f "$icon" ]; then
        filename=$(basename "$icon")
        iconname="${filename%.gif}"
        filesize=$(stat -f%z "$icon" 2>/dev/null || stat -c%s "$icon" 2>/dev/null)
        echo "  • $iconname ($filesize bytes)"
    fi
done

echo ""

# Chiedi conferma
read -p "Procedere con il caricamento? (s/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
    echo -e "${YELLOW}⚠️  Caricamento annullato${NC}\n"
    exit 0
fi

echo ""
echo -e "${BOLD}📤 Caricamento icone in corso...${NC}\n"

# Contatori
success=0
failed=0
current=1

# Carica icone
for icon in "$ICONS_FOLDER"/*.gif; do
    if [ -f "$icon" ]; then
        filename=$(basename "$icon")
        iconname="${filename%.gif}"
        
        echo -ne "[$current/$icon_count] $iconname.gif... "
        
        response=$(curl -s -w "%{http_code}" -X POST "http://$AWTRIX_IP/api/icon" \
            -F "file=@$icon" \
            -F "name=$iconname" \
            -o /dev/null)
        
        if [ "$response" -eq 200 ]; then
            echo -e "${GREEN}✅ Caricata${NC}"
            ((success++))
        else
            echo -e "${RED}❌ Errore HTTP $response${NC}"
            ((failed++))
        fi
        
        ((current++))
    fi
done

# Riepilogo
echo ""
echo -e "${BOLD}==========================================================${NC}"
echo -e "${BOLD}Riepilogo:${NC}"
echo -e "  ${GREEN}✅ Caricate: $success${NC}"
if [ "$failed" -gt 0 ]; then
    echo -e "  ${RED}❌ Fallite:  $failed${NC}"
fi
echo -e "${BOLD}==========================================================${NC}"
echo ""

if [ "$success" -gt 0 ]; then
    echo -e "${GREEN}✨ Caricamento completato!${NC}\n"
    echo -e "${BOLD}Prossimi passi:${NC}"
    echo "  1. Verifica le icone nell'interfaccia web di AWTRIX"
    echo "  2. Usa i nomi delle icone nel blueprint Home Assistant"
    echo "  3. Goditi il tuo AWTRIX! 🎉"
    echo ""
fi
