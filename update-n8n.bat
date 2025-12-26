@echo off
chcp 65001 >nul 2>&1
title n8n - Guncelleme
cls

REM ============================================
REM n8n Self-Hosted Installer - Update Script
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
echo %ESC%[93m    ║%ESC%[0m%ESC%[93m  UYARI: n8n Guncellenecek                                     %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m                                                              %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m  Bu islem:                                                   %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m  - Mevcut container'lari durduracak                          %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m  - Yeni n8n image'ini indirecek                              %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[97m  - Container'lari yeniden baslatacak                         %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ║%ESC%[0m%ESC%[92m  - Verileriniz korunacaktir                                  %ESC%[0m%ESC%[93m║%ESC%[0m
echo %ESC%[93m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Kullanici onayi
echo     [%ESC%[92mE%ESC%[0m] Evet, guncelle    [%ESC%[91mH%ESC%[0m] Hayir, iptal et
echo.
set /p "CONFIRM=    n8n'i guncellemek istediginizden emin misiniz? (E/H): "

REM Onay kontrolu
if /i "%CONFIRM%"=="E" goto :UPDATE
if /i "%CONFIRM%"=="Y" goto :UPDATE
if /i "%CONFIRM%"=="H" goto :CANCEL
if /i "%CONFIRM%"=="N" goto :CANCEL

REM Gecersiz giris
echo.
echo %ESC%[91m[HATA]%ESC%[0m Gecersiz secim! Islem iptal edildi.
echo.
pause
exit /b 1

:UPDATE
echo.
echo %ESC%[96m[INFO]%ESC%[0m Yeni image'lar indiriliyor...
echo.

cd /d "%~dp0"
docker compose -f docker/docker-compose.yml pull

if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m Image indirme basarisiz!
    echo.
    pause
    exit /b 1
)

echo.
echo %ESC%[96m[INFO]%ESC%[0m Container'lar yeniden baslatiliyor...
echo.

docker compose -f docker/docker-compose.yml up -d

if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m Container'lar baslatilamadi!
    echo.
    pause
    exit /b 1
)

REM Basari mesaji
echo.
echo %ESC%[92m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[92m    ║%ESC%[0m%ESC%[97m               n8n BASARIYLA GUNCELLENDI!                     %ESC%[0m%ESC%[92m║%ESC%[0m
echo %ESC%[92m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[96m[INFO]%ESC%[0m Erisim adresi: %ESC%[93mhttp://localhost:5678%ESC%[0m
echo.
pause
exit /b 0

:CANCEL
echo.
echo %ESC%[93m[INFO]%ESC%[0m Guncelleme iptal edildi. n8n mevcut surumuyle calismaya devam ediyor.
echo.
pause
exit /b 0
