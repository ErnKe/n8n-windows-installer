@echo off
:: ============================================
:: n8n Self-Hosted Kurulum Baslatici
:: ============================================
:: Bu dosya setup.ps1 scriptini calistirir
:: Cift tiklayin ve kurulumu baslatin!
:: ============================================

:: Karakter kodlamasi (UTF-8)
chcp 65001 >nul

:: Baslik goster
echo.
echo ============================================
echo    n8n Self-Hosted Kurulum Baslatiliyor
echo ============================================
echo.

:: Administrator yetkisi kontrolu
NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Administrator yetkisi gerekiyor...
    echo [!] UAC prompt aciliyor...
    echo.
    :: Admin olarak yeniden baslat
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo [OK] Administrator yetkisi mevcut
echo.

:: Script dizinine git
cd /d "%~dp0"

:: PowerShell scriptinin varligini kontrol et
if not exist "scripts\setup.ps1" (
    echo [HATA] scripts\setup.ps1 dosyasi bulunamadi!
    echo [HATA] Lutfen dosyanin varligindan emin olun.
    echo.
    echo Kapatmak icin bir tusa basin...
    pause >nul
    exit /b 1
)

echo [OK] setup.ps1 bulundu
echo [*] PowerShell scripti baslatiliyor...
echo.

:: PowerShell script'ini calistir (Execution Policy Bypass ile)
powershell -ExecutionPolicy Bypass -NoProfile -File "scripts\setup.ps1"

:: PowerShell script'inin cikis kodunu al
set SCRIPT_EXIT_CODE=%errorlevel%

:: Sonucu goster
echo.
echo ============================================
if %SCRIPT_EXIT_CODE% equ 0 (
    echo    Kurulum tamamlandi!
) else (
    echo    Kurulum sirasinda hata olustu!
    echo    Cikis kodu: %SCRIPT_EXIT_CODE%
)
echo ============================================
echo.

:: Pencereyi acik tut (kullanici sonucu gorsun)
echo Kapatmak icin bir tusa basin...
pause >nul
