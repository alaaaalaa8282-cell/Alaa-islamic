import 'package:quran/quran.dart' as quran_package;

class Quran {
  final int ayatId;
  final int ayatNumber;
  final String arabicText;
  final String urduTranslation;
  final int ayatSajda;
  final int surahRuku;
  final int paraRuku;
  final int paraId;
  final int manzilNo;
  final int ayatVisible;
  final int surahId;
  final String withoutAerab;
  final int favorite;

  Quran({
    required this.ayatId,
    required this.ayatNumber,
    required this.arabicText,
    required this.urduTranslation,
    required this.ayatSajda,
    required this.surahRuku,
    required this.paraRuku,
    required this.paraId,
    required this.manzilNo,
    required this.ayatVisible,
    required this.surahId,
    required this.withoutAerab,
    required this.favorite,
  });

  Quran copyWith({
    int? favorite,
  }) {
    return Quran(
      ayatId: ayatId,
      ayatNumber: ayatNumber,
      arabicText: arabicText,
      urduTranslation: urduTranslation,
      ayatSajda: ayatSajda,
      surahRuku: surahRuku,
      paraRuku: paraRuku,
      paraId: paraId,
      manzilNo: manzilNo,
      ayatVisible: ayatVisible,
      surahId: surahId,
      withoutAerab: withoutAerab,
      favorite: favorite ?? this.favorite,
    );
  }

  static const Map<String, quran_package.Translation> translationByMode = {
    'English (Saheeh)': quran_package.Translation.enSaheeh,
    'English (Clear Quran)': quran_package.Translation.enClearQuran,
    'Turkish (Saheeh)': quran_package.Translation.trSaheeh,
    'Malayalam (Abdul Hameed)': quran_package.Translation.mlAbdulHameed,
    'Persian (Hussein Dari)': quran_package.Translation.faHusseinDari,
    'French (Hamidullah)': quran_package.Translation.frHamidullah,
    'Italian (Piccardo)': quran_package.Translation.itPiccardo,
    'Dutch (Siregar)': quran_package.Translation.nlSiregar,
    'Portuguese': quran_package.Translation.portuguese,
    'Russian (Kuliev)': quran_package.Translation.ruKuliev,
    'Urdu': quran_package.Translation.urdu,
    'Bengali': quran_package.Translation.bengali,
    'Indonesian': quran_package.Translation.indonesian,
    'Chinese': quran_package.Translation.chinese,
    'Spanish': quran_package.Translation.spanish,
    'Swedish': quran_package.Translation.swedish,
  };

  String getTranslationText(
    String translationMode, {
    int? verseNumberOverride,
  }) {
    final effectiveVerseNumber = verseNumberOverride ?? ayatNumber;
    final effectiveTranslation =
        translationByMode[translationMode] ?? quran_package.Translation.urdu;

    try {
      return quran_package.getVerseTranslation(
        surahId,
        effectiveVerseNumber,
        translation: effectiveTranslation,
      );
    } catch (_) {
      return urduTranslation;
    }
  }

  String getVerseText({
    int? verseNumberOverride,
  }) {
    final effectiveVerseNumber = verseNumberOverride ?? ayatNumber;
    return quran_package.getVerse(surahId, effectiveVerseNumber,
        verseEndSymbol: true);
  }

  int getVerseCount({
    int? surahNumber,
  }) {
    return quran_package.getVerseCount(surahId);
  }
}

class Qurans {
  List<Quran> _qurans = [];
  List<int> _favoriteAyatIdsByLatest = [];

  Qurans();

  Qurans._(List<Quran> qurans) : _qurans = qurans;

  void initializeFromPackage() {
    if (_qurans.isNotEmpty) {
      return;
    }

    int ayatIdCounter = 1;

    for (int surahId = 1; surahId <= 114; surahId++) {
      final verseCount = quran_package.getVerseCount(surahId);

      for (int ayatNumber = 1; ayatNumber <= verseCount; ayatNumber++) {
        final arabicText = quran_package.getVerse(
          surahId,
          ayatNumber,
          verseEndSymbol: true,
        );
        final urduText = quran_package.getVerseTranslation(
          surahId,
          ayatNumber,
          translation: quran_package.Translation.urdu,
        );
        final paraId = quran_package.getJuzNumber(surahId, ayatNumber);

        _qurans.add(
          Quran(
            ayatId: ayatIdCounter,
            ayatNumber: ayatNumber,
            arabicText: arabicText,
            urduTranslation: urduText,
            ayatSajda: 0,
            surahRuku: 0,
            paraRuku: 0,
            paraId: paraId,
            manzilNo: 0,
            ayatVisible: 1,
            surahId: surahId,
            withoutAerab: arabicText,
            favorite: 0,
          ),
        );
        ayatIdCounter++;
      }
    }
  }

  Qurans withFavoriteAyatIds(List<int> orderedFavoriteAyatIds) {
    final favoriteSet = orderedFavoriteAyatIds.toSet();
    final updatedQurans = _qurans
        .map(
          (quran) => quran.copyWith(
            favorite: favoriteSet.contains(quran.ayatId) ? 1 : 0,
          ),
        )
        .toList(growable: false);

    final synced = Qurans._(updatedQurans);
    synced._favoriteAyatIdsByLatest = List<int>.of(orderedFavoriteAyatIds);
    return synced;
  }

  List<Quran> getQuransBySurah(int surahId) {
    return _qurans.where((Quran quran) => quran.surahId == surahId).toList();
  }

  List<int> getAyatIdsBySurah(int surahId) {
    final items = getQuransBySurah(surahId)
      ..sort((a, b) => a.ayatId.compareTo(b.ayatId));
    return items.map((e) => e.ayatId).toList(growable: false);
  }

  List<Quran> getQuransByJuz(int id) {
    return _qurans.where((Quran quran) => quran.paraId == id).toList();
  }

  List<Quran> get getFavoritesQuran =>
      _favoriteAyatIdsByLatest
          .map(
            (ayatId) => _qurans.where((quran) => quran.ayatId == ayatId),
          )
          .where((matches) => matches.isNotEmpty)
          .map((matches) => matches.first)
          .toList();

  List<Quran> get qurans => _qurans;
}
