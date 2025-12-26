@echo off
chcp 65001 >nul 2>&1
title n8n - Loglar
cls

REM ============================================
REM n8n Self-Hosted Installer - Logs Script
REM Made by Eren Kekic
REM ============================================

REM Renkler icin ANSI destegi
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

cd /d "%~dp0"

:MENU
cls

REM Banner
echo.
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m              n8n Self-Hosted Installer v2.0                  %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[93m                   Made by Eren Kekic                         %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Menu basligi
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m                     LOG GORUNTULEME                          %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Menu secenekleri
echo     %ESC%[93m[1]%ESC%[0m Son 50 satir (n8n)
echo     %ESC%[93m[2]%ESC%[0m Son 100 satir (n8n)
echo     %ESC%[93m[3]%ESC%[0m Son 50 satir (PostgreSQL)
echo     %ESC%[93m[4]%ESC%[0m Canli log takibi (n8n) - Ctrl+C ile cik
echo     %ESC%[93m[5]%ESC%[0m Canli log takibi (tumu) - Ctrl+C ile cik
echo     %ESC%[93m[6]%ESC%[0m Hata loglari (n8n)
echo     %ESC%[91m[0]%ESC%[0m Cikis
echo.
echo ══════════════════════════════════════════════════════════════════
echo.

set /p "CHOICE=    Seciminiz (0-6): "

REM Secim kontrolu
if "%CHOICE%"=="1" goto :LOG_50
if "%CHOICE%"=="2" goto :LOG_100
if "%CHOICE%"=="3" goto :LOG_POSTGRES
if "%CHOICE%"=="4" goto :LOG_FOLLOW_N8N
if "%CHOICE%"=="5" goto :LOG_FOLLOW_ALL
if "%CHOICE%"=="6" goto :LOG_ERRORS
if "%CHOICE%"=="0" goto :EXIT

REM Gecersiz giris
echo.
echo %ESC%[91m[HATA]%ESC%[0m Gecersiz secim! Lutfen 0-6 arasinda bir sayi girin.
echo.
pause
goto :MENU

:LOG_50
cls
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n - Son 50 satir gosteriliyor...
echo ══════════════════════════════════════════════════════════════════
echo.
docker compose -f docker/docker-compose.yml logs --tail 50 n8n
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
goto :MENU

:LOG_100
cls
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n - Son 100 satir gosteriliyor...
echo ══════════════════════════════════════════════════════════════════
echo.
docker compose -f docker/docker-compose.yml logs --tail 100 n8n
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
goto :MENU

:LOG_POSTGRES
cls
echo.
echo %ESC%[96m[INFO]%ESC%[0m PostgreSQL - Son 50 satir gosteriliyor...
echo ══════════════════════════════════════════════════════════════════
echo.
docker compose -f docker/docker-compose.yml logs --tail 50 n8n-postgres
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
goto :MENU

:LOG_FOLLOW_N8N
cls
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n - Canli log takibi baslatiliyor...
echo %ESC%[93m[UYARI]%ESC%[0m Cikmak icin Ctrl+C tuslarina basin.
echo ══════════════════════════════════════════════════════════════════
echo.
docker compose -f docker/docker-compose.yml logs -f n8n
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
goto :MENU

:LOG_FOLLOW_ALL
cls
echo.
echo %ESC%[96m[INFO]%ESC%[0m Tum container'lar - Canli log takibi baslatiliyor...
echo %ESC%[93m[UYARI]%ESC%[0m Cikmak icin Ctrl+C tuslarina basin.
echo ══════════════════════════════════════════════════════════════════
echo.
docker compose -f docker/docker-compose.yml logs -f
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
goto :MENU

:LOG_ERRORS
cls
echo.
echo %ESC%[96m[INFO]%ESC%[0m n8n - Hata loglari filtreleniyor (error/warn)...
echo ══════════════════════════════════════════════════════════════════
echo.
docker compose -f docker/docker-compose.yml logs n8n 2>&1 | findstr /i "error warn"
echo.
echo ══════════════════════════════════════════════════════════════════
echo %ESC%[96m[INFO]%ESC%[0m Hata bulunamadiysa yukaridaki alan bos olabilir.
echo.
pause
goto :MENU

:EXIT
cls
echo.
echo %ESC%[92m[OK]%ESC%[0m Log goruntuleyici kapatildi.
echo.
exit /b 0
