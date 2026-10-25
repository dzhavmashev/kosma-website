#!/usr/bin/env bash
# Выкладка сайта на домашнем сервере: сборка в flutter-builder (git pull по deploy key → build web →
# атомарная подмена ~/site/kosma-website) и проверка, что kosma-site отдаёт страницы.
# Запускается self-hosted runner'ом (метка kosma-site) после зелёного CI на main.
set -euo pipefail

docker exec flutter-builder build-site kosma-website kosma-website

for path in / /scanner /en /scanner/privacy; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:8082$path")
  echo "$path → $code"
  [ "$code" = 200 ] || { echo "ошибка: $path отдал $code" >&2; exit 1; }
done
