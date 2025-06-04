import 'dart:ui';

const _localeNameMap = {
  ('es', 'ES'): ('Spanish', 'Spain', 'español', 'España'),
  ('uk', null): ('Ukrainian', '', 'українська', ''),
  ('vi', null): ('Vietnamese', '', 'Tiếng Việt', ''),
  ('cs', null): ('Czech', '', 'čeština', ''),
  ('tr', null): ('Turkish', '', 'Türkçe', ''),
  ('fi', null): ('Finnish', '', 'suomi', ''),
  ('he', null): ('Hebrew', '', 'עברית', ''),
  ('ar', null): ('Arabic', '', 'العربية', ''),
  ('zh', 'TW'): ('Chinese', 'Taiwan', '中文', '台灣'),
  ('ro', null): ('Romanian', '', 'română', ''),
  ('ru', null): ('Russian', '', 'русский', ''),
  ('pt', 'BR'): ('Portuguese', 'Brazil', 'português', 'Brasil'),
  ('ja', null): ('Japanese', '', '日本語', ''),
  ('af', null): ('Afrikaans', '', 'Afrikaans', ''),
  ('pl', null): ('Polish', '', 'polski', ''),
  ('zh', 'CN'): ('Chinese', 'China', '中文', '中国'),
  ('hu', null): ('Hungarian', '', 'magyar', ''),
  ('en', null): ('English', '', 'English', ''),
  ('pt', 'PT'): ('Portuguese', 'Portugal', 'português', 'Portugal'),
  ('sv', 'SE'): ('Swedish', 'Sweden', 'svenska', 'Sverige'),
  ('ca', null): ('Catalan', '', 'català', ''),
  ('ko', null): ('Korean', '', '한국어', ''),
  ('el', null): ('Greek', '', 'Ελληνικά', ''),
  ('it', null): ('Italian', '', 'italiano', ''),
  ('sr', null): ('Serbian', '', 'српски', ''),
  ('nl', null): ('Dutch', '', 'Nederlands', ''),
  ('de', null): ('German', '', 'Deutsch', ''),
  ('no', null): ('Norwegian', '', 'norsk', ''),
  ('da', null): ('Danish', '', 'dansk', ''),
  ('fr', null): ('French', '', 'français', ''),
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
