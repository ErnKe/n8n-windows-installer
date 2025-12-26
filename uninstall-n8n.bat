@echo off
chcp 65001 >nul 2>&1
title n8n - Kaldirma
cls

REM ============================================
REM n8n Self-Hosted Installer - Uninstall Script
REM Made by Eren Kekic
REM ============================================

REM Renkler icin ANSI destegi
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

cd /d "%~dp0"

REM Banner
echo.
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m              n8n Self-Hosted Installer v2.0                  %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[93m                   Made by Eren Kekic                         %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Kirmizi uyari kutusu
echo %ESC%[91m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[91m  DIKKAT: n8n Kaldirilacak!                                    %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m                                                              %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m  Bu islem GERI ALINAMAZ!                                     %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Menu secenekleri
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m                    KALDIRMA SECENEKLERI                       %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo     %ESC%[93m[1]%ESC%[0m Sadece container'lari kaldir %ESC%[92m(veriler KORUNUR)%ESC%[0m
echo     %ESC%[93m[2]%ESC%[0m Container + Volume'lari kaldir %ESC%[91m(veriler SILINIR!)%ESC%[0m
echo     %ESC%[91m[3]%ESC%[0m Iptal
echo.
echo ══════════════════════════════════════════════════════════════════
echo.

set /p "CHOICE=    Seciminiz (1-3): "

REM Secim kontrolu
if "%CHOICE%"=="1" goto :REMOVE_CONTAINERS
if "%CHOICE%"=="2" goto :REMOVE_ALL
if "%CHOICE%"=="3" goto :CANCEL

REM Gecersiz giris
echo.
echo %ESC%[91m[HATA]%ESC%[0m Gecersiz secim! Lutfen 1-3 arasinda bir sayi girin.
echo.
pause
exit /b 1

:REMOVE_CONTAINERS
echo.
echo %ESC%[96m[INFO]%ESC%[0m Container'lar kaldiriliyor...
echo.

docker compose -f docker/docker-compose.yml down

if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m Container'lar kaldirilamadi!
    echo.
    pause
    exit /b 1
)

REM Basari mesaji
echo.
echo %ESC%[92m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[92m    ║%ESC%[0m%ESC%[97m             CONTAINER'LAR BASARIYLA KALDIRILDI!               %ESC%[0m%ESC%[92m║%ESC%[0m
echo %ESC%[92m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[92m[OK]%ESC%[0m Container'lar kaldirildi.
echo %ESC%[92m[OK]%ESC%[0m Verileriniz korunuyor (Docker volume'lari silinmedi).
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n'i tekrar kurmak icin: start-n8n.bat
echo.
pause
exit /b 0

:REMOVE_ALL
echo.
echo %ESC%[91m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[91m  SON UYARI: TUM VERILER SILINECEK!                             %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m                                                              %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m  Bu islem:                                                   %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m  - Tum workflow'larinizi silecek                             %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m  - Tum kimlik bilgilerinizi silecek                          %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m  - PostgreSQL veritabanini silecek                           %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ║%ESC%[0m%ESC%[97m  - GERI ALINAMAZ!                                            %ESC%[0m%ESC%[91m║%ESC%[0m
echo %ESC%[91m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo     Onaylamak icin %ESC%[91mKALDIR%ESC%[0m yazin:
echo.
set /p "CONFIRM=    "

if /i "%CONFIRM%"=="KALDIR" goto :DO_REMOVE_ALL

REM Onay verilmedi
echo.
echo %ESC%[93m[INFO]%ESC%[0m Islem iptal edildi. Verileriniz korunuyor.
echo.
pause
exit /b 0

:DO_REMOVE_ALL
echo.
echo %ESC%[96m[INFO]%ESC%[0m Container'lar ve volume'lar kaldiriliyor...
echo.

docker compose -f docker/docker-compose.yml down -v

if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m Kaldirma islemi basarisiz!
    echo.
    pause
    exit /b 1
)

REM Basari mesaji
echo.
echo %ESC%[92m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[92m    ║%ESC%[0m%ESC%[97m                n8n TAMAMEN KALDIRILDI!                        %ESC%[0m%ESC%[92m║%ESC%[0m
echo %ESC%[92m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[92m[OK]%ESC%[0m Container'lar kaldirildi.
echo %ESC%[92m[OK]%ESC%[0m Docker volume'lari silindi.
echo %ESC%[92m[OK]%ESC%[0m Tum veriler temizlendi.
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n'i tekrar kurmak icin: install.bat
echo.
pause
exit /b 0

:CANCEL
echo.
echo %ESC%[93m[INFO]%ESC%[0m Islem iptal edildi. n8n calismaya devam ediyor.
echo.
pause
exit /b 0
