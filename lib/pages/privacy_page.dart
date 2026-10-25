import 'package:flutter/material.dart';

import '../i18n.dart';
import '../theme/tokens.dart';
import '../widgets/block.dart';

/// Политика конфиденциальности Kosma Сканер (ru/en). Текст совпадает со статической версией
/// для сторов: scaner-main/docs/site/scanner/privacy/index.html — менять обе вместе.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key, required this.lang});
  final Lang lang;

  @override
  Widget build(BuildContext context) {
    final l = lang;
    final t = Theme.of(context).textTheme;
    return Band(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.tr(
                  'Kosma Сканер — политика конфиденциальности',
                  'Kosma Scanner — Privacy Policy',
                ),
                style: t.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l.tr(
                  'Действует с 24 октября 2026 г. · Приложение «Kosma Сканер» (Android, iOS), идентификатор com.kosma.scaner',
                  'Effective October 24, 2026 · “Kosma Scanner” app (Android, iOS), ID com.kosma.scaner',
                ),
                style: t.bodySmall,
              ),
              _h(t, l.tr('Коротко', 'Summary')),
              _p(
                t,
                l.tr(
                  'Отсканированные коды, сессии и справочник товаров хранятся только на вашем устройстве. Мы (разработчик) их не получаем. Камера распознаёт коды на устройстве — кадры не сохраняются и никуда не передаются. В бесплатной версии показывается реклама (Google AdMob), для исправления ошибок используется Firebase Crashlytics.',
                  'Scanned codes, sessions and the product catalog are stored only on your device. We (the developer) do not receive them. The camera recognizes codes on the device — frames are neither saved nor transmitted. The free version shows ads (Google AdMob); Firebase Crashlytics is used to fix crashes.',
                ),
              ),
              _h(t, l.tr('Какие данные и зачем', 'What data and why')),
              for (final r in _rows(l)) _DataCard(lang: l, row: r),
              _h(
                t,
                l.tr('Отправка в ваш API (Pro)', 'Sending to your API (Pro)'),
              ),
              _p(
                t,
                l.tr(
                  'Если вы подключите собственный сервер (Настройки → Интеграции), сессии отправляются только на указанный вами адрес и только по вашему действию (кнопка «Отправить в API» и её автоматический повтор). Справочник товаров может загружаться с того же адреса. Мы эти данные не получаем. Ключи и пароли подключения хранятся в защищённом хранилище устройства (Keychain / Keystore).',
                  'If you connect your own server (Settings → Integrations), sessions are sent only to the address you entered and only when you act (the “Send to API” button and its automatic retry). The product catalog may be loaded from the same address. We do not receive this data. Connection keys and passwords are kept in the device’s secure storage (Keychain / Keystore).',
                ),
              ),
              _h(t, l.tr('Резервные копии', 'Backups')),
              _p(
                t,
                l.tr(
                  'На Android база сессий может входить в резервную копию вашего аккаунта Google (стандартная функция системы). Ключи подключения к API в копию не попадают.',
                  'On Android the session database may be included in your Google account backup (a standard system feature). API connection keys are not backed up.',
                ),
              ),
              _h(t, l.tr('Разрешения', 'Permissions')),
              _p(
                t,
                l.tr(
                  'Камера — сканирование кодов. Интернет — реклама (Free), отчёты о сбоях, отправка в ваш API (Pro). Вибрация — отклик на скан.',
                  'Camera — scanning codes. Internet — ads (Free), crash reports, sending to your API (Pro). Vibration — scan feedback.',
                ),
              ),
              _h(t, l.tr('Хранение и удаление', 'Retention and deletion')),
              _p(
                t,
                l.tr(
                  'Данные на устройстве удаляются вместе с сессией, кнопкой «Очистить справочник» или удалением приложения. Данные у Google (AdMob, Crashlytics) хранятся по их правилам: policies.google.com/privacy, firebase.google.com/support/privacy. По запросу на e-mail ниже поможем удалить отчёты о сбоях, связанные с вашим устройством.',
                  'On-device data is removed with the session, with “Clear catalog”, or by uninstalling the app. Data held by Google (AdMob, Crashlytics) follows their policies: policies.google.com/privacy, firebase.google.com/support/privacy. On request to the e-mail below we will help delete crash reports linked to your device.',
                ),
              ),
              _h(t, l.tr('Дети', 'Children')),
              _p(
                t,
                l.tr(
                  'Приложение предназначено для работы на складе и в торговле и не ориентировано на детей до 13 лет.',
                  'The app is intended for warehouse and retail work and is not directed at children under 13.',
                ),
              ),
              _h(t, l.tr('Изменения и контакты', 'Changes and contact')),
              _p(
                t,
                l.tr(
                  'Об изменениях политики сообщим в описании обновления. Вопросы и запросы: $kContactEmail.',
                  'Policy changes will be announced in the update notes. Questions and requests: $kContactEmail.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _h(TextTheme t, String s) => Padding(
    padding: const EdgeInsets.only(top: 40, bottom: 12),
    child: Text(s, style: t.titleLarge),
  );

  static Widget _p(TextTheme t, String s) =>
      Text(s, style: t.bodyLarge?.copyWith(height: 1.6));

  static List<(String, String, String)> _rows(Lang l) => [
    (
      l.tr(
        'Рекламный идентификатор устройства, приблизительное местоположение по IP, показы и нажатия рекламы',
        'Advertising ID, approximate location from IP, ad impressions and clicks',
      ),
      l.tr(
        'Google AdMob — только в бесплатной версии; в Pro реклама и её SDK не запускаются',
        'Google AdMob — free version only; in Pro the ads SDK does not start',
      ),
      l.tr(
        'Показ рекламы. Согласие запрашивается там, где этого требует закон (например, ЕЭЗ)',
        'Serving ads. Consent is requested where required by law (e.g. the EEA)',
      ),
    ),
    (
      l.tr(
        'Отчёты о сбоях: модель и версия ОС, производитель терминала, версия приложения, тариф (Free/Pro)',
        'Crash reports: device model and OS version, terminal manufacturer, app version, plan (Free/Pro)',
      ),
      'Firebase Crashlytics (Google)',
      l.tr(
        'Поиск и исправление ошибок. Сканы и содержимое сессий в отчёты не попадают',
        'Finding and fixing bugs. Scans and session contents are not included',
      ),
    ),
    (
      l.tr('Покупки подписки', 'Subscription purchases'),
      'Google Play / App Store',
      l.tr(
        'Оплата Pro. Платёжные данные обрабатывает магазин, приложение их не видит',
        'Pro payments. Payment details are handled by the store; the app never sees them',
      ),
    ),
  ];
}

/// Строка таблицы «данные — кто получает — зачем» карточкой: читается и на узком экране.
class _DataCard extends StatelessWidget {
  const _DataCard({required this.lang, required this.row});
  final Lang lang;
  final (String, String, String) row;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget field(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: t.labelSmall?.copyWith(color: K.link),
          ),
          const SizedBox(height: 4),
          Text(value, style: t.bodyMedium),
        ],
      ),
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: K.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: K.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          field(lang.tr('Данные', 'Data'), row.$1),
          field(lang.tr('Кто получает', 'Recipient'), row.$2),
          field(lang.tr('Зачем', 'Purpose'), row.$3),
        ],
      ),
    );
  }
}
