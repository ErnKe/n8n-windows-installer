# n8n Self-Hosted Installer for Windows

[![Windows](https://img.shields.io/badge/Platform-Windows%2010%2F11-0078D6?logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Docker](https://img.shields.io/badge/Docker-Required-2496ED?logo=docker&logoColor=white)](https://www.docker.com/products/docker-desktop)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-2.0-green.svg)](https://github.com/ErnKe/n8n-windows-installer)

**Made by Eren Kekic**

Windows kullanicilari icin tek tiklama ile Docker uzerinde PostgreSQL destekli n8n kurulumu.

---

## Ozellikler

- **Tek Tiklama Kurulum** - Sadece `install-n8n.bat` dosyasina cift tiklayin
- **Otomatik Docker Desktop Kurulumu** - Docker yoksa otomatik indirir ve kurar
- **WSL2 Kontrolu** - Windows Subsystem for Linux kontrolu
- **Guclu Rastgele Sifre Olusturma** - PostgreSQL icin guvenli sifreler
- **PostgreSQL Veritabani** - Guvenilir ve olceklenebilir veritabani
- **Yonetim Araclari** - Baslat, durdur, yeniden baslat, durum, log goruntuleme
- **Yedekleme ve Geri Yukleme** - Veritabani yedekleme destegi
- **Guncelleme Destegi** - Kullanici onayli guncelleme mekanizmasi
- **Guvenli Kaldirma** - Veri korumali kaldirma secenekleri
- **Masaustu Kisayolu** - Otomatik masaustu kisayolu olusturma

---

## Gereksinimler

| Gereksinim | Minimum | Onerilen |
|------------|---------|----------|
| Isletim Sistemi | Windows 10 | Windows 11 |
| RAM | 4 GB | 8 GB+ |
| Disk Alani | 5 GB | 10 GB+ |
| Internet | Gerekli | Gerekli |
| Port | 5678 bos olmali | - |

> **Not:** Docker Desktop kurulu degilse, installer otomatik olarak indirir ve kurar.

---

## Kurulum

### Adim 1: Dosyalari Indirin
Bu repository'yi indirin veya klonlayin:
```bash
git clone https://github.com/ErnKe/n8n-windows-installer.git
```

### Adim 2: Kurulumu Baslatin
`install-n8n.bat` dosyasina **cift tiklayin**.

### Adim 3: UAC Onayi
Windows sizden Administrator yetkisi isteyecek. **"Evet"** butonuna tiklayin.

### Adim 4: Talimatları Takip Edin
Kurulum scripti:
1. Sistem gereksinimlerini kontrol eder
2. Docker Desktop'i kurar (gerekirse)
3. PostgreSQL ve n8n container'larini baslatir
4. Guvenli sifreler olusturur

### Adim 5: Tamamlandi!
Kurulum tamamlandiginda tarayicinizda n8n acilacaktir:
```
http://localhost:5678
```

---

## Kullanilabilir Komutlar

| Komut | Aciklama |
|-------|----------|
| `install-n8n.bat` | n8n kurulumunu baslat |
| `start-n8n.bat` | n8n'i baslat |
| `stop-n8n.bat` | n8n'i durdur |
| `restart-n8n.bat` | n8n'i yeniden baslat |
| `status-n8n.bat` | Container durumunu kontrol et |
| `logs-n8n.bat` | Loglari goruntule (menu secenekleri ile) |
| `backup-n8n.bat` | PostgreSQL veritabanini yedekle |
| `update-n8n.bat` | n8n'i en son surume guncelle |
| `uninstall-n8n.bat` | n8n'i kaldir (veri koruma secenekleri) |

---

## Proje Yapisi

```
ErenKekic_n8n/
├── install-n8n.bat          # Ana kurulum baslatici
├── start-n8n.bat            # n8n'i baslat
├── stop-n8n.bat             # n8n'i durdur
├── restart-n8n.bat          # n8n'i yeniden baslat
├── status-n8n.bat           # Durum kontrolu
├── logs-n8n.bat             # Log goruntuleme
├── update-n8n.bat           # Guncelleme
├── backup-n8n.bat           # Yedekleme
├── uninstall-n8n.bat        # Kaldirma
├── scripts/
│   ├── setup.ps1            # Ana kurulum scripti
│   └── utils.ps1            # Yardimci fonksiyonlar
├── docker/
│   └── docker-compose.yml   # Docker yapilandirmasi
├── config/
│   ├── .env                 # Ortam degiskenleri (olusturulur)
│   └── .env.example         # Ornek ortam dosyasi
├── logs/                    # Kurulum loglari
├── backups/                 # Veritabani yedekleri
├── README.md                # Bu dosya
└── .gitignore               # Git ignore kurallari
```

---

## Guvenlik

### Sifre Yonetimi
- PostgreSQL sifreleri rastgele olusturulur (16 karakter, guclu)
- N8N_ENCRYPTION_KEY otomatik olusturulur (32 karakter hex)
- Tum sifreler `config/.env` dosyasinda saklanir

### Onemli Notlar
- `.env` dosyasi `.gitignore`'da tanimlidir, Git'e yuklenmez
- Sifrelerinizi guvenli bir yerde yedekleyin
- Production ortaminda ek guvenlik onlemleri alin

---

## Sorun Giderme

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

# Uygulamayi kapatin veya portu degistirin
```

### Container Baslamiyor
**Cozum:**
```bash
# Container loglarini kontrol edin
docker logs n8n
docker logs n8n-postgres

# Container'lari yeniden baslatin
docker compose -f docker/docker-compose.yml restart
```

### Log Dosyalari
Kurulum loglari:
```
logs/install_YYYYMMDD_HHMMSS.log
```

---

## Kaldirma

### Secenekler
`uninstall-n8n.bat` dosyasini calistirin ve secim yapin:

1. **Sadece Container'lari Kaldir** - Veriler korunur
2. **Container + Volume'lari Kaldir** - TUM VERILER SILINIR!

### Manuel Kaldirma
```bash
# Container'lari durdur
docker compose -f docker/docker-compose.yml down

# Verileri de sil (DIKKAT!)
docker compose -f docker/docker-compose.yml down -v
```

---

## Lisans

MIT License

Copyright (c) 2024 Eren Kekic

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

---

## Yazar

**Eren Kekic**

- GitHub: [ErnKe](https://github.com/ErnKe)

---

## Tesekkurler

- [n8n](https://n8n.io/) - Workflow otomasyon platformu
- [Docker](https://www.docker.com/) - Container platformu
- [PostgreSQL](https://www.postgresql.org/) - Veritabani
