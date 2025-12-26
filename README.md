# n8n Self-Hosted Installer

[![Windows](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue?logo=windows)](https://www.microsoft.com/windows)
[![Docker](https://img.shields.io/badge/Docker-Required-2496ED?logo=docker&logoColor=white)](https://www.docker.com/products/docker-desktop)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Windows kullanicilari icin tek tiklama ile Docker uzerinde PostgreSQL destekli n8n kurulumu.

**One-click n8n installation on Windows with Docker and PostgreSQL support.**

---

## Ozellikler / Features

- **Tek Tiklama Kurulum** - Sadece `install-n8n.bat` dosyasina cift tiklayin
- **PostgreSQL Veritabani** - Guvenilir ve olceklenebilir veritabani
- **Otomatik Docker Yonetimi** - Container'lar otomatik olusturulur ve baslatilir
- **Detayli Loglama** - Tum islemler `logs/` klasorune kaydedilir
- **Hata Yonetimi** - Akilli hata yakalama ve kullanici bilgilendirmesi
- **Sistem Kontrolleri** - Docker, port, RAM ve disk alani kontrolleri

---

## Gereksinimler / Requirements

| Gereksinim | Minimum |
|------------|---------|
| Isletim Sistemi | Windows 10 / 11 |
| Docker Desktop | Kurulu ve calisiyor olmali |
| RAM | 4 GB |
| Disk Alani | 2 GB bos alan |
| Port | 5678 (n8n) bos olmali |

> **Not:** Docker Desktop'in kurulu ve calisir durumda oldugundan emin olun.

---

## Kurulum / Installation

### Adim 1: Dosyalari Indirin
Bu repository'yi indirin veya klonlayin:
```bash
git clone https://github.com/YOUR_USERNAME/n8n-self-hosted-installer.git
```

### Adim 2: Kurulumu Baslatin
`install-n8n.bat` dosyasina **cift tiklayin**.

### Adim 3: UAC Onayi
Windows sizden Administrator yetkisi isteyecek. **"Evet"** butonuna tiklayin.

### Adim 4: Bekleyin
Kurulum scripti:
1. Sistem gereksinimlerini kontrol eder
2. Docker imajlarini indirir
3. PostgreSQL veritabanini baslatir
4. n8n servisini baslatir

### Adim 5: Tamamlandi!
Kurulum tamamlandiginda asagidaki mesaji goreceksiniz:
```
n8n basariyla kuruldu!
Erisim adresi: http://localhost:5678
```

---

## Yapilandirma / Configuration

### docker-compose.yml

Yapilandirma dosyasi `docker/docker-compose.yml` konumundadir.

#### Servisler

| Servis | Aciklama | Port |
|--------|----------|------|
| n8n | Workflow otomasyon platformu | 5678 |
| n8n-postgres | PostgreSQL veritabani | 5432 (internal) |

#### Ortam Degiskenleri (Environment Variables)

**n8n Servisi:**
```yaml
N8N_SECURE_COOKIE=false    # Localhost icin gerekli
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/
```

**PostgreSQL Servisi:**
```yaml
POSTGRES_USER=n8n
POSTGRES_PASSWORD=n8n_password
POSTGRES_DB=n8n
```

> **Guvenlik Notu:** Production ortaminda `POSTGRES_PASSWORD` degerini degistirin!

---

## Kullanim / Usage

### n8n'e Erisim

Tarayicinizi acin ve asagidaki adrese gidin:

```
http://localhost:5678
```

### Ilk Hesap Olusturma

1. n8n acildiginda "Set up owner account" ekrani karsiniza cikacak
2. Email, ad-soyad ve sifre bilgilerinizi girin
3. Hesabinizi olusturun ve workflow'lar yaratmaya baslayin!

### Docker Container Durumu

Container'larin durumunu kontrol etmek icin:
```bash
docker ps
```

---

## Sorun Giderme / Troubleshooting

### Docker Calisiyor mu?

**Hata:** `Docker is not running`

**Cozum:**
1. Docker Desktop uygulamasini acin
2. Docker servisinin baslamasini bekleyin (sistem tepsisinde yesil ikon)
3. Kurulumu tekrar baslatin

### Port Kullanimda

**Hata:** `Port 5678 is already in use`

**Cozum:**
```bash
# Hangi uygulama kullaniyor?
netstat -ano | findstr :5678

# Uygulamayi kapatin veya docker-compose.yml'de portu degistirin
```

### Container Baslamiyor

**Hata:** Container'lar saglikli degil

**Cozum:**
```bash
# Container loglarini kontrol edin
docker logs n8n
docker logs n8n-postgres

# Container'lari yeniden baslatin
docker compose -f docker/docker-compose.yml restart
```

### Log Dosyalari

Kurulum loglari asagidaki konumda bulunur:
```
logs/setup_YYYYMMDD_HHMMSS.log
```

---

## Kaldirma / Uninstall

### Servisleri Durdur

```bash
cd docker
docker compose down
```

### Verileri de Sil (Isteğe Bagli)

```bash
# Volume'lari sil (TUM VERILER SILINIR!)
docker compose down -v
```

### Imajlari Sil (Isteğe Bagli)

```bash
docker rmi n8nio/n8n:latest
docker rmi postgres:16-alpine
```

---

## Proje Yapisi / Project Structure

```
ErenKekic_n8n/
├── install-n8n.bat          # Kurulum baslatici (cift tiklayin!)
├── scripts/
│   └── setup.ps1            # PowerShell kurulum scripti
├── docker/
│   └── docker-compose.yml   # Docker yapilandirmasi
├── logs/                    # Kurulum loglari
├── README.md                # Bu dosya
└── .gitignore               # Git ignore kurallari
```

---

## Lisans / License

Bu proje MIT Lisansi altinda lisanslanmistir. Detaylar icin [LICENSE](LICENSE) dosyasina bakin.

```
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Katkida Bulunma / Contributing

Katkalarinizi bekliyoruz!

### Issue Acma

1. [Issues](../../issues) sayfasina gidin
2. "New Issue" butonuna tiklayin
3. Sorunu veya oneriyi detayli aciklayin

### Pull Request

1. Bu repository'yi fork edin
2. Yeni bir branch olusturun (`git checkout -b feature/yeni-ozellik`)
3. Degisikliklerinizi commit edin (`git commit -m 'Yeni ozellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/yeni-ozellik`)
5. Pull Request acin

---

## Yazar / Author

Eren Kekic

---

## Tesekkurler / Acknowledgments

- [n8n](https://n8n.io/) - Workflow otomasyon platformu
- [Docker](https://www.docker.com/) - Container platformu
- [PostgreSQL](https://www.postgresql.org/) - Veritabani
