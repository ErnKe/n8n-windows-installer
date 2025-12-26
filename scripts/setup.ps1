# ============================================
# n8n Self-Hosted Installer
# Windows Docker Kurulum Scripti
# ============================================

#Requires -Version 5.1

# ============================================
# UTILITY FONKSIYONLARI IMPORT
# ============================================
. "$PSScriptRoot\utils.ps1"

# ============================================
# GLOBAL DEGISKENLER
# ============================================
$script:ScriptStartTime = Get-Date
$script:SuccessCount = 0
$script:ErrorCount = 0
$script:WarningCount = 0
$script:LogFile = $null
$script:ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$script:ProjectRoot = Split-Path -Parent $script:ScriptRoot

# ============================================
# YARDIMCI FONKSIYONLAR
# ============================================

function Get-TurkeyTime {
    <#
    .SYNOPSIS
    Turkiye saatini dondurur (UTC+3)
    #>
    return (Get-Date).ToUniversalTime().AddHours(3)
}

function Get-Timestamp {
    <#
    .SYNOPSIS
    Log icin timestamp formatini dondurur [HH:mm:ss]
    #>
    return "[$(Get-TurkeyTime | Get-Date -Format 'HH:mm:ss')]"
}

function Initialize-Logging {
    <#
    .SYNOPSIS
    Log dosyasini olusturur ve logging sistemini baslatir
    #>
    $logsDir = Join-Path $script:ProjectRoot "logs"

    # logs klasoru yoksa olustur
    if (-not (Test-Path $logsDir)) {
        New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
    }

    # Log dosya adi: install_YYYYMMDD_HHMMSS.log
    $timestamp = Get-TurkeyTime | Get-Date -Format 'yyyyMMdd_HHmmss'
    $script:LogFile = Join-Path $logsDir "install_$timestamp.log"

    # Log dosyasini olustur ve baslik yaz
    $header = @"
========================================
n8n Self-Hosted Installer - Log Dosyasi
Tarih: $(Get-TurkeyTime | Get-Date -Format 'yyyy-MM-dd HH:mm:ss') (Turkiye Saati)
========================================

"@
    $header | Out-File -FilePath $script:LogFile -Encoding UTF8
}

function Write-Log {
    <#
    .SYNOPSIS
    Log dosyasina mesaj yazar (ekrana yazmaz)
    .PARAMETER Message
    Yazilacak mesaj
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    if ($script:LogFile -and (Test-Path $script:LogFile)) {
        $logMessage = "$(Get-Timestamp) $Message"
        $logMessage | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
    }
}

function Write-Info {
    <#
    .SYNOPSIS
    Bilgi mesaji yazar (Cyan renk)
    .PARAMETER Message
    Yazilacak mesaj
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $timestamp = Get-Timestamp
    $formattedMessage = "$timestamp [INFO] $Message"

    Write-Host $formattedMessage -ForegroundColor Cyan
    Write-Log "[INFO] $Message"
}

function Write-Success {
    <#
    .SYNOPSIS
    Basari mesaji yazar (Green renk)
    .PARAMETER Message
    Yazilacak mesaj
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $timestamp = Get-Timestamp
    $formattedMessage = "$timestamp [OK] $Message"

    Write-Host $formattedMessage -ForegroundColor Green
    Write-Log "[OK] $Message"
    $script:SuccessCount++
}

function Write-WarningLog {
    <#
    .SYNOPSIS
    Uyari mesaji yazar (Yellow renk)
    .PARAMETER Message
    Yazilacak mesaj
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $timestamp = Get-Timestamp
    $formattedMessage = "$timestamp [UYARI] $Message"

    Write-Host $formattedMessage -ForegroundColor Yellow
    Write-Log "[UYARI] $Message"
    $script:WarningCount++
}

function Write-ErrorLog {
    <#
    .SYNOPSIS
    Hata mesaji yazar (Red renk)
    .PARAMETER Message
    Yazilacak mesaj
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $timestamp = Get-Timestamp
    $formattedMessage = "$timestamp [HATA] $Message"

    Write-Host $formattedMessage -ForegroundColor Red
    Write-Log "[HATA] $Message"
    $script:ErrorCount++
}

function Show-Banner {
    <#
    .SYNOPSIS
    Script baslangic banner'ini gosterir - ASCII Art ile
    #>

    # ASCII Art Banner
    $asciiArt = @"

    ███████╗██████╗ ███████╗███╗   ██╗    ██╗  ██╗███████╗██╗  ██╗██╗ ██████╗
    ██╔════╝██╔══██╗██╔════╝████╗  ██║    ██║ ██╔╝██╔════╝██║ ██╔╝██║██╔════╝
    █████╗  ██████╔╝█████╗  ██╔██╗ ██║    █████╔╝ █████╗  █████╔╝ ██║██║
    ██╔══╝  ██╔══██╗██╔══╝  ██║╚██╗██║    ██╔═██╗ ██╔══╝  ██╔═██╗ ██║██║
    ███████╗██║  ██║███████╗██║ ╚████║    ██║  ██╗███████╗██║  ██╗██║╚██████╗
    ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝

"@

    Write-Host ""
    Write-Host $asciiArt -ForegroundColor Cyan

    # Alt bilgi kutusu
    Write-Host "    ╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "    ║                                                                      ║" -ForegroundColor Magenta
    Write-Host "    ║              " -ForegroundColor Magenta -NoNewline
    Write-Host "n8n Self-Hosted Installer" -ForegroundColor White -NoNewline
    Write-Host "                               ║" -ForegroundColor Magenta
    Write-Host "    ║              " -ForegroundColor Magenta -NoNewline
    Write-Host "Windows Docker Kurulum Scripti" -ForegroundColor Gray -NoNewline
    Write-Host "                          ║" -ForegroundColor Magenta
    Write-Host "    ║                                                                      ║" -ForegroundColor Magenta
    Write-Host "    ║                      " -ForegroundColor Magenta -NoNewline
    Write-Host "Made by Eren Kekic" -ForegroundColor Yellow -NoNewline
    Write-Host "                              ║" -ForegroundColor Magenta
    Write-Host "    ║                                                                      ║" -ForegroundColor Magenta
    Write-Host "    ╠══════════════════════════════════════════════════════════════════════╣" -ForegroundColor Magenta
    Write-Host "    ║                                                                      ║" -ForegroundColor Magenta
    Write-Host "    ║    " -ForegroundColor Magenta -NoNewline
    Write-Host "PostgreSQL + n8n Docker Kurulumu" -ForegroundColor Cyan -NoNewline
    Write-Host "                               ║" -ForegroundColor Magenta
    Write-Host "    ║    " -ForegroundColor Magenta -NoNewline
    Write-Host "URL: http://localhost:5678" -ForegroundColor Green -NoNewline
    Write-Host "                                      ║" -ForegroundColor Magenta
    Write-Host "    ║                                                                      ║" -ForegroundColor Magenta
    Write-Host "    ╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""

    Write-Log "Script baslatildi"
}

function Show-Summary {
    <#
    .SYNOPSIS
    Script sonunda ozet bilgi gosterir
    #>
    $endTime = Get-Date
    $duration = $endTime - $script:ScriptStartTime
    $durationFormatted = "{0:mm}:{0:ss}" -f $duration

    Write-Host ""
    Write-Host "    ╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor White
    Write-Host "    ║                                                                      ║" -ForegroundColor White
    Write-Host "    ║                          " -ForegroundColor White -NoNewline
    Write-Host "KURULUM OZETI" -ForegroundColor Cyan -NoNewline
    Write-Host "                             ║" -ForegroundColor White
    Write-Host "    ║                                                                      ║" -ForegroundColor White
    Write-Host "    ╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor White
    Write-Host ""

    # Basari sayisi
    if ($script:SuccessCount -gt 0) {
        Write-Host "  Basarili islemler: $($script:SuccessCount)" -ForegroundColor Green
    }

    # Uyari sayisi
    if ($script:WarningCount -gt 0) {
        Write-Host "  Uyarilar: $($script:WarningCount)" -ForegroundColor Yellow
    }

    # Hata sayisi
    if ($script:ErrorCount -gt 0) {
        Write-Host "  Hatalar: $($script:ErrorCount)" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "    Toplam sure: $durationFormatted" -ForegroundColor White
    Write-Host "    Log dosyasi: $($script:LogFile)" -ForegroundColor Gray
    Write-Host ""

    # Log dosyasina ozet yaz
    Write-Log "========================================"
    Write-Log "KURULUM OZETI"
    Write-Log "Basarili: $($script:SuccessCount), Uyari: $($script:WarningCount), Hata: $($script:ErrorCount)"
    Write-Log "Toplam sure: $durationFormatted"
    Write-Log "========================================"
}

# ============================================
# ANA SCRIPT AKISI
# ============================================

# 1. Logging sistemini baslat
Initialize-Logging

# 2. Banner'i goster
Show-Banner

# 3. Baslangic mesaji
Write-Info "Kurulum scripti baslatiliyor..."
Write-Info "Proje dizini: $script:ProjectRoot"

# ============================================
# SISTEM GEREKSINIMLERI KONTROLU (TASK 4)
# ============================================

function Test-InternetConnection {
    <#
    .SYNOPSIS
    Internet baglantisini kontrol eder
    #>
    Write-Info "Internet baglantisi kontrol ediliyor..."

    try {
        # hub.docker.com'a ping at
        $testResult = Test-Connection -ComputerName "hub.docker.com" -Count 2 -Quiet -ErrorAction SilentlyContinue
        if ($testResult) {
            Write-Success "Internet baglantisi mevcut"
            return $true
        }

        # Yedek test: google.com
        $testResult2 = Test-Connection -ComputerName "google.com" -Count 2 -Quiet -ErrorAction SilentlyContinue
        if ($testResult2) {
            Write-Success "Internet baglantisi mevcut"
            return $true
        }

        # Baglanti yok
        Show-ErrorBox -Title "Internet Baglantisi Yok" -Message @(
            "Internet baglantisi tespit edilemedi!",
            "Docker imajlarini indirmek icin internet gerekli.",
            "Lutfen internet baglantinizi kontrol edin."
        )
        Write-ErrorLog "Internet baglantisi yok!"
        return $false
    } catch {
        Write-ErrorLog "Internet kontrolu sirasinda hata: $_"
        return $false
    }
}

function Test-WSL2Installed {
    <#
    .SYNOPSIS
    WSL2 kurulu mu kontrol eder
    #>
    Write-Info "WSL2 durumu kontrol ediliyor..."

    try {
        $wslStatus = wsl --status 2>&1

        # WSL kurulu ve calisiyorsa
        if ($LASTEXITCODE -eq 0 -and $wslStatus -notmatch "not found|bulunamadi") {
            Write-Success "WSL2 kurulu ve calisir durumda"
            return $true
        }

        # WSL kurulu degil
        Show-WarningBox -Title "WSL2 Kurulu Degil" -Message @(
            "Docker Desktop, WSL2 backend ile daha iyi calisir.",
            "WSL2 kurulu degilse performans sorunlari yasayabilirsiniz."
        )

        $installWsl = Get-UserConfirmation -Message "WSL2'yi simdi kurmak ister misiniz?" -Title "WSL2 Kurulumu"

        if ($installWsl) {
            Write-Info "WSL2 kurulumu icin asagidaki adimlari izleyin:"
            Write-Host ""
            Write-Host "    Asagidaki komutu Administrator PowerShell'de calistirin:" -ForegroundColor Yellow
            Write-Host "    wsl --install" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "    Kurulum tamamlandiktan sonra bilgisayarinizi yeniden baslatin" -ForegroundColor Yellow
            Write-Host "    ve bu scripti tekrar calistirin." -ForegroundColor Yellow
            Write-Host ""
            Pause-ForUser
            return $false
        }

        # Kullanici WSL2 kurmak istemiyor, devam et (Docker Desktop Hyper-V ile de calisabilir)
        Write-WarningLog "WSL2 kurulmadan devam ediliyor..."
        return $true
    } catch {
        # WSL komutu bulunamadi veya hata olustu
        Write-WarningLog "WSL2 kontrolu yapilamadi, devam ediliyor..."
        return $true
    }
}

function Test-WindowsVersion {
    <#
    .SYNOPSIS
    Windows 10/11 surum kontrolu yapar
    #>
    Write-Info "Windows surumu kontrol ediliyor..."

    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $osVersion = [System.Environment]::OSVersion.Version
    $buildNumber = $osInfo.BuildNumber

    # Windows 10+ kontrolu (Major >= 10)
    if ($osVersion.Major -ge 10) {
        Write-Success "Windows $($osVersion.Major) tespit edildi (Build $buildNumber)"
        return $true
    } else {
        Write-ErrorLog "Windows 10 veya uzeri gerekli! Mevcut: Windows $($osVersion.Major)"
        return $false
    }
}

function Test-DockerInstalled {
    <#
    .SYNOPSIS
    Docker Desktop kurulu mu kontrol eder
    Kurulu degilse kullanici onayiyla otomatik kurulum yapar
    #>
    Write-Info "Docker kurulumu kontrol ediliyor..."

    try {
        $dockerPath = Get-Command docker -ErrorAction SilentlyContinue
        if ($dockerPath) {
            $dockerVersion = docker --version 2>&1
            Write-Success "Docker kurulu: $dockerVersion"
            return $true
        }

        # Docker kurulu degil - Kullaniciya sor
        Show-WarningBox -Title "Docker Desktop Kurulu Degil" -Message @(
            "Docker Desktop, n8n'i calistirmak icin gereklidir.",
            "Indirme boyutu: ~500MB"
        )

        $installDocker = Get-UserConfirmation -Message "Docker Desktop'i indirip kurmak ister misiniz?" -Title "Docker Kurulumu"

        if ($installDocker) {
            # Indir ve kur
            $installerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
            $installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

            Write-Info "Docker Desktop indiriliyor... (Bu islem birkaç dakika surebilir)"
            Write-Host ""

            try {
                # Ilerleme gostergesi ile indir
                $ProgressPreference = 'Continue'
                Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
                Write-Success "Indirme tamamlandi!"
                Write-Host ""
            } catch {
                Show-ErrorBox -Title "Indirme Hatasi" -Message @(
                    "Docker Desktop indirilemedi!",
                    "Hata: $_",
                    "",
                    "Manuel indirme linki:",
                    "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
                )
                Write-ErrorLog "Docker Desktop indirme hatasi: $_"
                return $false
            }

            Write-Info "Docker Desktop kuruluyor..."
            Write-Host "    (Kurulum penceresi acilacak, lutfen bekleyin...)" -ForegroundColor Gray
            Write-Host ""

            try {
                # Kurulum baslat
                Start-Process -FilePath $installerPath -Wait

                Show-SuccessBox -Title "Docker Desktop Kuruldu" -Message @(
                    "Docker Desktop basariyla kuruldu!",
                    "",
                    "ONEMLI: Lutfen asagidaki adimlari izleyin:",
                    "1. Bilgisayarinizi yeniden baslatin",
                    "2. Docker Desktop'in acilmasini bekleyin",
                    "3. Bu scripti tekrar calistirin"
                )

                Write-Host ""
                Write-Host "    Script simdi sonlandirilacak." -ForegroundColor Yellow
                Write-Host "    Yeniden baslatma sonrasi scripti tekrar calistirin." -ForegroundColor Yellow
                Write-Host ""
                Pause-ForUser
                exit 0
            } catch {
                Show-ErrorBox -Title "Kurulum Hatasi" -Message @(
                    "Docker Desktop kurulumu sirasinda hata olustu!",
                    "Hata: $_",
                    "",
                    "Lutfen manuel olarak kurun:",
                    "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
                )
                Write-ErrorLog "Docker Desktop kurulum hatasi: $_"
                return $false
            }
        } else {
            # Kullanici kurulum istemedi
            Show-ErrorBox -Title "Kurulum Iptal Edildi" -Message @(
                "Docker Desktop olmadan n8n kurulamaz.",
                "",
                "Manuel kurulum icin asagidaki linki kullanin:",
                "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
            )
            Write-ErrorLog "Kullanici Docker kurulumunu reddetti."
            return $false
        }
    } catch {
        Write-ErrorLog "Docker kontrol edilirken hata olustu: $_"
        return $false
    }
}

function Test-DockerRunning {
    <#
    .SYNOPSIS
    Docker servisi calisiyir mu kontrol eder
    #>
    Write-Info "Docker servisi kontrol ediliyor..."

    try {
        $dockerInfo = docker info 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Docker servisi calisiyor"
            return $true
        } else {
            Write-ErrorLog "Docker servisi calismiyor! Docker Desktop'i baslatin."
            return $false
        }
    } catch {
        Write-ErrorLog "Docker servisi kontrol edilirken hata: $_"
        return $false
    }
}

function Test-DockerCompose {
    <#
    .SYNOPSIS
    Docker Compose V2 mevcut mu kontrol eder
    #>
    Write-Info "Docker Compose kontrol ediliyor..."

    try {
        $composeVersion = docker compose version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Docker Compose mevcut: $composeVersion"
            return $true
        } else {
            Write-ErrorLog "Docker Compose bulunamadi! Docker Desktop'u guncelleyin."
            return $false
        }
    } catch {
        Write-ErrorLog "Docker Compose kontrol edilirken hata: $_"
        return $false
    }
}

function Test-SystemResources {
    <#
    .SYNOPSIS
    RAM ve disk alani kontrolu yapar
    #>
    Write-Info "Sistem kaynaklari kontrol ediliyor..."

    $allPassed = $true

    # RAM kontrolu
    $totalRAM = (Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory
    $totalRAMGB = [math]::Round($totalRAM / 1GB, 1)

    if ($totalRAMGB -ge 8) {
        Write-Success "RAM: $totalRAMGB GB (Ideal)"
    } elseif ($totalRAMGB -ge 4) {
        Write-WarningLog "RAM: $totalRAMGB GB (Minimum - 8GB oneriliyor)"
    } else {
        Write-ErrorLog "RAM: $totalRAMGB GB (Yetersiz - minimum 4GB gerekli)"
        $allPassed = $false
    }

    # Disk alani kontrolu (proje dizininin bulundugu surucude)
    $projectDrive = (Split-Path -Qualifier $script:ProjectRoot)
    $disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$projectDrive'"
    $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 1)

    if ($freeSpaceGB -ge 10) {
        Write-Success "Disk alani ($projectDrive): $freeSpaceGB GB bos (Yeterli)"
    } elseif ($freeSpaceGB -ge 2) {
        Write-WarningLog "Disk alani ($projectDrive): $freeSpaceGB GB bos (Minimum - 10GB oneriliyor)"
    } else {
        Write-ErrorLog "Disk alani ($projectDrive): $freeSpaceGB GB bos (Yetersiz - minimum 2GB gerekli)"
        $allPassed = $false
    }

    return $allPassed
}

# ============================================
# PORT KONTROLU (TASK 5)
# ============================================

function Test-PortAvailable {
    <#
    .SYNOPSIS
    Belirtilen portun kullanilabilir olup olmadigini kontrol eder
    .PARAMETER Port
    Kontrol edilecek port numarasi
    #>
    param(
        [Parameter(Mandatory=$true)]
        [int]$Port
    )

    Write-Info "Port $Port kontrol ediliyor..."

    try {
        $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue

        if ($connections) {
            # Port kullanimda - hangi process kullanıyor bul
            $connection = $connections | Select-Object -First 1
            $processId = $connection.OwningProcess

            try {
                $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
                $processName = if ($process) { $process.ProcessName } else { "Bilinmiyor" }

                Write-ErrorLog "Port $Port kullanimda!"
                Write-ErrorLog "Kullanan process: $processName (PID: $processId)"
                Write-ErrorLog "Lutfen bu uygulamayi kapatin ve tekrar deneyin."
            } catch {
                Write-ErrorLog "Port $Port kullanimda! (PID: $processId)"
            }

            return $false
        } else {
            Write-Success "Port $Port kullanilabilir"
            return $true
        }
    } catch {
        # Get-NetTCPConnection hata verirse port bos demektir
        Write-Success "Port $Port kullanilabilir"
        return $true
    }
}

function Test-RequiredPorts {
    <#
    .SYNOPSIS
    n8n icin gerekli portu kontrol eder
    Not: PostgreSQL 5432 portu Docker internal network'te calisir, host'un 5432 portuyla ilgisi yoktur
    #>
    Write-Info "Gerekli portlar kontrol ediliyor..."

    $allPassed = $true

    # n8n portu (5678)
    if (-not (Test-PortAvailable -Port 5678)) {
        $allPassed = $false
    }

    # Not: PostgreSQL 5432 portu Docker internal network icinde kullanilir
    # Host'un 5432 portunu kontrol etmeye gerek yok

    return $allPassed
}

function Test-PreviousInstallation {
    <#
    .SYNOPSIS
    Onceki n8n kurulumunu kontrol eder
    #>
    Write-Info "Onceki kurulum kontrol ediliyor..."

    try {
        # Docker calisiyorsa container kontrolu yap
        $existingContainer = docker ps -a --filter "name=n8n" --format "{{.Names}}" 2>&1

        if ($existingContainer -match "n8n") {
            Show-WarningBox -Title "Mevcut Kurulum Bulundu" -Message @(
                "Sistemde mevcut bir n8n kurulumu tespit edildi!",
                "Yeni kurulum mevcut container'lari degistirecektir."
            )

            $overwrite = Get-UserConfirmation -Message "Mevcut kurulumun uzerine yazmak ister misiniz?" -Title "Kurulum Onayi"

            if ($overwrite) {
                Write-Info "Mevcut kurulum kaldirilacak ve yenisi kurulacak..."
                return $true
            } else {
                Write-Info "Kurulum kullanici tarafindan iptal edildi."
                return $false
            }
        }

        Write-Success "Onceki kurulum bulunamadi, temiz kurulum yapilacak"
        return $true
    } catch {
        # Docker calismiyorsa veya hata olustuysa devam et
        Write-WarningLog "Onceki kurulum kontrolu yapilamadi, devam ediliyor..."
        return $true
    }
}

function Test-AllRequirements {
    <#
    .SYNOPSIS
    Tum sistem gereksinimlerini sirayla kontrol eder
    #>
    Write-Host ""
    Write-Host "    ╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "    ║                                                                      ║" -ForegroundColor Cyan
    Write-Host "    ║                  " -ForegroundColor Cyan -NoNewline
    Write-Host "SISTEM GEREKSINIMLERI KONTROLU" -ForegroundColor White -NoNewline
    Write-Host "                      ║" -ForegroundColor Cyan
    Write-Host "    ║                                                                      ║" -ForegroundColor Cyan
    Write-Host "    ╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    Write-Log "========================================"
    Write-Log "SISTEM GEREKSINIMLERI KONTROLU BASLADI"
    Write-Log "========================================"

    # Internet baglantisi kontrolu (en basta)
    if (-not (Test-InternetConnection)) {
        Write-ErrorLog "Internet baglantisi yok. Kurulum durduruluyor."
        return $false
    }

    # Windows kontrolu
    if (-not (Test-WindowsVersion)) {
        Write-ErrorLog "Windows surumu uygun degil. Kurulum durduruluyor."
        return $false
    }

    # WSL2 kontrolu (Docker kontrolunden once)
    if (-not (Test-WSL2Installed)) {
        Write-ErrorLog "WSL2 kurulumu gerekli. Kurulum durduruluyor."
        return $false
    }

    # Docker kurulu mu
    if (-not (Test-DockerInstalled)) {
        Write-ErrorLog "Docker kurulu degil. Kurulum durduruluyor."
        return $false
    }

    # Docker calisiyor mu
    if (-not (Test-DockerRunning)) {
        Write-ErrorLog "Docker servisi calismiyor. Kurulum durduruluyor."
        return $false
    }

    # Docker Compose var mi
    if (-not (Test-DockerCompose)) {
        Write-ErrorLog "Docker Compose bulunamadi. Kurulum durduruluyor."
        return $false
    }

    # Sistem kaynaklari
    if (-not (Test-SystemResources)) {
        Write-ErrorLog "Sistem kaynaklari yetersiz. Kurulum durduruluyor."
        return $false
    }

    # Port kontrolleri (TASK 5)
    if (-not (Test-RequiredPorts)) {
        Write-ErrorLog "Gerekli portlar kullanimda. Kurulum durduruluyor."
        return $false
    }

    # Onceki kurulum kontrolu (en sonda)
    if (-not (Test-PreviousInstallation)) {
        Write-ErrorLog "Kurulum kullanici tarafindan iptal edildi."
        return $false
    }

    Write-Host ""
    Write-Success "Tum sistem gereksinimleri karsilandi!"
    Write-Log "Tum sistem gereksinimleri kontrolu basarili"

    return $true
}

# ============================================
# DOCKER COMPOSE KURULUM ISLEMLERI (TASK 6)
# ============================================

function Copy-DockerComposeFile {
    <#
    .SYNOPSIS
    docker-compose.yml dosyasinin varligini kontrol eder
    #>
    Write-Info "Docker Compose dosyasi kontrol ediliyor..."

    $dockerComposeFile = Join-Path $script:ProjectRoot "docker\docker-compose.yml"

    if (Test-Path $dockerComposeFile) {
        Write-Success "docker-compose.yml dosyasi mevcut: $dockerComposeFile"
        return $true
    } else {
        Write-ErrorLog "docker-compose.yml dosyasi bulunamadi!"
        Write-ErrorLog "Beklenen konum: $dockerComposeFile"
        return $false
    }
}

function Start-N8nInstallation {
    <#
    .SYNOPSIS
    Docker imajlarini ceker ve servisleri baslatir
    Hata durumunda cleanup yapar
    #>
    $dockerDir = Join-Path $script:ProjectRoot "docker"
    $composeFile = Join-Path $dockerDir "docker-compose.yml"

    # Docker imajlarini cek
    Write-Info "Docker imajlari cekiliyor... (Bu islem birkac dakika surebilir)"
    Write-Log "docker compose pull baslatiliyor"

    try {
        $pullResult = docker compose -f "$composeFile" pull 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-ErrorLog "Docker imajlari cekilemedi!"
            Write-ErrorLog "Hata detayi: $pullResult"
            Write-ErrorLog "Olasi neden: Internet baglantisi sorunu veya Docker Hub erisim problemi"
            Write-Log "docker compose pull basarisiz - Exit code: $LASTEXITCODE"
            Invoke-Cleanup
            return $false
        }
        Write-Success "Docker imajlari basariyla cekildi"
        Write-Log "docker compose pull basarili"
    } catch {
        Write-ErrorLog "Docker pull sirasinda beklenmeyen hata: $_"
        Write-ErrorLog "Hata tipi: $($_.Exception.GetType().Name)"
        Write-Log "docker compose pull exception: $_"
        Invoke-Cleanup
        return $false
    }

    # Servisleri baslat
    Write-Info "n8n servisleri baslatiliyor..."
    Write-Log "docker compose up -d baslatiliyor"

    try {
        $upResult = docker compose -f "$composeFile" up -d 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-ErrorLog "Docker servisleri baslatilamadi!"
            Write-ErrorLog "Hata detayi: $upResult"
            Write-ErrorLog "Olasi neden: Port cakismasi veya kaynak yetersizligi"
            Write-Log "docker compose up basarisiz - Exit code: $LASTEXITCODE"
            Invoke-Cleanup
            return $false
        }
        Write-Success "Docker servisleri baslatildi"
        Write-Log "docker compose up basarili"
        return $true
    } catch {
        Write-ErrorLog "Docker up sirasinda beklenmeyen hata: $_"
        Write-ErrorLog "Hata tipi: $($_.Exception.GetType().Name)"
        Write-Log "docker compose up exception: $_"
        Invoke-Cleanup
        return $false
    }
}

function Wait-ForN8nReady {
    <#
    .SYNOPSIS
    n8n'in hazir olmasini bekler (max 60 saniye)
    #>
    Write-Info "n8n'in hazir olmasini bekleniyor..."

    $maxWait = 60
    $interval = 5
    $elapsed = 0
    $url = "http://localhost:5678"

    while ($elapsed -lt $maxWait) {
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                Write-Success "n8n hazir! ($elapsed saniye)"
                return $true
            }
        } catch {
            # Henuz hazir degil, beklemeye devam
        }

        Write-Info "n8n henuz hazir degil, $interval saniye bekleniyor... ($elapsed/$maxWait saniye)"
        Start-Sleep -Seconds $interval
        $elapsed += $interval
    }

    Write-ErrorLog "n8n $maxWait saniye icerisinde hazir olmadi!"
    Write-ErrorLog "Lutfen 'docker compose logs n8n' komutu ile loglari kontrol edin."
    return $false
}

function Test-ContainersRunning {
    <#
    .SYNOPSIS
    Container'larin calisip calismadigini kontrol eder
    #>
    Write-Info "Container durumlari kontrol ediliyor..."

    $dockerDir = Join-Path $script:ProjectRoot "docker"
    $composeFile = Join-Path $dockerDir "docker-compose.yml"

    try {
        $psResult = docker compose -f "$composeFile" ps --format "table {{.Name}}\t{{.Status}}" 2>&1

        # n8n container kontrolu
        $n8nRunning = $psResult | Select-String -Pattern "n8n.*Up|n8n.*running" -Quiet
        # postgres container kontrolu
        $postgresRunning = $psResult | Select-String -Pattern "postgres.*Up|postgres.*running" -Quiet

        if ($n8nRunning -and $postgresRunning) {
            Write-Success "Tum containerlar calisiyor"
            Write-Log "Container durumu: $psResult"
            return $true
        } else {
            Write-ErrorLog "Bazi containerlar calismiyor!"
            Write-ErrorLog "Durum: $psResult"
            return $false
        }
    } catch {
        Write-ErrorLog "Container durumu kontrol edilemedi: $_"
        return $false
    }
}

function Show-InstallationSuccess {
    <#
    .SYNOPSIS
    Basarili kurulum mesajini gosterir
    #>
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "        KURULUM BASARILI!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  n8n artik kullanima hazir!" -ForegroundColor White
    Write-Host ""
    Write-Host "  URL: " -NoNewline -ForegroundColor White
    Write-Host "http://localhost:5678" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Ilk kullanim icin:" -ForegroundColor Yellow
    Write-Host "  1. Tarayicinizda http://localhost:5678 adresini acin" -ForegroundColor White
    Write-Host "  2. Yeni bir hesap olusturun" -ForegroundColor White
    Write-Host "  3. Workflow'larinizi olusturmaya baslayin!" -ForegroundColor White
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green

    Write-Log "Kurulum basariyla tamamlandi"
    Write-Log "n8n URL: http://localhost:5678"
}

# ============================================
# HATA YONETIMI VE ROLLBACK (TASK 7)
# ============================================

function Stop-N8nContainers {
    <#
    .SYNOPSIS
    Container'lari durdurur ve temizlik yapar
    #>
    Write-Info "Container'lar durduruluyor..."
    Write-Log "docker compose down baslatiliyor"

    $dockerDir = Join-Path $script:ProjectRoot "docker"
    $composeFile = Join-Path $dockerDir "docker-compose.yml"

    try {
        if (Test-Path $composeFile) {
            $downResult = docker compose -f "$composeFile" down 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Container'lar durduruldu"
                Write-Log "docker compose down basarili"
                return $true
            } else {
                Write-WarningLog "Container'lar durdurulurken uyari: $downResult"
                return $false
            }
        } else {
            Write-Log "docker-compose.yml bulunamadi, down islemi atlanıyor"
            return $true
        }
    } catch {
        Write-ErrorLog "Container'lar durdurulurken hata: $_"
        return $false
    }
}

function Show-TroubleshootingHelp {
    <#
    .SYNOPSIS
    Hata durumunda kullaniciya yardimci bilgiler gosterir
    #>
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "      SORUN GIDERME REHBERI" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Olasi sorunlar ve cozumleri:" -ForegroundColor White
    Write-Host ""
    Write-Host "  1. Docker Desktop calismiyor olabilir" -ForegroundColor Cyan
    Write-Host "     -> Docker Desktop uygulamasini baslatin" -ForegroundColor Gray
    Write-Host "     -> Sistem tepsisinde Docker ikonunu kontrol edin" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2. Port 5678 baska uygulama tarafindan kullaniliyor" -ForegroundColor Cyan
    Write-Host "     -> Portu kullanan uygulamayi kapatin" -ForegroundColor Gray
    Write-Host "     -> Komut: netstat -ano | findstr :5678" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  3. Internet baglantisi sorunu olabilir" -ForegroundColor Cyan
    Write-Host "     -> Internet baglantinizi kontrol edin" -ForegroundColor Gray
    Write-Host "     -> Docker Hub'a erisimi test edin" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  4. Docker kaynaklari yetersiz olabilir" -ForegroundColor Cyan
    Write-Host "     -> Docker Desktop ayarlarindan RAM/CPU artirin" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  5. Detayli loglar icin:" -ForegroundColor Cyan
    Write-Host "     -> $($script:LogFile)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  6. Docker loglari icin:" -ForegroundColor Cyan
    Write-Host "     -> docker compose -f docker/docker-compose.yml logs" -ForegroundColor Gray
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow

    Write-Log "Sorun giderme rehberi gosterildi"
}

function Invoke-Cleanup {
    <#
    .SYNOPSIS
    Hata durumunda temizlik islemlerini yapar
    #>
    Write-Info "Temizlik islemi baslatiliyor..."
    Write-Log "Cleanup islemi basladi"

    # Container'lari durdur
    Stop-N8nContainers

    Write-Log "Cleanup islemi tamamlandi"
}

# ============================================
# GUVENLIK AYARLARI (TASK 6)
# ============================================

function Initialize-Security {
    <#
    .SYNOPSIS
    Ilk kurulumda guvenlik ayarlarini yapilandirir
    - Rastgele PostgreSQL sifresi olusturur
    - Rastgele N8N encryption key olusturur
    - config/.env dosyasina kaydeder
    #>
    Write-Info "Guvenlik ayarlari yapilandiriliyor..."
    Write-Log "Initialize-Security basladi"

    $configDir = Join-Path $script:ProjectRoot "config"
    $envFile = Join-Path $configDir ".env"

    # config klasoru olustur
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
        Write-Log "config klasoru olusturuldu: $configDir"
    }

    # Eger .env zaten varsa, kullaniciya sor
    if (Test-Path $envFile) {
        Show-WarningBox -Title "Mevcut Yapilandirma Bulundu" -Message @(
            "config/.env dosyasi zaten mevcut!",
            "Yeni sifreler olusturulursa mevcut sifreler silinir."
        )

        $overwrite = Get-UserConfirmation -Message "Yeni sifreler olusturmak ister misiniz?" -Title "Guvenlik Ayarlari"

        if (-not $overwrite) {
            Write-Success "Mevcut guvenlik ayarlari korunuyor"
            Write-Log "Kullanici mevcut .env dosyasini korumak istedi"
            return $true
        }
    }

    # Rastgele sifreler olustur
    Write-Info "Guclu sifreler olusturuluyor..."
    $postgresPassword = New-RandomPassword -Length 16
    $encryptionKey = New-EncryptionKey

    # .env dosyasi icerigi
    $envContent = @"
# ============================================
# n8n Self-Hosted Installer - Environment Variables
# ============================================
# Bu dosya otomatik olusturulmustur
# Olusturulma Tarihi: $(Get-TurkeyTime | Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
# Made by Eren Kekic
# ============================================

# PostgreSQL Ayarlari
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$postgresPassword
POSTGRES_DB=n8n

# n8n Encryption Key (32 karakter hex)
# Workflow credentials sifrelemesi icin kullanilir
N8N_ENCRYPTION_KEY=$encryptionKey
"@

    # .env dosyasini yaz
    try {
        $envContent | Out-File -FilePath $envFile -Encoding UTF8 -Force
        Write-Success ".env dosyasi olusturuldu: $envFile"
        Write-Log ".env dosyasi basariyla olusturuldu"
    } catch {
        Write-ErrorLog ".env dosyasi olusturulamadi: $_"
        return $false
    }

    # Kullaniciya sifreleri goster
    Show-WarningBox -Title "ONEMLI: Sifreleri Kaydedin!" -Message @(
        "Asagidaki sifreler SADECE BIR KEZ gosterilecektir!",
        "Lutfen guvenli bir yere kaydedin.",
        "",
        "PostgreSQL Sifresi:",
        "  $postgresPassword",
        "",
        "n8n Encryption Key:",
        "  $encryptionKey",
        "",
        "Bu bilgiler config/.env dosyasina kaydedildi."
    )

    Pause-ForUser

    Write-Log "Guvenlik ayarlari basariyla yapilandirildi"
    return $true
}

function Install-N8n {
    <#
    .SYNOPSIS
    Ana kurulum fonksiyonu - tum adimlari sirayla calistirir
    #>
    Write-Host ""
    Write-Host "    ╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "    ║                                                                      ║" -ForegroundColor Green
    Write-Host "    ║                       " -ForegroundColor Green -NoNewline
    Write-Host "n8n KURULUM ISLEMI" -ForegroundColor White -NoNewline
    Write-Host "                             ║" -ForegroundColor Green
    Write-Host "    ║                                                                      ║" -ForegroundColor Green
    Write-Host "    ╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""

    Write-Log "========================================="
    Write-Log "n8n KURULUM ISLEMI BASLADI"
    Write-Log "========================================="

    # 0. Guvenlik ayarlarini yap (TASK 6)
    if (-not (Initialize-Security)) {
        Write-ErrorLog "Guvenlik ayarlari yapilandirilamadi. Kurulum durduruluyor."
        return $false
    }

    # 1. Docker Compose dosyasini kontrol et
    if (-not (Copy-DockerComposeFile)) {
        Write-ErrorLog "Docker Compose dosyasi bulunamadi. Kurulum durduruluyor."
        Show-TroubleshootingHelp
        return $false
    }

    # 2. Docker imajlarini cek ve servisleri baslat
    if (-not (Start-N8nInstallation)) {
        Write-ErrorLog "Docker kurulumu basarisiz. Kurulum durduruluyor."
        Invoke-Cleanup
        Show-TroubleshootingHelp
        return $false
    }

    # 3. n8n'in hazir olmasini bekle
    if (-not (Wait-ForN8nReady)) {
        Write-WarningLog "n8n henuz tam hazir olmayabilir, ancak devam ediliyor..."
    }

    # 4. Container'larin calistigini dogrula
    if (-not (Test-ContainersRunning)) {
        Write-ErrorLog "Containerlar duzgun calismiyor. Lutfen loglari kontrol edin."
        Invoke-Cleanup
        Show-TroubleshootingHelp
        return $false
    }

    # 5. Basari mesajini goster
    Show-InstallationSuccess

    # 6. Tarayici acma secenegi
    $openBrowser = Get-UserConfirmation -Message "Tarayicida n8n'i acmak ister misiniz?" -Title "n8n'i Ac"
    if ($openBrowser) {
        Write-Info "Tarayici aciliyor..."
        Start-Process "http://localhost:5678"
        Write-Success "Tarayici acildi"
    }

    # 7. Masaustu kisayolu olusturma secenegi
    $createShortcut = Get-UserConfirmation -Message "Masaustune baslatma kisayolu olusturulsun mu?" -Title "Masaustu Kisayolu"
    if ($createShortcut) {
        try {
            $desktop = [Environment]::GetFolderPath("Desktop")
            $shortcutPath = Join-Path $desktop "n8n Baslat.lnk"
            $targetPath = Join-Path $script:ProjectRoot "start-n8n.bat"

            $WshShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WshShell.CreateShortcut($shortcutPath)
            $Shortcut.TargetPath = $targetPath
            $Shortcut.WorkingDirectory = $script:ProjectRoot
            $Shortcut.Description = "n8n Self-Hosted Installer - n8n'i Baslat"
            $Shortcut.Save()

            Write-Success "Masaustu kisayolu olusturuldu: n8n Baslat"
            Write-Log "Masaustu kisayolu olusturuldu: $shortcutPath"
        } catch {
            Write-WarningLog "Masaustu kisayolu olusturulamadi: $_"
        }
    }

    # 8. Kullanilabilir komutlar listesi
    Write-Host ""
    Write-Host "    ╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "    ║                                                                      ║" -ForegroundColor Cyan
    Write-Host "    ║                  " -ForegroundColor Cyan -NoNewline
    Write-Host "KULLANILABILIR KOMUTLAR" -ForegroundColor White -NoNewline
    Write-Host "                         ║" -ForegroundColor Cyan
    Write-Host "    ║                                                                      ║" -ForegroundColor Cyan
    Write-Host "    ╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    start-n8n.bat      " -ForegroundColor Yellow -NoNewline
    Write-Host "- n8n'i baslat" -ForegroundColor White
    Write-Host "    stop-n8n.bat       " -ForegroundColor Yellow -NoNewline
    Write-Host "- n8n'i durdur" -ForegroundColor White
    Write-Host "    restart-n8n.bat    " -ForegroundColor Yellow -NoNewline
    Write-Host "- n8n'i yeniden baslat" -ForegroundColor White
    Write-Host "    status-n8n.bat     " -ForegroundColor Yellow -NoNewline
    Write-Host "- Durum kontrolu" -ForegroundColor White
    Write-Host "    logs-n8n.bat       " -ForegroundColor Yellow -NoNewline
    Write-Host "- Loglari goruntule" -ForegroundColor White
    Write-Host "    backup-n8n.bat     " -ForegroundColor Yellow -NoNewline
    Write-Host "- Yedek al" -ForegroundColor White
    Write-Host "    update-n8n.bat     " -ForegroundColor Yellow -NoNewline
    Write-Host "- Guncelle" -ForegroundColor White
    Write-Host "    uninstall-n8n.bat  " -ForegroundColor Yellow -NoNewline
    Write-Host "- n8n'i kaldir" -ForegroundColor White
    Write-Host ""

    Write-Log "Kullanilabilir komutlar listesi gosterildi"

    return $true
}

# ============================================
# BEKLENMEYEN HATALAR ICIN TRAP HANDLER (TASK 7)
# ============================================

trap {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "    BEKLENMEYEN HATA OLUSTU!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Hata: $_" -ForegroundColor Red
    Write-Host ""

    # Log dosyasina yaz
    if ($script:LogFile -and (Test-Path $script:LogFile)) {
        "$(Get-Timestamp) [KRITIK HATA] Beklenmeyen hata: $_" | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
        "$(Get-Timestamp) [KRITIK HATA] Stack trace: $($_.ScriptStackTrace)" | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
    }

    # Cleanup yap (eger fonksiyon tanimli ise)
    if (Get-Command -Name Invoke-Cleanup -ErrorAction SilentlyContinue) {
        Invoke-Cleanup
    }

    # Sorun giderme rehberini goster
    if (Get-Command -Name Show-TroubleshootingHelp -ErrorAction SilentlyContinue) {
        Show-TroubleshootingHelp
    }

    # Ozet goster
    if (Get-Command -Name Show-Summary -ErrorAction SilentlyContinue) {
        Show-Summary
    }

    exit 1
}

# ============================================
# ANA SCRIPT AKISI
# ============================================

# Sistem gereksinim kontrollerini calistir
Write-Success "Log sistemi basariyla kuruldu"

if (-not (Test-AllRequirements)) {
    Write-ErrorLog "Sistem gereksinimleri karsilanmadi. Script sonlandiriliyor."
    Show-Summary
    exit 1
}

# n8n kurulumunu baslat (TASK 6)
if (-not (Install-N8n)) {
    Write-ErrorLog "n8n kurulumu basarisiz oldu."
    Show-Summary
    exit 1
}

# ============================================
# SCRIPT SONU
# ============================================

# Ozet goster
Show-Summary
