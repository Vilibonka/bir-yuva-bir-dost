$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

function Test-Command {
    param([string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Host "Eksik arac bulundu: $Name"
        exit 1
    }
}

Test-Command "node"
Test-Command "npm"
Test-Command "docker"

$composeCommand = $null

try {
    docker compose version *> $null
    $composeCommand = "docker compose"
} catch {
    if (Get-Command "docker-compose" -ErrorAction SilentlyContinue) {
        $composeCommand = "docker-compose"
    }
}

if (-not $composeCommand) {
    Write-Host "Docker Compose bulunamadi. 'docker compose' veya 'docker-compose' gerekli."
    exit 1
}

try {
    docker info *> $null
} catch {
    Write-Host "Docker calismiyor. Lutfen Docker'i baslatip tekrar deneyin."
    exit 1
}

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host ".env dosyasi .env.example uzerinden olusturuldu."
}

Write-Host "PostgreSQL konteyneri baslatiliyor..."
Invoke-Expression "$composeCommand up -d"

Write-Host "npm bagimliliklari kuruluyor..."
npm install

Write-Host "Prisma Client uretiliyor..."
npm run prisma:generate

Write-Host ""
Write-Host "Kurulum tamamlandi. Sonraki adimlar:"
Write-Host "1. npm run prisma:migrate"
Write-Host "2. npm run start:dev"
