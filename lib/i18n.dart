/// Языки сайта: ru — по умолчанию (без префикса), en — под /en/.
enum Lang {
  ru(''),
  en('/en');

  const Lang(this.prefix);

  /// Префикс пути: '' для ru, '/en' для en.
  final String prefix;

  /// Тот же путь страницы в этом языке: path — без языкового префикса ('/scanner').
  String href(String path) => path == '/' ? (prefix.isEmpty ? '/' : prefix) : '$prefix$path';
}

/// Строки каркаса. Контент страниц появится на следующем этапе (макет на канвасе).
class S {
  const S(this.lang);
  final Lang lang;

  bool get _ru => lang == Lang.ru;

  String get slogan => _ru ? 'Порядок во всём' : 'Order in everything';
  String get products => _ru ? 'Продукты' : 'Products';
  String get scanner => _ru ? 'Сканер' : 'Scanner';
  String get warehouse => _ru ? 'Склад' : 'Warehouse';
  String get soon => _ru ? 'скоро' : 'soon';
  String get scannerTagline => _ru
      ? 'Сканер штрихкодов и QR для склада и ТСД'
      : 'Barcode and QR scanner for warehouses and rugged terminals';
  String get privacy => _ru ? 'Политика конфиденциальности' : 'Privacy policy';
  String get notFound => _ru ? 'Страница не найдена' : 'Page not found';
  String get toHome => _ru ? 'На главную' : 'Home';
  String get draft => _ru ? 'Каркас сайта — содержимое по макету появится позже' : 'Site skeleton — content from the mockup comes next';
}
