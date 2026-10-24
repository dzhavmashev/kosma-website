# CLAUDE.md — kosma-website

Сайт kosma.tech на Flutter Web (одно приложение, go_router). Продукты Kosma — разделы сайта;
первый — «Kosma Сканер» (`/scanner`). Макет: https://claude.ai/artifact/FK1PS2DpSWNKgp5qi8GzbR.

## Правила

- Языки ru и en: ru по умолчанию без префикса, en — под `/en/…`; новые страницы — в `sitePages`
  (`lib/router.dart`), строки — в `lib/i18n.dart` для обоих языков.
- Умный дом на сайте **не показывать** (приватный сервис владельца на `/smart-home/`).
- Бренд — токены `lib/theme/tokens.dart` (лаванда, нейтральные, Jost / Golos Text / JetBrains Mono);
  цвета не хардкодить. Только реальные факты о продуктах; цены и неизвестное — плейсхолдеры.
- Анимации — в языке лоадера приложения (Lottie `kosma-splash.json` из scaner-main/third_party/kosma_brand),
  с учётом системной настройки «уменьшить движение».
- Комментарии в коде — по-русски. Коммиты — по-русски, кратко, что и зачем.
- Перед коммитом: `flutter analyze` (0 issues), `flutter test`, `flutter build web --release`.
- Деплой — через сборочный контейнер `flutter-builder` на watch-server (README, «Сборка на сервере»);
  не трогать стеки smarthome / caddy / cloudflared и `~/smart-home` на сервере.

```bash
export PATH=$HOME/flutter/bin:$PATH
```
