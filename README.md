# AWTRIX Overview App 🌡️💧🔋

App personalizzata per AWTRIX che visualizza temperatura, umidità e livello batteria da sensori di Home Assistant con icone e barra di progressione.

## 📋 Caratteristiche

- **Temperatura** con icona termometro
- **Umidità** con icona goccia d'acqua
- **Batteria** con barra di progresso e colore dinamico
- Rotazione automatica tra i valori
- Colori dinamici basati sui livelli
- Supporto multipli dispositivi AWTRIX

## 🎨 Icone Consigliate

Ti consiglio di caricare queste icone sul tuo AWTRIX:

- `thermometer` - Termometro per temperatura
- `water` - Goccia d'acqua per umidità  
- `battery` - Batteria

Puoi usare icone da [https://developer.lametric.com/icons](https://developer.lametric.com/icons) o crearne di personalizzate.

### Come caricare le icone

Vedi il file [ICONS_UPLOAD.md](ICONS_UPLOAD.md) per istruzioni dettagliate sul caricamento delle icone.

## 🚀 Installazione

### Metodo 1: Importa Blueprint (Consigliato)

1. Vai su Home Assistant
2. Vai in **Impostazioni** → **Automazioni e Scene** → **Blueprint**
3. Clicca su **Importa Blueprint**
4. Incolla questo URL:
   ```
   https://raw.githubusercontent.com/Raythekool/ha-awtrix-overview-app/main/awtrix_overview_app.yaml
   ```
5. Clicca su **Anteprima** e poi **Importa**

### Metodo 2: Copia Manuale

1. Scarica il file `awtrix_overview_app.yaml`
2. Copia il contenuto nel tuo file `automations.yaml` o crea una nuova automazione
3. Ricarica le automazioni

## ⚙️ Configurazione

Dopo l'importazione, crea una nuova automazione dal blueprint:

1. Vai in **Impostazioni** → **Automazioni e Scene**
2. Clicca su **Crea automazione** → **Inizia da un blueprint**
3. Seleziona **AWTRIX Overview App**
4. Configura i parametri:

### Parametri Principali

- **Dispositivo AWTRIX**: Seleziona uno o più dispositivi AWTRIX
- **Sensore Temperatura**: Il tuo sensore di temperatura (es. `sensor.temperature_living_room`)
- **Sensore Umidità**: Il tuo sensore di umidità (es. `sensor.humidity_living_room`)
- **Sensore Batteria**: Il tuo sensore di batteria (es. `sensor.phone_battery_level`)
- **Durata visualizzazione**: Quanto tempo mostrare ogni valore (default: 7 secondi)

### Personalizzazione Icone

- **Icona Temperatura**: Nome dell'icona per la temperatura (default: `thermometer`)
- **Icona Umidità**: Nome dell'icona per l'umidità (default: `water`)
- **Icona Batteria**: Nome dell'icona per la batteria (default: `battery`)

### Soglie e Colori

Puoi personalizzare le soglie per i colori:

**Temperatura:**
- Sotto 15°C: Blu freddo
- 15-25°C: Verde confortevole  
- Sopra 25°C: Arancione/Rosso caldo

**Umidità:**
- Sotto 30%: Giallo (troppo secco)
- 30-60%: Verde (ottimale)
- Sopra 60%: Blu (troppo umido)

**Batteria:**
- Sopra 60%: Verde
- 30-60%: Giallo
- Sotto 30%: Rosso + effetto lampeggiante

## 📊 Formato Display

L'app mostra i dati in rotazione:

1. **Temperatura**: `🌡️ 22.5°C` (con barra colorata in alto/basso)
2. **Umidità**: `💧 45%` (con barra colorata)
3. **Batteria**: `🔋 85%` (con barra di progresso)

Ogni schermata viene visualizzata per il tempo configurato (default 7 secondi).

## 🔄 Aggiornamenti

L'app si aggiorna automaticamente quando:
- Il valore della temperatura cambia
- Il valore dell'umidità cambia  
- Il livello della batteria cambia

## 🛠️ Troubleshooting

### L'app non si visualizza

1. Verifica che i sensori siano configurati correttamente
2. Controlla che il dispositivo AWTRIX sia online
3. Verifica i topic MQTT in Developer Tools → MQTT

### Le icone non si vedono

1. Carica le icone sul tuo AWTRIX usando gli script forniti
2. Verifica che i nomi delle icone corrispondano a quelli configurati
3. Consulta [ICONS_UPLOAD.md](ICONS_UPLOAD.md)

### I colori non cambiano

1. Verifica che i sensori restituiscano valori numerici
2. Controlla le soglie configurate nel blueprint

## 📝 Note

- L'app usa il topic MQTT `overview` per default
- Puoi avere multiple istanze cambiando il nome dell'app
- La barra di progresso funziona meglio con valori 0-100

## 🤝 Contributi

Contributi, issue e feature request sono benvenuti!

## 📄 Licenza

MIT License - vedi file [LICENSE](LICENSE)

## 🔗 Link Utili

- [AWTRIX Documentation](https://blueforcer.github.io/awtrix3/)
- [Home Assistant](https://www.home-assistant.io/)
- [LaMetric Icons](https://developer.lametric.com/icons)

## 👨‍💻 Autore

**Marco Dodaro** - [@Raythekool](https://github.com/Raythekool)

---

⭐ Se ti piace questo progetto, lascia una stella su GitHub!