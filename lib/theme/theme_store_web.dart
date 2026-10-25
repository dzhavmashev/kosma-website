import 'package:web/web.dart' as web;

const _key = 'kosma-theme';

/// true — светлая, false — тёмная, null — выбора не было (по умолчанию тёмная).
bool? loadLightPref() {
  try {
    final v = web.window.localStorage.getItem(_key);
    return v == null ? null : v == 'light';
  } catch (_) {
    return null; // хранилище недоступно (приватный режим)
  }
}

void saveLightPref(bool light) {
  try {
    web.window.localStorage.setItem(_key, light ? 'light' : 'dark');
  } catch (_) {}
}
