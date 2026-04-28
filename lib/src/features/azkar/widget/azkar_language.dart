import 'package:muslim_data_flutter/muslim_data_flutter.dart';

const List<Language> azkarSupportedLanguages = [
  Language.en,
  Language.ar,
  Language.ckb,
  Language.ckbBadini,
  Language.fa,
  Language.ru,
];

String azkarLanguageLabel(Language language) {
  switch (language) {
    case Language.en:
      return 'English';
    case Language.ar:
      return 'Arabic';
    case Language.ckb:
      return 'Kurdish (Sorani)';
    case Language.ckbBadini:
      return 'Kurdish (Badini)';
    case Language.fa:
      return 'Persian';
    case Language.ru:
      return 'Russian';
    default:
      return language.name.toUpperCase();
  }
}

