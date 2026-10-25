# kosma.tech — сайт (Flutter Web)

Многоуровневый сайт Kosma: корень — бренд и продукты, «Kosma Сканер» — первая страница продукта.
Макет: https://claude.ai/artifact/FK1PS2DpSWNKgp5qi8GzbR (канвас «Kosma Сканер — сайт»).

Сейчас — **каркас**: роутинг, общий каркас страниц (шапка, меню продуктов, RU/EN, футер),
токены бренда и шрифты. Секции, анимации и лоадер по макету — следующий этап.

## Роутинг

| ru (по умолчанию) | en | Страница |
|---|---|---|
| `/` | `/en` | корень kosma.tech |
| `/scanner` | `/en/scanner` | Kosma Сканер |
| `/scanner/privacy` | `/en/scanner/privacy` | политика конфиденциальности |

Переключатель RU/EN ведёт на ту же страницу в другом языке (`Lang.href`). Адреса без `#`
(`usePathUrlStrategy`) — веб-сервер должен отдавать `index.html` на неизвестные пути.
Умного дома на сайте нет: `/smart-home/` — приватный сервис, его маршрутизирует Caddy.

## Разработка

```bash
export PATH=$HOME/flutter/bin:$PATH     # Flutter 3.44
flutter pub get
flutter run -d chrome
flutter analyze && flutter test
flutter build web --release --base-href /
```

## Сборка и раздача на сервере

watch-server (192.168.192.50), два стека в Portainer (конфиги — `deploy/`):

| Стек | Что | Конфиг |
|---|---|---|
| `flutter-builder` | только сборка: `ghcr.io/cirruslabs/flutter:3.44.0`, тома `~/src → /src`, `~/site → /site`, кеш pub | `deploy/builder/compose.yml` |
| `kosma-site` | только раздача: `nginx:1.29.3-alpine`, `~/site` (ro), `127.0.0.1:8082`, SPA-фолбэк на `index.html` | `deploy/site/compose.yml`, `nginx.conf` |

```bash
docker exec flutter-builder build-site kosma-website kosma-website   # → ~/site/kosma-website
curl -s 127.0.0.1:8082/scanner                                         # отдаёт kosma-site
```

`tool/build-site.sh`: `git pull` (клон `~/src/kosma-website` с deploy key `~/.ssh/kosma_website_deploy`,
read-only, смонтирован в сборщик), `pub get`, `build web`,
атомарная подмена каталога выкладки. nginx монтирует родительский `~/site`, поэтому новая
сборка видна сразу, без перезапуска.

Публично (позже): в Caddyfile стека smarthome (127.0.0.1:8081, за Cloudflare Tunnel) —
`reverse_proxy 127.0.0.1:8082` для всего, кроме `/smart-home/*` (и `/scanner/privacy/`,
пока статическая политика не перенесена во Flutter).

Шрифты Jost, Golos Text, JetBrains Mono — OFL (`assets/fonts/licenses`).

## CI/CD

`.github/workflows/ci.yml`: на каждый push/PR — `flutter analyze`, `flutter test`, `flutter build web` (GitHub-hosted,
Flutter 3.44.0). После зелёного CI на `main` job `deploy` идёт на self-hosted runner с меткой `kosma-site`
(watch-server, отдельный каталог `~/actions-runner-kosma`, привязан только к этому репозиторию) и запускает
`deploy/deploy.sh`: `docker exec flutter-builder build-site kosma-website kosma-website` + проверка 200 у
`/`, `/scanner`, `/en`, `/scanner/privacy` на `127.0.0.1:8082`. Ручной запуск — `workflow_dispatch`.
