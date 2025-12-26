@echo off
chcp 65001 >nul 2>&1
title n8n - Durum
cls

REM ============================================
REM n8n Self-Hosted Installer - Status Script
REM Made by Eren Kekic
REM ============================================

REM Renkler icin ANSI destegi
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

REM Banner
echo.
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m              n8n Self-Hosted Installer v2.0                  %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[93m                   Made by Eren Kekic                         %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Container Durumu Basligi
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m                     CONTAINER DURUMU                         %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

cd /d "%~dp0"

REM Container durumlarini goster
echo %ESC%[96m[INFO]%ESC%[0m Container'lar kontrol ediliyor...
echo.
docker compose -f docker/docker-compose.yml ps
echo.

REM Kaynak Kullanimi Basligi
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m                    KAYNAK KULLANIMI                          %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Memory ve CPU kullanimi
echo %ESC%[96m[INFO]%ESC%[0m Kaynak kullanimi hesaplaniyor...
echo.
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" n8n n8n-postgres 2>nul
echo.

REM Erisim Durumu Basligi
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m                     ERISIM DURUMU                            %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM n8n erisilebilirlik kontrolu (PowerShell ile)
echo %ESC%[96m[INFO]%ESC%[0m n8n erisimi kontrol ediliyor...
echo.

powershell -NoProfile -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:5678' -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop; exit 0 } catch { exit 1 }" >nul 2>&1

if errorlevel 1 (
    echo %ESC%[91m    X n8n ERISILEMYOR%ESC%[0m
    echo.
    echo %ESC%[93m[UYARI]%ESC%[0m n8n'e baglanilamiyor. Container'in calistigini kontrol edin.
    echo %ESC%[93m[UYARI]%ESC%[0m Baslatmak icin: start-n8n.bat
) else (
    echo %ESC%[92m    V n8n CALISIYOR%ESC%[0m
    echo.
    echo %ESC%[92m[OK]%ESC%[0m n8n basariyla calisiyor!
    echo %ESC%[96m[INFO]%ESC%[0m Erisim adresi: %ESC%[93mhttp://localhost:5678%ESC%[0m
)

echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
