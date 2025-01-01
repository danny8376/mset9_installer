import 'dart:ui';

const _localeNameMap = {
  ('de', null): ('German', '', 'Deutsch', ''),
  ('ro', null): ('Romanian', '', 'română', ''),
  ('fi', null): ('Finnish', '', 'suomi', ''),
  ('pt', 'PT'): ('Portuguese', 'Portugal', 'português', 'Portugal'),
  ('sv', 'SE'): ('Swedish', 'Sweden', 'svenska', 'Sverige'),
  ('he', null): ('Hebrew', '', 'עברית', ''),
  ('hu', null): ('Hungarian', '', 'magyar', ''),
  ('es', 'ES'): ('Spanish', 'Spain', 'español', 'España'),
  ('ko', null): ('Korean', '', '한국어', ''),
  ('ar', null): ('Arabic', '', 'العربية', ''),
  ('da', null): ('Danish', '', 'dansk', ''),
  ('pl', null): ('Polish', '', 'polski', ''),
  ('el', null): ('Greek', '', 'Ελληνικά', ''),
  ('cs', null): ('Czech', '', 'čeština', ''),
  ('no', null): ('Norwegian', '', 'norsk', ''),
  ('zh', 'TW'): ('Chinese', 'Taiwan', '中文', '台灣'),
  ('zh', 'CN'): ('Chinese', 'China', '中文', '中国'),
  ('vi', null): ('Vietnamese', '', 'Tiếng Việt', ''),
  ('ja', null): ('Japanese', '', '日本語', ''),
  ('it', null): ('Italian', '', 'italiano', ''),
  ('af', null): ('Afrikaans', '', 'Afrikaans', ''),
  ('fr', null): ('French', '', 'français', ''),
  ('ru', null): ('Russian', '', 'русский', ''),
  ('uk', null): ('Ukrainian', '', 'українська', ''),
  ('nl', null): ('Dutch', '', 'Nederlands', ''),
  ('tr', null): ('Turkish', '', 'Türkçe', ''),
  ('sr', null): ('Serbian', '', 'српски', ''),
  ('pt', 'BR'): ('Portuguese', 'Brazil', 'português', 'Brasil'),
  ('ca', null): ('Catalan', '', 'català', ''),
  ('en', null): ('English', '', 'English', ''),
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
