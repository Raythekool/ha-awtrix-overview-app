#!/usr/bin/env python3
"""
AWTRIX Icon Uploader
Carica automaticamente le icone dalla cartella icons/ al dispositivo AWTRIX

Autore: Marco Dodaro
GitHub: https://github.com/Raythekool/ha-awtrix-overview-app
"""

import os
import sys
import requests
from pathlib import Path
from typing import List, Tuple

# ========== CONFIGURAZIONE ==========
AWTRIX_IP = "192.168.1.100"  # Cambia con l'IP del tuo AWTRIX
ICONS_FOLDER = "icons"         # Cartella contenente le icone GIF
# ====================================

class Colors:
    """Codici colore per l'output terminale"""
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_header():
    """Stampa l'intestazione dello script"""
    print(f"{Colors.BOLD}{Colors.BLUE}")
    print("="*60)
    print("  AWTRIX Icon Uploader")
    print("  Caricamento automatico icone")
    print("="*60)
    print(f"{Colors.END}\n")

def check_awtrix_connection(ip: str) -> bool:
    """Verifica la connessione al dispositivo AWTRIX"""
    try:
        response = requests.get(f"http://{ip}/api/stats", timeout=5)
        if response.status_code == 200:
            print(f"{Colors.GREEN}✅ Connessione ad AWTRIX ({ip}) riuscita!{Colors.END}\n")
            return True
        else:
            print(f"{Colors.RED}❌ AWTRIX risponde ma con errore: {response.status_code}{Colors.END}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"{Colors.RED}❌ Impossibile connettersi ad AWTRIX ({ip}){Colors.END}")
        print(f"{Colors.RED}   Errore: {str(e)}{Colors.END}")
        return False

def get_icon_files(folder: str) -> List[Path]:
    """Ottiene la lista di file GIF dalla cartella icone"""
    icons_dir = Path(folder)
    
    if not icons_dir.exists():
        print(f"{Colors.RED}❌ Cartella '{folder}' non trovata!{Colors.END}")
        print(f"{Colors.YELLOW}   Crea la cartella e inserisci i file .gif{Colors.END}")
        return []
    
    gif_files = list(icons_dir.glob('*.gif'))
    
    if not gif_files:
        print(f"{Colors.YELLOW}⚠️  Nessuna icona .gif trovata in '{folder}'{Colors.END}")
        print(f"{Colors.YELLOW}   Aggiungi file .gif alla cartella{Colors.END}")
        return []
    
    return sorted(gif_files)

def upload_icon(ip: str, icon_path: Path) -> Tuple[bool, str]:
    """Carica una singola icona su AWTRIX"""
    icon_name = icon_path.stem
    url = f"http://{ip}/api/icon"
    
    try:
        with open(icon_path, 'rb') as f:
            files = {'file': (f'{icon_name}.gif', f, 'image/gif')}
            data = {'name': icon_name}
            
            response = requests.post(url, files=files, data=data, timeout=10)
            
            if response.status_code == 200:
                return True, "Caricata con successo"
            else:
                return False, f"Errore HTTP {response.status_code}"
                
    except FileNotFoundError:
        return False, "File non trovato"
    except requests.exceptions.Timeout:
        return False, "Timeout connessione"
    except requests.exceptions.RequestException as e:
        return False, f"Errore: {str(e)}"
    except Exception as e:
        return False, f"Errore imprevisto: {str(e)}"

def upload_all_icons(ip: str, icon_files: List[Path]):
    """Carica tutte le icone trovate"""
    total = len(icon_files)
    success_count = 0
    failed_count = 0
    
    print(f"{Colors.BOLD}📤 Caricamento {total} icone su AWTRIX {ip}...{Colors.END}\n")
    
    for idx, icon_file in enumerate(icon_files, 1):
        icon_name = icon_file.stem
        file_size = icon_file.stat().st_size
        
        print(f"[{idx}/{total}] {icon_name}.gif ({file_size} bytes)... ", end="", flush=True)
        
        success, message = upload_icon(ip, icon_file)
        
        if success:
            print(f"{Colors.GREEN}✅ {message}{Colors.END}")
            success_count += 1
        else:
            print(f"{Colors.RED}❌ {message}{Colors.END}")
            failed_count += 1
    
    print(f"\n{Colors.BOLD}{'='*60}{Colors.END}")
    print(f"{Colors.BOLD}Riepilogo:{Colors.END}")
    print(f"  {Colors.GREEN}✅ Caricate: {success_count}{Colors.END}")
    if failed_count > 0:
        print(f"  {Colors.RED}❌ Fallite:  {failed_count}{Colors.END}")
    print(f"{Colors.BOLD}{'='*60}{Colors.END}\n")

def print_usage():
    """Stampa le istruzioni d'uso"""
    print(f"{Colors.BOLD}Uso:{Colors.END}")
    print(f"  1. Modifica AWTRIX_IP nello script con l'IP del tuo dispositivo")
    print(f"  2. Crea la cartella '{ICONS_FOLDER}' se non esiste")
    print(f"  3. Inserisci i file .gif nella cartella '{ICONS_FOLDER}'")
    print(f"  4. Esegui: python upload_icons.py\n")

def main():
    """Funzione principale"""
    print_header()
    
    # Verifica connessione AWTRIX
    if not check_awtrix_connection(AWTRIX_IP):
        print_usage()
        sys.exit(1)
    
    # Ottieni lista icone
    icon_files = get_icon_files(ICONS_FOLDER)
    
    if not icon_files:
        print_usage()
        sys.exit(1)
    
    # Mostra icone trovate
    print(f"{Colors.BOLD}Icone trovate:{Colors.END}")
    for icon_file in icon_files:
        print(f"  • {icon_file.stem}")
    print()
    
    # Chiedi conferma
    try:
        response = input(f"{Colors.BOLD}Procedere con il caricamento? (s/n): {Colors.END}")
        if response.lower() not in ['s', 'si', 'y', 'yes']:
            print(f"\n{Colors.YELLOW}⚠️  Caricamento annullato{Colors.END}")
            sys.exit(0)
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}⚠️  Caricamento annullato{Colors.END}")
        sys.exit(0)
    
    print()  # Riga vuota
    
    # Carica icone
    upload_all_icons(AWTRIX_IP, icon_files)
    
    print(f"{Colors.GREEN}✨ Caricamento completato!{Colors.END}\n")
    print(f"{Colors.BOLD}Prossimi passi:{Colors.END}")
    print(f"  1. Verifica le icone nell'interfaccia web di AWTRIX")
    print(f"  2. Usa i nomi delle icone nel blueprint Home Assistant")
    print(f"  3. Goditi il tuo AWTRIX! 🎉\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}⚠️  Operazione interrotta dall'utente{Colors.END}\n")
        sys.exit(0)
    except Exception as e:
        print(f"\n{Colors.RED}❌ Errore critico: {str(e)}{Colors.END}\n")
        sys.exit(1)
