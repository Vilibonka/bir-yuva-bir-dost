# Bir Yuva Bir Dost

Bir Yuva Bir Dost, barinaklarin, gonullulerin ve hayvan sahiplenmek isteyen kullanicilarin bir araya geldigi bir hayvan sahiplenme platformudur. Bu depo su an yerel gelistirme ortamini hizli ve sorunsuz kurmak icin NestJS + Prisma + PostgreSQL temelini hazirlar.

## Yerel gelistirme stratejisi

- PostgreSQL Docker ile calisir. Boylece herkes ayni veritabani surumunu kullanir.
- Uygulama ayarlari kok dizindeki `.env` dosyasinda tutulur.
- Prisma yapilandirmasi kokteki `prisma.config.ts` dosyasindan okunur.
- Backend kodu `apps/backend` altinda yer alir.
- Komutlarin buyuk kismi depo kokunden calistirilir.

## Gereksinimler

- Node.js 20 veya ustu
- npm 10 veya ustu
- Docker
- Docker Compose v2 (`docker compose`)

Surumleri kontrol etmek icin:

```bash
node -v
npm -v
docker -v
docker compose version
```

## İlk Sefer Kurulumu

### 1. `.env` dosyasini olustur

macOS/Linux:

```bash
cp .env.example .env
```

Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

Not: `POSTGRES_*` degerlerini degistirirseniz `DATABASE_URL` icindeki kullanici, sifre ve veritabani adini da ayni sekilde guncelleyin.

### 2. PostgreSQL konteynerini baslat

```bash
npm run db:up
```

Veritabani loglarini izlemek icin:

```bash
npm run db:logs
```

### 3. Proje bagimliliklarini kur

```bash
npm install
```

Bu komut kok paketini ve `apps/backend` altindaki workspace bagimliliklarini kurar.

### 4. Prisma Client olustur

```bash
npm run prisma:generate
```

### 5. Ilk migration'i calistir

```bash
npm run prisma:migrate
```

Bu komut ilk migration dosyasini olusturur ve yerel veritabanina uygular.

### 6. Prisma Studio'yu ac

```bash
npm run prisma:studio
```

Varsayilan olarak tarayicida Prisma Studio arayuzu acilir.

### 7. NestJS backend'i gelistirme modunda baslat

```bash
npm run start:dev
```

Backend varsayilan olarak `http://localhost:3000` adresinde calisir. Basit kontrol icin:

- `GET /`
- `GET /health`

## Hizli baslangic scriptleri

Tek komutla temel kurulumu yapmak isterseniz:

macOS/Linux:

```bash
./scripts/dev-up.sh
```

Windows PowerShell:

```powershell
.\scripts\dev-up.ps1
```

Bu scriptler:

- temel araclari kontrol eder
- gerekirse `.env` dosyasini olusturur
- Docker veritabanini baslatir
- `npm install` calistirir
- `prisma generate` calistirir
- sonraki adimlari ekrana yazar

## Sik kullanilan komutlar

```bash
npm run db:up
npm run db:down
npm run db:logs
npm run prisma:generate
npm run prisma:migrate
npm run prisma:studio
npm run start:dev
```

## Proje yapisi

```text
.
|-- apps
|   `-- backend
|       |-- prisma
|       |   |-- migrations
|       |   `-- schema.prisma
|       |-- src
|       |   |-- app.controller.ts
|       |   |-- app.module.ts
|       |   `-- main.ts
|       |-- nest-cli.json
|       |-- package.json
|       |-- tsconfig.build.json
|       `-- tsconfig.json
|-- scripts
|   |-- dev-up.ps1
|   `-- dev-up.sh
|-- docker-compose.yml
|-- package.json
|-- prisma.config.ts
`-- .env.example
```

## Sorun giderme

### 5432 portu zaten kullanimda

Belirti:

- `docker compose up` sirasinda port hatasi alirsiniz.

Cozum:

- Bilgisayarinizda baska bir PostgreSQL calisiyor olabilir.
- `docker-compose.yml` dosyasindaki port eslestirmesini `5433:5432` yapin.
- Ardindan `.env` icindeki `DATABASE_URL` degerini `localhost:5433` olacak sekilde guncelleyin.

### Docker calismiyor

Belirti:

- `docker compose up -d` komutu Docker daemon hatasi verir.

Cozum:

- Docker Desktop veya Docker servisinin acik oldugundan emin olun.
- Tekrar deneyin:

```bash
docker compose up -d
```

### Prisma veritabanina baglanamiyor

Belirti:

- `P1001`, `P1000` veya baglanti hatalari alirsiniz.

Cozum:

- PostgreSQL konteynerinin ayakta oldugunu kontrol edin:

```bash
docker compose ps
```

- `.env` icindeki `DATABASE_URL` ile `POSTGRES_*` degerlerinin birbiriyle uyumlu oldugunu kontrol edin.
- Gerekirse loglari inceleyin:

```bash
npm run db:logs
```

### Migration sorunlari

Belirti:

- Migration yarida kalir veya schema ile veritabani uyusmaz.

Cozum:

- Once Prisma Client'i tekrar uretin:

```bash
npm run prisma:generate
```

- Sonra migration'i tekrar deneyin:

```bash
npm run prisma:migrate
```

- Gelistirme veritabanini tamamen sifirlamak gerekiyorsa dikkatli olun. Asagidaki komut veritabani verisini siler:

```bash
docker compose down -v
```

Sonrasinda tekrar:

```bash
npm run db:up
npm run prisma:migrate
```

## Notlar

- `apps/backend/src/generated` klasoru Prisma tarafindan uretilir; Git'e eklenmez.
- Bu kurulum yerel ekip gelistirmesi icindir. Uretim ortami ayarlari bu asamada dahil degildir.
