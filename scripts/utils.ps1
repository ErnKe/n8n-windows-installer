# ============================================
# n8n Self-Hosted Installer - Utility Functions
# Kullanici Etkilesim Fonksiyonlari
# ============================================
# Bu dosya kritik islemlerde kullanici onayi
# almak icin gerekli fonksiyonlari icerir.
# Made by Eren Kekic
# ============================================

#Requires -Version 5.1

# ============================================
# KUTU GENISLIGI SABITI
# ============================================
$script:BoxWidth = 66

# ============================================
# YARDIMCI FONKSIYONLAR
# ============================================

function Get-PaddedText {
    <#
    .SYNOPSIS
    Metni belirtilen genislige gore sag tarafini boslukla doldurur
    .PARAMETER Text
    Doldurulacak metin
    .PARAMETER Width
    Hedef genislik
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text,
        [Parameter(Mandatory=$false)]
        [int]$Width = $script:BoxWidth
    )

    $paddingNeeded = $Width - $Text.Length
    if ($paddingNeeded -gt 0) {
        return $Text + (" " * $paddingNeeded)
    }
    return $Text.Substring(0, $Width)
}

# ============================================
# KUTU GOSTERME FONKSIYONLARI
# ============================================

function Show-WarningBox {
    <#
    .SYNOPSIS
    Sari renkli uyari kutusu gosterir
    .PARAMETER Title
    Kutu basligi
    .PARAMETER Message
    Gosterilecek mesaj (tek satir veya dizi)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string[]]$Message
    )

    $boxColor = "Yellow"
    $titleColor = "Yellow"
    $textColor = "White"

    Write-Host ""
    Write-Host "    ╔$("═" * $script:BoxWidth)╗" -ForegroundColor $boxColor

    # Baslik satiri
    $titleLine = "  ⚠️  $Title"
    $paddedTitle = Get-PaddedText -Text $titleLine -Width $script:BoxWidth
    Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
    Write-Host $paddedTitle -ForegroundColor $titleColor -NoNewline
    Write-Host "║" -ForegroundColor $boxColor

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor

    # Mesaj satirlari
    foreach ($line in $Message) {
        $msgLine = "  $line"
        $paddedMsg = Get-PaddedText -Text $msgLine -Width $script:BoxWidth
        Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
        Write-Host $paddedMsg -ForegroundColor $textColor -NoNewline
        Write-Host "║" -ForegroundColor $boxColor
    }

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor
    Write-Host "    ╚$("═" * $script:BoxWidth)╝" -ForegroundColor $boxColor
    Write-Host ""
}

function Show-ErrorBox {
    <#
    .SYNOPSIS
    Kirmizi renkli hata kutusu gosterir
    .PARAMETER Title
    Kutu basligi
    .PARAMETER Message
    Gosterilecek mesaj (tek satir veya dizi)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string[]]$Message
    )

    $boxColor = "Red"
    $titleColor = "Red"
    $textColor = "White"

    Write-Host ""
    Write-Host "    ╔$("═" * $script:BoxWidth)╗" -ForegroundColor $boxColor

    # Baslik satiri
    $titleLine = "  ❌  $Title"
    $paddedTitle = Get-PaddedText -Text $titleLine -Width $script:BoxWidth
    Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
    Write-Host $paddedTitle -ForegroundColor $titleColor -NoNewline
    Write-Host "║" -ForegroundColor $boxColor

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor

    # Mesaj satirlari
    foreach ($line in $Message) {
        $msgLine = "  $line"
        $paddedMsg = Get-PaddedText -Text $msgLine -Width $script:BoxWidth
        Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
        Write-Host $paddedMsg -ForegroundColor $textColor -NoNewline
        Write-Host "║" -ForegroundColor $boxColor
    }

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor
    Write-Host "    ╚$("═" * $script:BoxWidth)╝" -ForegroundColor $boxColor
    Write-Host ""
}

function Show-SuccessBox {
    <#
    .SYNOPSIS
    Yesil renkli basari kutusu gosterir
    .PARAMETER Title
    Kutu basligi
    .PARAMETER Message
    Gosterilecek mesaj (tek satir veya dizi)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string[]]$Message
    )

    $boxColor = "Green"
    $titleColor = "Green"
    $textColor = "White"

    Write-Host ""
    Write-Host "    ╔$("═" * $script:BoxWidth)╗" -ForegroundColor $boxColor

    # Baslik satiri
    $titleLine = "  ✅  $Title"
    $paddedTitle = Get-PaddedText -Text $titleLine -Width $script:BoxWidth
    Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
    Write-Host $paddedTitle -ForegroundColor $titleColor -NoNewline
    Write-Host "║" -ForegroundColor $boxColor

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor

    # Mesaj satirlari
    foreach ($line in $Message) {
        $msgLine = "  $line"
        $paddedMsg = Get-PaddedText -Text $msgLine -Width $script:BoxWidth
        Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
        Write-Host $paddedMsg -ForegroundColor $textColor -NoNewline
        Write-Host "║" -ForegroundColor $boxColor
    }

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor
    Write-Host "    ╚$("═" * $script:BoxWidth)╝" -ForegroundColor $boxColor
    Write-Host ""
}

# ============================================
# KULLANICI ETKILESIM FONKSIYONLARI
# ============================================

function Get-UserConfirmation {
    <#
    .SYNOPSIS
    Kullaniciya Evet/Hayir sorusu sorar
    .PARAMETER Message
    Gosterilecek mesaj
    .PARAMETER Title
    Kutu basligi (opsiyonel)
    .RETURNS
    $true (Evet) veya $false (Hayir)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [string]$Title = "Onay Gerekiyor"
    )

    $boxColor = "Yellow"
    $titleColor = "Yellow"
    $textColor = "White"

    Write-Host ""
    Write-Host "    ╔$("═" * $script:BoxWidth)╗" -ForegroundColor $boxColor

    # Baslik satiri
    $titleLine = "  ⚠️  $Title"
    $paddedTitle = Get-PaddedText -Text $titleLine -Width $script:BoxWidth
    Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
    Write-Host $paddedTitle -ForegroundColor $titleColor -NoNewline
    Write-Host "║" -ForegroundColor $boxColor

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor

    # Mesaj satiri
    $msgLine = "  $Message"
    $paddedMsg = Get-PaddedText -Text $msgLine -Width $script:BoxWidth
    Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
    Write-Host $paddedMsg -ForegroundColor $textColor -NoNewline
    Write-Host "║" -ForegroundColor $boxColor

    # Bos satir
    Write-Host "    ║$(" " * $script:BoxWidth)║" -ForegroundColor $boxColor
    Write-Host "    ╚$("═" * $script:BoxWidth)╝" -ForegroundColor $boxColor
    Write-Host ""

    # Secenekler
    Write-Host "    [" -NoNewline -ForegroundColor White
    Write-Host "E" -NoNewline -ForegroundColor Green
    Write-Host "] Evet    [" -NoNewline -ForegroundColor White
    Write-Host "H" -NoNewline -ForegroundColor Red
    Write-Host "] Hayir" -ForegroundColor White
    Write-Host ""

    # Kullanici girdisi al
    while ($true) {
        Write-Host "    Seciminiz (E/H): " -NoNewline -ForegroundColor Cyan
        $input = Read-Host

        switch ($input.ToUpper()) {
            "E" { return $true }
            "Y" { return $true }  # Ingilizce Yes destegi
            "H" { return $false }
            "N" { return $false } # Ingilizce No destegi
            default {
                Write-Host "    Gecersiz secim! Lutfen E (Evet) veya H (Hayir) girin." -ForegroundColor Red
            }
        }
    }
}

function Get-UserChoice {
    <#
    .SYNOPSIS
    Kullaniciya coklu secenek sunar
    .PARAMETER Title
    Kutu basligi
    .PARAMETER Options
    Secenekler dizisi
    .RETURNS
    Secilen seçenegin numarasi (1'den baslar)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string[]]$Options
    )

    $boxColor = "Cyan"
    $titleColor = "White"

    Write-Host ""
    Write-Host "    ╔$("═" * $script:BoxWidth)╗" -ForegroundColor $boxColor

    # Baslik satiri
    $titleLine = "  $Title"
    $paddedTitle = Get-PaddedText -Text $titleLine -Width $script:BoxWidth
    Write-Host "    ║" -ForegroundColor $boxColor -NoNewline
    Write-Host $paddedTitle -ForegroundColor $titleColor -NoNewline
    Write-Host "║" -ForegroundColor $boxColor

    Write-Host "    ╚$("═" * $script:BoxWidth)╝" -ForegroundColor $boxColor
    Write-Host ""

    # Secenekleri listele
    $optionCount = $Options.Count
    for ($i = 0; $i -lt $optionCount; $i++) {
        $num = $i + 1
        Write-Host "    [" -NoNewline -ForegroundColor White
        Write-Host "$num" -NoNewline -ForegroundColor Yellow
        Write-Host "] $($Options[$i])" -ForegroundColor White
    }
    Write-Host ""

    # Kullanici girdisi al
    while ($true) {
        Write-Host "    Seciminiz (1-$optionCount): " -NoNewline -ForegroundColor Cyan
        $inputStr = Read-Host

        # Sayi kontrolu
        $inputNum = 0
        if ([int]::TryParse($inputStr, [ref]$inputNum)) {
            if ($inputNum -ge 1 -and $inputNum -le $optionCount) {
                return $inputNum
            }
        }

        Write-Host "    Gecersiz secim! Lutfen 1 ile $optionCount arasinda bir sayi girin." -ForegroundColor Red
    }
}

function Pause-ForUser {
    <#
    .SYNOPSIS
    Kullanicinin bir tusa basmasini bekler
    #>
    Write-Host ""
    Write-Host "    Devam etmek icin bir tusa basin..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""
}

# ============================================
# GUVENLIK FONKSIYONLARI (TASK 6)
# ============================================

function New-RandomPassword {
    <#
    .SYNOPSIS
    Guclu rastgele sifre olusturur
    .PARAMETER Length
    Sifre uzunlugu (varsayilan 16)
    .RETURNS
    String (sifre)
    #>
    param(
        [Parameter(Mandatory=$false)]
        [int]$Length = 16
    )

    # Karakter setleri
    $uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $lowercase = "abcdefghijklmnopqrstuvwxyz"
    $numbers = "0123456789"
    $special = "!@#$%^&*()-_=+"

    $allChars = $uppercase + $lowercase + $numbers + $special

    # En az birer karakter garanti et
    $password = ""
    $password += $uppercase[(Get-Random -Maximum $uppercase.Length)]
    $password += $lowercase[(Get-Random -Maximum $lowercase.Length)]
    $password += $numbers[(Get-Random -Maximum $numbers.Length)]
    $password += $special[(Get-Random -Maximum $special.Length)]

    # Kalan karakterleri rastgele doldur
    for ($i = 4; $i -lt $Length; $i++) {
        $password += $allChars[(Get-Random -Maximum $allChars.Length)]
    }

    # Sifreyi karistir
    $charArray = $password.ToCharArray()
    $shuffled = $charArray | Get-Random -Count $charArray.Length

    return -join $shuffled
}

function New-EncryptionKey {
    <#
    .SYNOPSIS
    32 karakter hex string olusturur (n8n encryption key icin)
    .RETURNS
    String (32 karakter hex)
    #>
    $bytes = New-Object byte[] 16
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
    $rng.GetBytes($bytes)
    $rng.Dispose()

    return [BitConverter]::ToString($bytes).Replace("-", "").ToLower()
}

# ============================================
# EXPORT (Diger scriptlerde kullanilabilir)
# ============================================

# Fonksiyonlari export et (dot-source ile kullanildiginda)
Export-ModuleMember -Function @(
    'Show-WarningBox',
    'Show-ErrorBox',
    'Show-SuccessBox',
    'Get-UserConfirmation',
    'Get-UserChoice',
    'Pause-ForUser',
    'New-RandomPassword',
    'New-EncryptionKey'
) -ErrorAction SilentlyContinue
