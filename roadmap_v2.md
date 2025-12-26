# 🚀 n8n Self-Hosted Installer v2.0 - ROADMAP

## 📋 Güncelleme Özeti
Mevcut projeyi profesyonel seviyeye çıkarıyoruz. Kullanıcı onayı, yönetim araçları, güvenlik ve UX iyileştirmeleri.

**Temel Prensip:** Kritik işlemlerde (kurulum, kaldırma, güncelleme) MUTLAKA kullanıcı onayı al!

---

## 📁 Hedef Proje Yapısı (v2.0)
```
ErenKekiç_n8n/
├── install-n8n.bat           # Ana kurulum başlatıcı
├── start-n8n.bat             # n8n'i başlat
├── stop-n8n.bat              # n8n'i durdur
├── restart-n8n.bat           # n8n'i yeniden başlat
├── status-n8n.bat            # Durum kontrolü
├── logs-n8n.bat              # Logları göster
├── update-n8n.bat            # n8n'i güncelle
├── backup-n8n.bat            # Yedek al
├── uninstall-n8n.bat         # Kaldır
├── scripts/
│   ├── setup.ps1             # Ana kurulum scripti (güncellenecek)
│   ├── utils.ps1             # Ortak fonksiyonlar
│   └── config.ps1            # Konfigürasyon ayarları
├── docker/
│   └── docker-compose.yml    # Docker yapılandırması (güncellenecek)
├── config/
│   └── .env.example          # Örnek environment dosyası
├── logs/
│   └── (kurulum logları)
├── backups/
│   └── (yedekler buraya)
├── README.md
└── .gitignore
```

---

## ✅ TASKLAR

---

### TASK 1: docker-compose.yml Güncellemesi
**Amaç:** Resmi n8n dokümantasyonuna uygun hale getir.

**Yapılacaklar:**
1. Image'ı güncelle: `docker.n8n.io/n8nio/n8n`
2. Şu environment variable'ları EKLE:
   - `GENERIC_TIMEZONE=Europe/Istanbul`
   - `TZ=Europe/Istanbul`
   - `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true`
   - `N8N_RUNNERS_ENABLED=true`
   - `DB_POSTGRESDB_SCHEMA=public`
   - `N8N_INSTANCE_NAME=Eren Kekiç n8n Server` ⭐
3. PostgreSQL için dinamik şifre desteği hazırla (${POSTGRES_PASSWORD} placeholder)

**Çıktı:** Güncellenmiş docker-compose.yml

---

### TASK 2: Kullanıcı Onay Sistemi Oluştur
**Amaç:** Kritik işlemler için kullanıcı onayı mekanizması.

**Yapılacaklar:**
1. `scripts/utils.ps1` dosyası oluştur
2. Şu fonksiyonları ekle:
   - `Get-UserConfirmation` - Evet/Hayır sorusu (E/H)
   - `Get-UserChoice` - Çoklu seçenek sunma
   - `Show-Warning` - Uyarı mesajı gösterme
   - `Pause-ForUser` - Devam etmek için bekle
3. Renkli ve okunaklı çıktılar

**Örnek Kullanım:**
```
╔══════════════════════════════════════════════════════════════╗
║  ⚠️  UYARI: Docker Desktop kurulu değil!                      ║
║                                                              ║
║  Docker Desktop'ı indirip kurmak ister misiniz?              ║
║  İndirme boyutu: ~500MB                                      ║
╚══════════════════════════════════════════════════════════════╝

[E] Evet, indir ve kur    [H] Hayır, kurulumu iptal et

Seçiminiz (E/H):
```

**Çıktı:** scripts/utils.ps1

---

### TASK 3: ASCII Banner ve UI İyileştirmeleri
**Amaç:** Profesyonel görünüm, "Made by Eren Kekiç" banner'ı.

**Yapılacaklar:**
1. `Show-Banner` fonksiyonunu yeniden yaz
2. Büyük ASCII art banner ekle (EREN KEKİÇ)
3. Renkli ve dikkat çekici tasarım
4. Alt başlıklar:
   - "n8n Self-Hosted Installer v2.0"
   - "Made by Eren Kekiç"
   - "https://github.com/ErnKe/n8n-windows-installer"
5. Terminal pencere başlığını ayarla
6. Çerçeveli kutular kullan (═══, ║, ╔, ╗, ╚, ╝)

**Çıktı:** Güncellenmiş Show-Banner fonksiyonu

---

### TASK 4: Ön Gereksinim Kontrolleri Güncelle
**Amaç:** WSL2, Internet, önceki kurulum kontrolü ekle.

**Yapılacaklar:**
1. `Test-WSL2Installed` fonksiyonu ekle
   - WSL2 kurulu mu kontrol et
   - Kurulu değilse kullanıcıya sor ve kurulum linki göster
2. `Test-InternetConnection` fonksiyonu ekle
   - hub.docker.com'a ping at
   - Bağlantı yoksa uyar
3. `Test-PreviousInstallation` fonksiyonu ekle
   - n8n container'ı zaten var mı kontrol et
   - Varsa kullanıcıya sor: "Üzerine yazılsın mı?"
4. Port 5432 kontrolünü KALDIR

**Çıktı:** Güncellenmiş kontrol fonksiyonları

---

### TASK 5: Docker Desktop Otomatik Kurulum
**Amaç:** Docker yoksa kullanıcı onayı ile indir ve kur.

**Yapılacaklar:**
1. `Install-DockerDesktop` fonksiyonu oluştur
2. Kullanıcıya onay sor (ZORUNLU)
3. Onay verirse:
   - Docker Desktop installer'ı indir
   - Sessiz kurulum başlat
   - Kurulum tamamlanınca bilgilendir
   - Yeniden başlatma gerekebilir uyarısı
4. Onay vermezse:
   - Kurulumu iptal et
   - Manuel kurulum linkini göster

**Çıktı:** Docker otomatik kurulum fonksiyonu

---

### TASK 6: Güvenlik İyileştirmeleri
**Amaç:** Rastgele şifreler ve encryption key.

**Yapılacaklar:**
1. `New-RandomPassword` fonksiyonu oluştur (16 karakter, güçlü)
2. `New-EncryptionKey` fonksiyonu oluştur (32 karakter hex)
3. İlk kurulumda:
   - Rastgele PostgreSQL şifresi oluştur
   - Rastgele N8N_ENCRYPTION_KEY oluştur
   - `.env` dosyasına kaydet
4. `.env` dosyasını `.gitignore`'a ekle
5. Kullanıcıya şifreleri göster ve kaydetmesini söyle

**Çıktı:** Güvenlik fonksiyonları ve .env desteği

---

### TASK 7: start-n8n.bat ve stop-n8n.bat Oluştur
**Amaç:** n8n'i kolayca başlat/durdur.

**Yapılacaklar:**
1. `start-n8n.bat` oluştur:
   - Docker servisini kontrol et
   - `docker compose up -d` çalıştır
   - Başarılı mesajı göster
   - Tarayıcıyı otomatik aç (http://localhost:5678)
2. `stop-n8n.bat` oluştur:
   - Kullanıcı onayı AL
   - `docker compose stop` çalıştır
   - Başarılı mesajı göster

**Çıktı:** start-n8n.bat, stop-n8n.bat

---

### TASK 8: restart-n8n.bat ve status-n8n.bat Oluştur
**Amaç:** Yeniden başlatma ve durum kontrolü.

**Yapılacaklar:**
1. `restart-n8n.bat` oluştur:
   - Kullanıcı onayı AL
   - `docker compose restart` çalıştır
2. `status-n8n.bat` oluştur:
   - Container durumunu göster
   - Uptime bilgisi
   - Memory/CPU kullanımı
   - n8n erişilebilir mi kontrol et

**Çıktı:** restart-n8n.bat, status-n8n.bat

---

### TASK 9: logs-n8n.bat Oluştur
**Amaç:** n8n loglarını kolayca görüntüle.

**Yapılacaklar:**
1. `logs-n8n.bat` oluştur:
   - Seçenekler sun:
     [1] Son 50 satır
     [2] Son 100 satır
     [3] Canlı log takibi (Ctrl+C ile çık)
     [4] Hata logları
   - `docker compose logs` komutlarını çalıştır

**Çıktı:** logs-n8n.bat

---

### TASK 10: update-n8n.bat Oluştur
**Amaç:** n8n'i güvenli şekilde güncelle.

**Yapılacaklar:**
1. `update-n8n.bat` oluştur:
   - ⚠️ Kullanıcı onayı AL (ÖNEMLİ!)
   - Güncelleme öncesi otomatik yedek al
   - `docker compose pull` ile yeni image çek
   - `docker compose up -d` ile yeniden başlat
   - Başarılı/başarısız mesajı göster

**Çıktı:** update-n8n.bat

---

### TASK 11: backup-n8n.bat Oluştur
**Amaç:** Veritabanı ve workflow yedekleme.

**Yapılacaklar:**
1. `backup-n8n.bat` oluştur:
   - `backups/` klasörü oluştur
   - PostgreSQL dump al: `pg_dump`
   - n8n volume'unu yedekle
   - Yedek dosya adı: `backup_YYYYMMDD_HHMMSS.tar.gz`
   - Eski yedekleri listeleme seçeneği

**Çıktı:** backup-n8n.bat

---

### TASK 12: uninstall-n8n.bat Oluştur
**Amaç:** Temiz kaldırma (kullanıcı onayı ile).

**Yapılacaklar:**
1. `uninstall-n8n.bat` oluştur:
   - ⚠️⚠️ MUTLAKA kullanıcı onayı AL
   - "TÜM VERİLER SİLİNECEK" uyarısı göster
   - Onay için "KALDIR" yazdır (typo önleme)
   - Seçenekler:
     [1] Sadece container'ları kaldır (veriler kalır)
     [2] Container + Volume'ları kaldır (veriler silinir)
     [3] Her şeyi kaldır (proje klasörü dahil)
   - İşlem sonrası özet göster

**Çıktı:** uninstall-n8n.bat

---

### TASK 13: Kurulum Sonrası İyileştirmeler
**Amaç:** Tarayıcı açma, masaüstü kısayolu.

**Yapılacaklar:**
1. Kurulum tamamlandığında:
   - Kullanıcıya sor: "Tarayıcıda n8n'i açmak ister misiniz?"
   - Evet ise `Start-Process "http://localhost:5678"`
2. Masaüstü kısayolu seçeneği:
   - "Masaüstüne kısayol oluşturulsun mu?"
   - start-n8n.bat için kısayol oluştur

**Çıktı:** Kurulum sonrası iyileştirmeler

---

### TASK 14: README.md ve Dokümantasyon Güncelle
**Amaç:** Yeni özellikleri dokümante et.

**Yapılacaklar:**
1. README.md'yi güncelle:
   - Yeni bat dosyalarını açıkla
   - Kullanım örnekleri ekle
   - Güvenlik notları ekle
   - Yedekleme/geri yükleme açıkla
2. CHANGELOG.md oluştur
3. Son test tarihi ekle

**Çıktı:** Güncellenmiş dokümantasyon

---

### TASK 15: Final Test ve GitHub Push
**Amaç:** Tüm sistemi test et ve GitHub'a yükle.

**Yapılacaklar:**
1. Tüm bat dosyalarını test et
2. Kurulum → Kullanım → Güncelleme → Kaldırma akışını test et
3. Hataları düzelt
4. Git commit ve push

**Çıktı:** Test edilmiş ve GitHub'da yayınlanmış v2.0

---

## 📝 Task İlerleme Durumu

| Task | Durum | Notlar |
|------|-------|--------|
| Task 1 | ⏳ Bekliyor | docker-compose.yml |
| Task 2 | ⏳ Bekliyor | Kullanıcı onay sistemi |
| Task 3 | ⏳ Bekliyor | ASCII banner |
| Task 4 | ⏳ Bekliyor | Ön gereksinim kontrolleri |
| Task 5 | ⏳ Bekliyor | Docker otomatik kurulum |
| Task 6 | ⏳ Bekliyor | Güvenlik (şifreler) |
| Task 7 | ⏳ Bekliyor | start/stop bat |
| Task 8 | ⏳ Bekliyor | restart/status bat |
| Task 9 | ⏳ Bekliyor | logs bat |
| Task 10 | ⏳ Bekliyor | update bat |
| Task 11 | ⏳ Bekliyor | backup bat |
| Task 12 | ⏳ Bekliyor | uninstall bat |
| Task 13 | ⏳ Bekliyor | Kurulum sonrası |
| Task 14 | ⏳ Bekliyor | Dokümantasyon |
| Task 15 | ⏳ Bekliyor | Final test |

---

## 🔄 Çalışma Akışı

Her task için:
1. Claude Code'u **plan modunda** başlat
2. Bu dosyayı oku: `roadmap_v2.md dosyasını oku`
3. İlgili task'ı yap
4. Task tamamlandığında **compact** yap
5. Sonraki task için tekrar **plan modunda** başlat

---

## 📌 ÖNEMLİ PRENSİPLER

1. **KULLANICI ONAYI:** Docker kurulumu, kaldırma, güncelleme gibi kritik işlemlerde MUTLAKA kullanıcı onayı al
2. **GERİ DÖNÜŞ:** Hata durumunda temiz çıkış yap
3. **LOGLAMA:** Tüm işlemleri logla
4. **TÜRKÇE:** Tüm mesajlar Türkçe olsun
5. **RENK:** Önemli mesajlar renkli olsun (Yeşil=Başarı, Kırmızı=Hata, Sarı=Uyarı, Cyan=Bilgi)