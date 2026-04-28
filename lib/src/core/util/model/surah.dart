import 'package:quran/quran.dart' as quran_package;

class Surah {
  final int id;
  final String nameEn;
  final String nameAr;
  final int ayats;
  final String place;

  Surah({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.ayats,
    required this.place,
  });
}

class Surahs {
  final List<Surah> _surahs = [];

  void initializeFromPackage() {
    if (_surahs.isNotEmpty) {
      return;
    }

    for (int surahId = 1; surahId <= 114; surahId++) {
      final String placeRaw = quran_package.getPlaceOfRevelation(surahId);
      final String place = _normalizePlace(placeRaw);

      _surahs.add(
        Surah(
          id: surahId,
          nameEn: quran_package.getSurahNameEnglish(surahId),
          nameAr: quran_package.getSurahNameArabic(surahId),
          ayats: quran_package.getVerseCount(surahId),
          place: place,
        ),
      );
    }
  }

  String _normalizePlace(String raw) {
    final lower = raw.trim().toLowerCase();
    if (lower.contains('medina') || lower.contains('madina')) {
      return 'Madina';
    }
    return 'Makki';
  }

  List<Surah> get surahs => _surahs;
}
