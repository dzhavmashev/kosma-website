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

## Сборка на сервере

watch-server (192.168.192.50), стек `flutter-builder` (Portainer → Stacks): образ
`ghcr.io/cirruslabs/flutter:3.44.0`, тома `~/src → /src`, `~/site → /site`, кеш pub.

```bash
docker exec flutter-builder build-site kosma-website _preview /_preview/
```

`tool/build-site.sh` — `git pull` (если есть доступ), `pub get`, `build web`, атомарная выкладка
в `~/site/<подкаталог>`. Описание стека — `deploy/builder/compose.yml`.

Шрифты Jost, Golos Text, JetBrains Mono — OFL (`assets/fonts/licenses`).
