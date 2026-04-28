part of 'quran_theme_bloc.dart';

class QuranThemeState extends Equatable {
  final String quranType;
  final bool showTranslation;
  final String translationMode;
  final double quranFontSize;
  final double translationFontSize;
  final String quranFontFamily;
  final String translationFontFamily;
  final String qcfScrollDirection;
  final String audioEdition;
  final int audioBitrate;

  QuranThemeState({
    required this.quranType,
    required this.showTranslation,
    required this.translationMode,
    required this.quranFontSize,
    required this.translationFontSize,
    required this.quranFontFamily,
    required this.translationFontFamily,
    required this.qcfScrollDirection,
    required this.audioEdition,
    required this.audioBitrate,
  });

  @override
  List<Object> get props => [
        quranType,
        showTranslation,
        translationMode,
        quranFontSize,
        translationFontSize,
        quranFontFamily,
        translationFontFamily,
        qcfScrollDirection,
        audioEdition,
        audioBitrate,
      ];
}
