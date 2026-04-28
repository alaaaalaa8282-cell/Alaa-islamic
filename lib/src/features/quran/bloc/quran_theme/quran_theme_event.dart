part of 'quran_theme_bloc.dart';

abstract class QuranThemeEvent extends Equatable {
  const QuranThemeEvent();
}

class SetQuranType extends QuranThemeEvent {
  final String type;

  SetQuranType(this.type);

  @override
  List<Object> get props => [type];
}

class ShowTranslation extends QuranThemeEvent {
  final bool show;

  ShowTranslation(this.show);

  @override
  List<Object> get props => [show];
}

class SwitchTranslationMode extends QuranThemeEvent {
  final String mode;

  SwitchTranslationMode(this.mode);

  @override
  List<Object> get props => [mode];
}

class SetAudioEdition extends QuranThemeEvent {
  final String edition;
  const SetAudioEdition(this.edition);

  @override
  List<Object> get props => [edition];
}

class SetAudioBitrate extends QuranThemeEvent {
  final int bitrate;
  const SetAudioBitrate(this.bitrate);

  @override
  List<Object> get props => [bitrate];
}

class AddQuranFontSize extends QuranThemeEvent {
  AddQuranFontSize();

  @override
  List<Object> get props => [];
}

class ReduceQuranFontSize extends QuranThemeEvent {
  ReduceQuranFontSize();

  @override
  List<Object> get props => [];
}

class SetQuranFontFamily extends QuranThemeEvent {
  final String family;

  SetQuranFontFamily(this.family);

  @override
  List<Object> get props => [family];
}

class AddTranslationFontSize extends QuranThemeEvent {
  AddTranslationFontSize();

  @override
  List<Object> get props => [];
}

class ReduceTranslationFontSize extends QuranThemeEvent {
  ReduceTranslationFontSize();

  @override
  List<Object> get props => [];
}

class SetTranslationFontFamily extends QuranThemeEvent {
  final String family;

  SetTranslationFontFamily(this.family);

  @override
  List<Object> get props => [family];
}

class SetQcfScrollDirection extends QuranThemeEvent {
  final String direction;

  SetQcfScrollDirection(this.direction);

  @override
  List<Object> get props => [direction];
}
