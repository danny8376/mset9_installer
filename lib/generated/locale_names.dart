import 'dart:ui';

const _localeNameMap = {
  ('af', null): ('Afrikaans', '', 'Afrikaans', ''),
  ('ar', null): ('Arabic', '', 'العربية', ''),
  ('ca', null): ('Catalan', '', 'català', ''),
  ('cs', null): ('Czech', '', 'čeština', ''),
  ('da', null): ('Danish', '', 'dansk', ''),
  ('de', null): ('German', '', 'Deutsch', ''),
  ('el', null): ('Greek', '', 'Ελληνικά', ''),
  ('en', null): ('English', '', 'English', ''),
  ('es', 'ES'): ('Spanish', 'Spain', 'español', 'España'),
  ('fi', null): ('Finnish', '', 'suomi', ''),
  ('fr', null): ('French', '', 'français', ''),
  ('he', null): ('Hebrew', '', 'עברית', ''),
  ('hu', null): ('Hungarian', '', 'magyar', ''),
  ('it', null): ('Italian', '', 'italiano', ''),
  ('ja', null): ('Japanese', '', '日本語', ''),
  ('ko', null): ('Korean', '', '한국어', ''),
  ('nl', null): ('Dutch', '', 'Nederlands', ''),
  ('no', null): ('Norwegian', '', 'norsk', ''),
  ('pl', null): ('Polish', '', 'polski', ''),
  ('pt', 'BR'): ('Portuguese', 'Brazil', 'português', 'Brasil'),
  ('pt', 'PT'): ('Portuguese', 'Portugal', 'português', 'Portugal'),
  ('ro', null): ('Romanian', '', 'română', ''),
  ('ru', null): ('Russian', '', 'русский', ''),
  ('sr', null): ('Serbian', '', 'српски', ''),
  ('sv', 'SE'): ('Swedish', 'Sweden', 'svenska', 'Sverige'),
  ('tr', null): ('Turkish', '', 'Türkçe', ''),
  ('uk', null): ('Ukrainian', '', 'українська', ''),
  ('vi', null): ('Vietnamese', '', 'Tiếng Việt', ''),
  ('zh', 'CN'): ('Chinese', 'China', '中文', '中国'),
  ('zh', 'TW'): ('Chinese', 'Taiwan', '中文', '台灣'),
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
