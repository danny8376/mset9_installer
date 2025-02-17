import 'dart:ui';

const _localeNameMap = {
  ('ca', null): ('Catalan', '', 'català', ''),
  ('pt', 'PT'): ('Portuguese', 'Portugal', 'português', 'Portugal'),
  ('fr', null): ('French', '', 'français', ''),
  ('af', null): ('Afrikaans', '', 'Afrikaans', ''),
  ('de', null): ('German', '', 'Deutsch', ''),
  ('ar', null): ('Arabic', '', 'العربية', ''),
  ('cs', null): ('Czech', '', 'čeština', ''),
  ('no', null): ('Norwegian', '', 'norsk', ''),
  ('he', null): ('Hebrew', '', 'עברית', ''),
  ('pl', null): ('Polish', '', 'polski', ''),
  ('hu', null): ('Hungarian', '', 'magyar', ''),
  ('fi', null): ('Finnish', '', 'suomi', ''),
  ('zh', 'TW'): ('Chinese', 'Taiwan', '中文', '台灣'),
  ('pt', 'BR'): ('Portuguese', 'Brazil', 'português', 'Brasil'),
  ('zh', 'CN'): ('Chinese', 'China', '中文', '中国'),
  ('ro', null): ('Romanian', '', 'română', ''),
  ('sr', null): ('Serbian', '', 'српски', ''),
  ('ru', null): ('Russian', '', 'русский', ''),
  ('ja', null): ('Japanese', '', '日本語', ''),
  ('vi', null): ('Vietnamese', '', 'Tiếng Việt', ''),
  ('uk', null): ('Ukrainian', '', 'українська', ''),
  ('en', null): ('English', '', 'English', ''),
  ('el', null): ('Greek', '', 'Ελληνικά', ''),
  ('sv', 'SE'): ('Swedish', 'Sweden', 'svenska', 'Sverige'),
  ('tr', null): ('Turkish', '', 'Türkçe', ''),
  ('ko', null): ('Korean', '', '한국어', ''),
  ('es', 'ES'): ('Spanish', 'Spain', 'español', 'España'),
  ('nl', null): ('Dutch', '', 'Nederlands', ''),
  ('da', null): ('Danish', '', 'dansk', ''),
  ('it', null): ('Italian', '', 'italiano', ''),
};
extension LocaleNames on Locale {
  String get defaultDisplayLanguage =>
      _localeNameMap[(languageCode, countryCode)]!.$1;
  String get defaultDisplayCountry =>
      _localeNameMap[(languageCode, countryCode)]!.$2;
  String get nativeDisplayLanguage =>
      _localeNameMap[(languageCode, countryCode)]!.$3;
  String get nativeDisplayCountry =>
      _localeNameMap[(languageCode, countryCode)]!.$4;
}
