#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Eksik arac bulundu: $1"
    exit 1
  fi
}

require_command node
require_command npm
require_command docker

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
else
  echo "Docker Compose bulunamadi. 'docker compose' veya 'docker-compose' gerekli."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker calismiyor. Lutfen Docker'i baslatip tekrar deneyin."
  exit 1
fi

if [ ! -f ".env" ]; then
  cp .env.example .env
  echo ".env dosyasi .env.example uzerinden olusturuldu."
fi

echo "PostgreSQL konteyneri baslatiliyor..."
eval "$COMPOSE_CMD up -d"

echo "npm bagimliliklari kuruluyor..."
npm install

echo "Prisma Client uretiliyor..."
npm run prisma:generate

echo
echo "Kurulum tamamlandi. Sonraki adimlar:"
echo "1. npm run prisma:migrate"
echo "2. npm run start:dev"
