@echo off
REM AWTRIX Icon Uploader Script for Windows
REM Autore: Marco Dodaro
REM GitHub: https://github.com/Raythekool/ha-awtrix-overview-app

SETLOCAL EnableDelayedExpansion

REM ========== CONFIGURAZIONE ==========
SET AWTRIX_IP=192.168.1.100
SET ICONS_FOLDER=icons
REM ====================================

color 0B
cls

echo ==========================================================
echo   AWTRIX Icon Uploader
echo   Caricamento automatico icone
echo ==========================================================
echo.

REM Verifica se curl è disponibile
curl --version >nul 2>&1
if errorlevel 1 (
    echo [31m ERRORE: curl non trovato![0m
    echo curl e' richiesto per questo script.
    echo Scaricalo da: https://curl.se/windows/
    echo.
    pause
    exit /b 1
)

REM Verifica connessione AWTRIX
echo Verifica connessione ad AWTRIX (%AWTRIX_IP%)...
curl -s --max-time 5 "http://%AWTRIX_IP%/api/stats" >nul 2>&1
if errorlevel 1 (
    echo [31m ERRORE: Impossibile connettersi ad AWTRIX[0m
    echo Verifica l'IP e che AWTRIX sia acceso
    echo.
    pause
    exit /b 1
)
echo [32mConnessione riuscita![0m
echo.

REM Verifica cartella icone
if not exist "%ICONS_FOLDER%" (
    echo [31m ERRORE: Cartella '%ICONS_FOLDER%' non trovata![0m
    echo Crea la cartella e inserisci i file .gif
    echo.
    pause
    exit /b 1
)

REM Conta icone
SET icon_count=0
for %%f in (%ICONS_FOLDER%\*.gif) do (
    SET /A icon_count+=1
)

if %icon_count%==0 (
    echo [33m ATTENZIONE: Nessuna icona .gif trovata in '%ICONS_FOLDER%'[0m
    echo Aggiungi file .gif alla cartella
    echo.
    pause
    exit /b 1
)

echo Trovate %icon_count% icone
echo.

REM Lista icone
echo Icone da caricare:
for %%f in (%ICONS_FOLDER%\*.gif) do (
    echo   * %%~nf
)
echo.

REM Chiedi conferma
SET /P confirm=Procedere con il caricamento? (S/N): 
if /I not "%confirm%"=="S" (
    if /I not "%confirm%"=="s" (
        echo.
        echo [33mCaricamento annullato[0m
        echo.
        pause
        exit /b 0
    )
)

echo.
echo Caricamento icone in corso...
echo.

REM Carica icone
SET success=0
SET failed=0
SET current=1

for %%f in (%ICONS_FOLDER%\*.gif) do (
    echo [!current!/%icon_count%] %%~nf.gif... 
    
    curl -s -X POST "http://%AWTRIX_IP%/api/icon" ^
        -F "file=@%%f" ^
        -F "name=%%~nf" ^
        -o nul ^
        -w "%%{http_code}" > temp_response.txt
    
    SET /P response=<temp_response.txt
    del temp_response.txt
    
    if "!response!"=="200" (
        echo [32m OK - Caricata![0m
        SET /A success+=1
    ) else (
        echo [31m ERRORE HTTP !response![0m
        SET /A failed+=1
    )
    
    SET /A current+=1
    echo.
)

REM Riepilogo
echo ==========================================================
echo Riepilogo:
echo   [32mCaricate: %success%[0m
if %failed% GTR 0 (
    echo   [31mFallite:  %failed%[0m
)
echo ==========================================================
echo.

if %success% GTR 0 (
    echo [32mCaricamento completato![0m
    echo.
    echo Prossimi passi:
    echo   1. Verifica le icone nell'interfaccia web di AWTRIX
    echo   2. Usa i nomi delle icone nel blueprint Home Assistant
    echo   3. Goditi il tuo AWTRIX!
    echo.
)

pause
