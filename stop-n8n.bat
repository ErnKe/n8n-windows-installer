@echo off
chcp 65001 >nul 2>&1
title n8n - Durduruluyor
cls

REM ============================================
REM n8n Self-Hosted Installer - Stop Script
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

REM Uyari kutusu
echo %ESC%[93m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[93m  UYARI: n8n Durdurulacak                                     %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m                                                              %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m  n8n ve PostgreSQL container'lari durdurulacak.              %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m  Verileriniz korunacak, sadece servisler duracak.            %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Kullanici onayi
echo     [%ESC%[92mE%ESC%[0m] Evet, durdur    [%ESC%[91mH%ESC%[0m] Hayir, iptal et
echo.
set /p "CONFIRM=    n8n'i durdurmak istediginizden emin misiniz? (E/H): "

REM Onay kontrolu
if /i "%CONFIRM%"=="E" goto :STOP
if /i "%CONFIRM%"=="Y" goto :STOP
if /i "%CONFIRM%"=="H" goto :CANCEL
if /i "%CONFIRM%"=="N" goto :CANCEL

REM Gecersiz giris
echo.
echo %ESC%[91m[HATA]%ESC%[0m Gecersiz secim! Islem iptal edildi.
echo.
pause
exit /b 1

:STOP
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n durduruluyor...
echo.

cd /d "%~dp0"
docker compose -f docker/docker-compose.yml stop

if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m n8n durdurulamadi!
    echo.
    pause
    exit /b 1
)

echo.
echo %ESC%[92m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[92m    ║%ESC%[0m%ESC%[97m                      n8n DURDURULDU!                          %ESC%[0m%ESC%[92m║%ESC%[0m
echo %ESC%[92m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[96m[INFO]%ESC%[0m Tekrar baslatmak icin: start-n8n.bat
echo.
pause
exit /b 0

:CANCEL
echo.
echo %ESC%[93m[INFO]%ESC%[0m Islem iptal edildi. n8n calismaya devam ediyor.
echo.
pause
exit /b 0
