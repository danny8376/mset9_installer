import 'dart:ui';

const _localeNameMap = {
  ('en', null): ('English', '', 'English', ''),
  ('zh', 'TW'): ('Chinese', 'Taiwan', '中文', '台灣'),
  ('ja', null): ('Japanese', '', '日本語', ''),
  ('sr', null): ('Serbian', '', 'српски', ''),
  ('es', 'ES'): ('Spanish', 'Spain', 'español', 'España'),
  ('fr', null): ('French', '', 'français', ''),
  ('pt', 'BR'): ('Portuguese', 'Brazil', 'português', 'Brasil'),
  ('ar', null): ('Arabic', '', 'العربية', ''),
  ('ko', null): ('Korean', '', '한국어', ''),
  ('el', null): ('Greek', '', 'Ελληνικά', ''),
  ('it', null): ('Italian', '', 'italiano', ''),
  ('da', null): ('Danish', '', 'dansk', ''),
  ('pt', 'PT'): ('Portuguese', 'Portugal', 'português', 'Portugal'),
  ('cs', null): ('Czech', '', 'čeština', ''),
  ('ro', null): ('Romanian', '', 'română', ''),
  ('uk', null): ('Ukrainian', '', 'українська', ''),
  ('af', null): ('Afrikaans', '', 'Afrikaans', ''),
  ('no', null): ('Norwegian', '', 'norsk', ''),
  ('vi', null): ('Vietnamese', '', 'Tiếng Việt', ''),
  ('ca', null): ('Catalan', '', 'català', ''),
  ('pl', null): ('Polish', '', 'polski', ''),
  ('zh', 'CN'): ('Chinese', 'China', '中文', '中国'),
  ('sv', 'SE'): ('Swedish', 'Sweden', 'svenska', 'Sverige'),
  ('de', null): ('German', '', 'Deutsch', ''),
  ('fi', null): ('Finnish', '', 'suomi', ''),
  ('tr', null): ('Turkish', '', 'Türkçe', ''),
  ('ru', null): ('Russian', '', 'русский', ''),
  ('nl', null): ('Dutch', '', 'Nederlands', ''),
  ('he', null): ('Hebrew', '', 'עברית', ''),
  ('hu', null): ('Hungarian', '', 'magyar', ''),
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
