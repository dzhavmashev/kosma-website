#!/usr/bin/env bash
# Сборка Flutter Web сайта ВНУТРИ контейнера flutter-builder и атомарная выкладка.
#   build-site <каталог в /src> <подкаталог в /site> [base-href]
#   docker exec flutter-builder build-site kosma-website _preview /_preview/
# git pull — только если у репозитория есть origin и доступ (deploy key); иначе собирает как есть.
set -euo pipefail

repo="${1:?каталог репозитория в /src}"
out="${2:?подкаталог выкладки в /site}"
base="${3:-/}"

# один сегмент пути: не даём затереть /site целиком или выйти за его пределы
[[ "$repo" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]*$ ]] || { echo "плохое имя репозитория: $repo" >&2; exit 2; }
[[ "$out" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]*$ ]] || { echo "плохой подкаталог: $out" >&2; exit 2; }

src="/src/$repo"
cd "$src"
git config --global --add safe.directory "$src" 2>/dev/null || true
if git remote get-url origin >/dev/null 2>&1; then
  git pull --ff-only || echo "git pull не удался — собираю текущие исходники" >&2
fi

flutter --version | head -1
flutter pub get
flutter build web --release --base-href "$base"

tmp="/site/.$out.new.$$"
old="/site/.$out.old.$$"
rm -rf "$tmp"
cp -a build/web "$tmp"
chown -R "${HOST_UID:-1000}:${HOST_GID:-1000}" "$tmp" "$src"
[ -e "/site/$out" ] && mv "/site/$out" "$old"
mv "$tmp" "/site/$out"
rm -rf "$old"
echo "готово: /site/$out (base-href $base)"
