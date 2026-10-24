/// Языки сайта: ru — по умолчанию (без префикса), en — под /en/.
enum Lang {
  ru(''),
  en('/en');

  const Lang(this.prefix);

  /// Префикс пути: '' для ru, '/en' для en.
  final String prefix;

  /// Тот же путь страницы в этом языке: path — без языкового префикса ('/scanner').
  String href(String path) =>
      path == '/' ? (prefix.isEmpty ? '/' : prefix) : '$prefix$path';

  /// Строка на текущем языке.
  String tr(String ruText, String enText) => this == Lang.ru ? ruText : enText;
}

/// Рабочий e-mail Kosma. Пока пусто: адрес не заведён — ссылка не показывается.
const kContactEmail = 'contact@kosma.tech';

/// Общие строки каркаса (шапка, футер, 404). Контент страниц — в lib/content/.
class S {
  const S(this.lang);
  final Lang lang;

  bool get _ru => lang == Lang.ru;

  String get slogan => _ru ? 'Порядок во всём' : 'Order in everything';
  String get sloganBoth => 'Порядок во всём · Order in everything';
  String get products => _ru ? 'Продукты' : 'Products';
  String get scanner => _ru ? 'Сканер' : 'Scanner';
  String get warehouse => _ru ? 'Склад' : 'Warehouse';
  String get hr => 'HR';
  String get soon => _ru ? 'скоро' : 'soon';
  String get documents => _ru ? 'Документы' : 'Documents';
  String get privacy => _ru ? 'Политика конфиденциальности' : 'Privacy policy';
  String get privacyScanner =>
      _ru ? 'Политика конфиденциальности · Сканер' : 'Privacy policy · Scanner';
  String get notFound => _ru ? 'Страница не найдена' : 'Page not found';
  String get toHome => _ru ? 'На главную' : 'Home';
  String get menu => _ru ? 'Меню' : 'Menu';
  String get up => _ru ? 'Наверх' : 'Back to top';
  String get next => _ru ? 'К следующему блоку' : 'To the next block';
  String get draft => _ru ? 'Текст появится позже' : 'Text comes later';
}
