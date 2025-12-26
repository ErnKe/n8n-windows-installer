@echo off
chcp 65001 >nul 2>&1
title n8n - Yedekleme
cls

REM ============================================
REM n8n Self-Hosted Installer - Backup Script
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

REM Yedekleme basligi
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m                   VERITABANI YEDEKLEME                        %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.

REM Container kontrolu
echo %ESC%[96m[INFO]%ESC%[0m PostgreSQL container kontrol ediliyor...
docker ps --filter "name=n8n-postgres" --format "{{.Names}}" | findstr "n8n-postgres" >nul 2>&1
if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m PostgreSQL container'i calisimiyor!
    echo %ESC%[93m[UYARI]%ESC%[0m Lutfen once n8n'i baslatin: start-n8n.bat
    echo.
    pause
    exit /b 1
)
echo %ESC%[92m[OK]%ESC%[0m PostgreSQL container'i calisiyor.
echo.

REM Backups klasoru olustur
if not exist backups (
    echo %ESC%[96m[INFO]%ESC%[0m backups klasoru olusturuluyor...
    mkdir backups
    echo %ESC%[92m[OK]%ESC%[0m backups klasoru olusturuldu.
    echo.
)

REM Tarih ve saat damgasi olustur (YYYYMMDD_HHMMSS)
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,4%%dt:~4,2%%dt:~6,2%_%dt:~8,2%%dt:~10,2%%dt:~12,2%"
set "BACKUP_FILE=backups\backup_%TIMESTAMP%.sql"

REM Yedekleme islemi
echo %ESC%[96m[INFO]%ESC%[0m Veritabani yedekleniyor...
echo %ESC%[96m[INFO]%ESC%[0m Dosya: %BACKUP_FILE%
echo.

docker exec n8n-postgres pg_dump -U n8n n8n > "%BACKUP_FILE%" 2>&1

if errorlevel 1 (
    echo.
    echo %ESC%[91m[HATA]%ESC%[0m Yedekleme basarisiz!
    echo %ESC%[93m[UYARI]%ESC%[0m Lutfen container'in duzgun calistigindan emin olun.
    echo.
    if exist "%BACKUP_FILE%" del "%BACKUP_FILE%"
    pause
    exit /b 1
)

REM Dosya boyutunu kontrol et
for %%A in ("%BACKUP_FILE%") do set "FILESIZE=%%~zA"

REM Dosya bos mu kontrol et
if "%FILESIZE%"=="0" (
    echo %ESC%[91m[HATA]%ESC%[0m Yedek dosyasi bos! Yedekleme basarisiz.
    del "%BACKUP_FILE%"
    echo.
    pause
    exit /b 1
)

REM Dosya boyutunu formatla (KB/MB)
set /a "FILESIZEKB=%FILESIZE% / 1024"
if %FILESIZEKB% GTR 1024 (
    set /a "FILESIZEMB=%FILESIZEKB% / 1024"
    set "SIZESTR=%FILESIZEMB% MB"
) else (
    set "SIZESTR=%FILESIZEKB% KB"
)

REM Basari mesaji
echo.
echo %ESC%[92m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[92m    ║%ESC%[0m%ESC%[97m                YEDEK BASARIYLA ALINDI!                       %ESC%[0m%ESC%[92m║%ESC%[0m
echo %ESC%[92m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo %ESC%[92m[OK]%ESC%[0m Yedek dosyasi: %BACKUP_FILE%
echo %ESC%[92m[OK]%ESC%[0m Dosya boyutu: %SIZESTR%
echo.

REM Mevcut yedekleri listele
echo %ESC%[96m    ╔══════════════════════════════════════════════════════════════╗%ESC%[0m
echo %ESC%[96m    ║%ESC%[0m%ESC%[97m                    MEVCUT YEDEKLER                            %ESC%[0m%ESC%[96m║%ESC%[0m
echo %ESC%[96m    ╚══════════════════════════════════════════════════════════════╝%ESC%[0m
echo.
dir backups\*.sql /O-D 2>nul
echo.
echo ══════════════════════════════════════════════════════════════════
echo.
pause
exit /b 0
