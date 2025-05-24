import 'dart:ui';

const _localeNameMap = {
  ('fi', null): ('Finnish', '', 'suomi', ''),
  ('fr', null): ('French', '', 'français', ''),
  ('sv', 'SE'): ('Swedish', 'Sweden', 'svenska', 'Sverige'),
  ('ca', null): ('Catalan', '', 'català', ''),
  ('da', null): ('Danish', '', 'dansk', ''),
  ('tr', null): ('Turkish', '', 'Türkçe', ''),
  ('pt', 'PT'): ('Portuguese', 'Portugal', 'português', 'Portugal'),
  ('pl', null): ('Polish', '', 'polski', ''),
  ('ko', null): ('Korean', '', '한국어', ''),
  ('no', null): ('Norwegian', '', 'norsk', ''),
  ('nl', null): ('Dutch', '', 'Nederlands', ''),
  ('ar', null): ('Arabic', '', 'العربية', ''),
  ('zh', 'TW'): ('Chinese', 'Taiwan', '中文', '台灣'),
  ('de', null): ('German', '', 'Deutsch', ''),
  ('it', null): ('Italian', '', 'italiano', ''),
  ('ro', null): ('Romanian', '', 'română', ''),
  ('af', null): ('Afrikaans', '', 'Afrikaans', ''),
  ('he', null): ('Hebrew', '', 'עברית', ''),
  ('ja', null): ('Japanese', '', '日本語', ''),
  ('en', null): ('English', '', 'English', ''),
  ('uk', null): ('Ukrainian', '', 'українська', ''),
  ('pt', 'BR'): ('Portuguese', 'Brazil', 'português', 'Brasil'),
  ('vi', null): ('Vietnamese', '', 'Tiếng Việt', ''),
  ('el', null): ('Greek', '', 'Ελληνικά', ''),
  ('zh', 'CN'): ('Chinese', 'China', '中文', '中国'),
  ('sr', null): ('Serbian', '', 'српски', ''),
  ('hu', null): ('Hungarian', '', 'magyar', ''),
  ('ru', null): ('Russian', '', 'русский', ''),
  ('es', 'ES'): ('Spanish', 'Spain', 'español', 'España'),
  ('cs', null): ('Czech', '', 'čeština', ''),
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
