# 📦 Guida Caricamento Icone AWTRIX

Questa guida ti spiega come caricare le icone personalizzate sul tuo
dispositivo AWTRIX.

## 🎨 Icone Necessarie

Per l'app **AWTRIX Overview** hai bisogno di queste icone:

- `thermometer` - Termometro per la temperatura
- `water` - Goccia d'acqua per l'umidità
- `battery` - Batteria

## 🔍 Dove Trovare le Icone

### 1. LaMetric Icons (Consigliato)

[https://developer.lametric.com/icons](https://developer.lametric.com/icons)

1. Cerca l'icona desiderata (es. "thermometer")
2. Scarica il file GIF o usa l'ID dell'icona
3. Le icone LaMetric sono già ottimizzate per display LED

### 2. Icone Personalizzate

Puoi creare le tue icone 8x8 pixel:

- Formato: GIF animato o statico
- Dimensioni: 8x8 pixel
- Colori: Ottimizzati per LED RGB

## 📤 Metodi di Caricamento

### Metodo 1: Interfaccia Web AWTRIX (Più Semplice)

1. Apri il browser e vai all'IP del tuo AWTRIX (es. `http://192.168.1.100`)
2. Vai alla sezione **Icons**
3. Clicca su **Upload Icon**
4. Seleziona il file GIF
5. Inserisci il nome (es. `thermometer`)
6. Clicca **Upload**

### Metodo 2: Script Python (Caricamento Multiplo)

Usa lo script `upload_icons.py` incluso nel repository:

```bash
python upload_icons.py
```

Lo script:

1. Cerca tutti i file `.gif` nella cartella `icons/`
2. Li carica automaticamente su AWTRIX
3. Usa il nome del file come nome dell'icona

#### Configurazione Script

Modifica le prime righe dello script:

```python
AWTRIX_IP = "192.168.1.100"  # IP del tuo AWTRIX
ICONS_FOLDER = "icons"        # Cartella con le icone
```

### Metodo 3: MQTT

Carica icone via MQTT:

```bash
mosquitto_pub -h YOUR_MQTT_BROKER \
  -t "awtrix_PREFIX/icon/thermometer" \
  -m '{"base64": "BASE64_ENCODED_GIF"}'
```

### Metodo 4: HTTP API

Usa curl o Postman:

```bash
curl -X POST "http://AWTRIX_IP/api/icon" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@thermometer.gif" \
  -F "name=thermometer"
```

## 📁 Struttura Cartelle Consigliata

```text
ha-awtrix-overview-app/
├── icons/
│   ├── thermometer.gif
│   ├── water.gif
│   └── battery.gif
├── upload_icons.py
├── upload_icons.sh
└── upload_icons.bat
```

## ✅ Verifica Caricamento

### Via Interfaccia Web

1. Vai su `http://AWTRIX_IP`
2. Sezione **Icons**
3. Dovresti vedere le tue icone nell'elenco

### Via Home Assistant

Nel blueprint, usa il nome esatto dell'icona:

```yaml
icon_temperature: "thermometer"
icon_humidity: "water"
icon_battery: "battery"
```

## 🎨 Consigli per le Icone

### Temperatura

- **ID LaMetric**: `2289` (termometro classico)
- **Alternative**: `53284` (temperatura), `120` (termometro digitale)

### Umidità

- **ID LaMetric**: `46633` (goccia d'acqua)
- **Alternative**: `2520` (nuvola con pioggia), `39633` (umidità)

### Batteria

- **ID LaMetric**: `9956` (batteria)
- **Alternative**: `47188` (batteria in carica), `2849` (batteria vuota)

## 🛠️ Script di Esempio

### upload_icons.py

```python
import os
import requests
import base64
from pathlib import Path

AWTRIX_IP = "192.168.1.100"
ICONS_FOLDER = "icons"

def upload_icon(icon_path, icon_name):
    url = f"http://{AWTRIX_IP}/api/icon"
    
    with open(icon_path, 'rb') as f:
        files = {'file': (f'{icon_name}.gif', f, 'image/gif')}
        data = {'name': icon_name}
        
        response = requests.post(url, files=files, data=data)
        
        if response.status_code == 200:
            print(f"✅ {icon_name} caricata con successo!")
        else:
            print(f"❌ Errore caricamento {icon_name}: {response.status_code}")

def main():
    icons_dir = Path(ICONS_FOLDER)
    
    if not icons_dir.exists():
        print(f"❌ Cartella {ICONS_FOLDER} non trovata!")
        return
    
    gif_files = list(icons_dir.glob('*.gif'))
    
    if not gif_files:
        print(f"❌ Nessuna icona .gif trovata in {ICONS_FOLDER}")
        return
    
    print(f"📤 Caricamento {len(gif_files)} icone su AWTRIX {AWTRIX_IP}...\n")
    
    for gif_file in gif_files:
        icon_name = gif_file.stem
        upload_icon(gif_file, icon_name)
    
    print("\n✨ Caricamento completato!")

if __name__ == "__main__":
    main()
```

### upload_icons.sh (Linux/Mac)

```bash
#!/bin/bash

AWTRIX_IP="192.168.1.100"
ICONS_FOLDER="icons"

for icon in "$ICONS_FOLDER"/*.gif; do
    if [ -f "$icon" ]; then
        filename=$(basename "$icon")
        iconname="${filename%.gif}"
        
        echo "Caricamento $iconname..."
        
        curl -X POST "http://$AWTRIX_IP/api/icon" \
            -F "file=@$icon" \
            -F "name=$iconname"
        
        echo ""
    fi
done

echo "✨ Caricamento completato!"
```

### upload_icons.bat (Windows)

```batch
@echo off
SET AWTRIX_IP=192.168.1.100
SET ICONS_FOLDER=icons

echo Caricamento icone su AWTRIX %AWTRIX_IP%...
echo.

for %%f in (%ICONS_FOLDER%\*.gif) do (
    echo Caricamento %%~nf...
    curl -X POST "http://%AWTRIX_IP%/api/icon" ^
        -F "file=@%%f" ^
        -F "name=%%~nf"
    echo.
)

echo.
echo Caricamento completato!
pause
```

## 🔧 Troubleshooting

### Le icone non si vedono sull'AWTRIX

1. Verifica che il nome sia esatto (case-sensitive)
2. Controlla che l'icona sia stata caricata nell'interfaccia web
3. Prova a ricaricare l'icona
4. Riavvia AWTRIX

### Errore di caricamento

1. Verifica l'IP di AWTRIX
2. Controlla che AWTRIX sia raggiungibile
3. Verifica che il file GIF sia valido (8x8 pixel)
4. Controlla i permessi della cartella

### L'icona appare sfocata o errata

1. Assicurati che sia esattamente 8x8 pixel
2. Usa colori ottimizzati per LED
3. Evita troppe sfumature
4. Preferisci icone con contrasto elevato

## 📚 Risorse Utili

- [AWTRIX 3 Documentation](https://blueforcer.github.io/awtrix3/)
- [LaMetric Icon Library](https://developer.lametric.com/icons)
- [AWTRIX Icon Creator](https://pixelartmaker.com/)
- [GIF Optimizer](https://ezgif.com/optimize)

---

💡 **Suggerimento**: Crea una cartella `icons/` nel repository e mantieni
lì tutte le tue icone per facilitare backup e condivisione!
