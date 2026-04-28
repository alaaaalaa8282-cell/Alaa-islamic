import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../audio/quran_audio_catalog.dart';

part 'quran_theme_event.dart';
part 'quran_theme_state.dart';

String _defaultTranslationFontForMode(String mode) {
  switch (mode) {
    case 'Urdu':
      return 'Jameel';
    case 'English (Saheeh)':
    case 'English (Clear Quran)':
      return 'Poppins';
    case 'Turkish (Saheeh)':
    case 'Persian (Hussein Dari)':
    case 'Russian (Kuliev)':
      return 'Roboto';
    case 'Malayalam (Abdul Hameed)':
    case 'Bengali':
    case 'Indonesian':
      return 'Noto Sans';
    case 'French (Hamidullah)':
    case 'Italian (Piccardo)':
    case 'Portuguese':
    case 'Spanish':
      return 'Lato';
    case 'Dutch (Siregar)':
    case 'Chinese':
    case 'Swedish':
      return 'Montserrat';
    default:
      return 'Poppins';
  }
}

class QuranThemeBloc extends HydratedBloc<QuranThemeEvent, QuranThemeState> {
  QuranThemeBloc()
      : super(
          QuranThemeState(
            quranType: 'Normal',
            showTranslation: true,
            translationMode: 'English (Clear Quran)',
            quranFontSize: 24,
            quranFontFamily: 'Uthman',
            translationFontSize: 16,
            translationFontFamily: 'Poppins',
            qcfScrollDirection: 'Vertical',
            audioEdition: 'ar.alafasy',
            audioBitrate: 128,
          ),
        ) {
    on<QuranThemeEvent>((event, emit) async {
      if (event is SetQuranType) {
        emit(QuranThemeState(
          quranType: event.type,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: event.type == 'QCF' ? 'qcf' : 'Uthman',
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is ShowTranslation) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: event.show,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is SwitchTranslationMode) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: event.mode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: _defaultTranslationFontForMode(event.mode),
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is SetAudioEdition) {
        final matched = findQuranAudioById(event.edition);
        final bitrate = matched?.quality ?? state.audioBitrate;
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: event.edition,
          audioBitrate: bitrate,
        ));
      }
      if (event is SetAudioBitrate) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: event.bitrate,
        ));
      }
      if (event is AddQuranFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize + 1,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is ReduceQuranFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize - 1,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is SetQuranFontFamily) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: event.family,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is AddTranslationFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize + 1,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is ReduceTranslationFontSize) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize - 1,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is SetTranslationFontFamily) {
        final safeFontFamily = state.translationMode == 'Urdu'
            ? 'Jameel'
            : event.family;
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: safeFontFamily,
          qcfScrollDirection: state.qcfScrollDirection,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
      if (event is SetQcfScrollDirection) {
        emit(QuranThemeState(
          quranType: state.quranType,
          showTranslation: state.showTranslation,
          translationMode: state.translationMode,
          quranFontSize: state.quranFontSize,
          quranFontFamily: state.quranFontFamily,
          translationFontSize: state.translationFontSize,
          translationFontFamily: state.translationFontFamily,
          qcfScrollDirection: event.direction,
          audioEdition: state.audioEdition,
          audioBitrate: state.audioBitrate,
        ));
      }
    });
  }

  Stream<QuranThemeState> mapEventToState(
    QuranThemeEvent event,
  ) async* {}

  @override
  QuranThemeState? fromJson(Map<String, dynamic> json) {
    try {
      final mode = json['translationMode'].toString();
      final savedFamily = json['translationFontFamily'].toString();
      final safeFamily = mode == 'Urdu'
          ? 'Jameel'
          : (savedFamily.isEmpty
              ? _defaultTranslationFontForMode(mode)
              : savedFamily);

      return QuranThemeState(
        quranType: json['quranType']?.toString() ?? 'Normal',
        showTranslation: json['showTranslation'] as bool,
        translationMode: mode,
        quranFontSize: json['quranFontSize'] as double,
        quranFontFamily: json['quranFontFamily'].toString(),
        translationFontSize: json['translationFontSize'] as double,
        translationFontFamily: safeFamily,
        qcfScrollDirection:
            json['qcfScrollDirection']?.toString() ?? 'Vertical',
        audioEdition: json['audioEdition']?.toString() ?? 'ar.alafasy',
        audioBitrate: (json['audioBitrate'] as int?) ?? 128,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(QuranThemeState state) {
    try {
      return {
        'showTranslation': state.showTranslation,
        'quranType': state.quranType,
        'translationMode': state.translationMode,
        'quranFontSize': state.quranFontSize,
        'quranFontFamily': state.quranFontFamily,
        'translationFontSize': state.translationFontSize,
        'translationFontFamily': state.translationFontFamily,
        'qcfScrollDirection': state.qcfScrollDirection,
        'audioEdition': state.audioEdition,
        'audioBitrate': state.audioBitrate,
      };
    } catch (e) {
      return null;
    }
  }
}
