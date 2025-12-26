@echo off
chcp 65001 >nul 2>&1
title n8n - Baslatiliyor
cls

REM ============================================
REM n8n Self-Hosted Installer - Start Script
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

REM Docker Desktop kontrol
echo %ESC%[96m[INFO]%ESC%[0m Docker servisi kontrol ediliyor...
docker info >nul 2>&1
if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m Docker Desktop calisimiyor!
    echo %ESC%[93m[UYARI]%ESC%[0m Lutfen Docker Desktop'i baslatin ve tekrar deneyin.
    echo.
    pause
    exit /b 1
)
echo %ESC%[92m[OK]%ESC%[0m Docker servisi aktif.

REM n8n'i baslat
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n baslatiliyor...
echo.

cd /d "%~dp0"
docker compose -f docker/docker-compose.yml up -d

if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m n8n baslatilamadi!
    echo %ESC%[93m[UYARI]%ESC%[0m Lutfen hata mesajlarini kontrol edin.
    echo.
    pause
    exit /b 1
)

REM Container kontrolu
echo.
echo %ESC%[96m[INFO]%ESC%[0m Container'lar kontrol ediliyor...
timeout /t 3 /nobreak >nul

docker ps --filter "name=n8n" --format "{{.Names}}: {{.Status}}" | findstr "n8n" >nul
if errorlevel 1 (
    echo %ESC%[91m[HATA]%ESC%[0m n8n container'i calisimiyor!
    pause
    exit /b 1
)

REM Basari mesaji
echo.
echo %ESC%[92m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[92m    ║%ESC%[0m%ESC%[97m                    n8n BASARIYLA BASLATILDI!                 %ESC%[0m%ESC%[92m║%ESC%[0m
echo %ESC%[92m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[96m[INFO]%ESC%[0m Erisim adresi: %ESC%[93mhttp://localhost:5678%ESC%[0m
echo.

REM Tarayiciyi ac
echo %ESC%[96m[INFO]%ESC%[0m Tarayiciniz aciliyor...
timeout /t 2 /nobreak >nul
start http://localhost:5678

echo.
echo %ESC%[92m[OK]%ESC%[0m n8n baslatildi! Tarayiciniz aciliyor...
echo.
pause
