// ignore_for_file: unused_element

part of 'quran_audio_bloc.dart';

abstract class QuranAudioEvent extends Equatable {
  const QuranAudioEvent();
}

class PlayAyah extends QuranAudioEvent {
  final int ayatId;
  final int surahId;
  final String edition;
  final int bitrate;
  const PlayAyah({
    required this.ayatId,
    required this.surahId,
    required this.edition,
    required this.bitrate,
  });

  @override
  List<Object> get props => [ayatId, surahId, edition, bitrate];
}

class ToggleAyahPlayPause extends QuranAudioEvent {
  final int ayatId;
  final int surahId;
  final String edition;
  final int bitrate;
  const ToggleAyahPlayPause({
    required this.ayatId,
    required this.surahId,
    required this.edition,
    required this.bitrate,
  });

  @override
  List<Object> get props => [ayatId, surahId, edition, bitrate];
}

class PlaySurah extends QuranAudioEvent {
  final int surahId;
  final List<int> ayatIds;
  final String edition;
  final int bitrate;
  const PlaySurah({
    required this.surahId,
    required this.ayatIds,
    required this.edition,
    required this.bitrate,
  });

  @override
  List<Object> get props => [surahId, ayatIds, edition, bitrate];
}

class TogglePlayPause extends QuranAudioEvent {
  const TogglePlayPause();
  @override
  List<Object> get props => [];
}

class StopAudio extends QuranAudioEvent {
  const StopAudio();
  @override
  List<Object> get props => [];
}

class ClearAudioError extends QuranAudioEvent {
  const ClearAudioError();
  @override
  List<Object> get props => [];
}

class _InternalTrackChanged extends QuranAudioEvent {
  final int currentAyatId;
  const _InternalTrackChanged(this.currentAyatId);

  @override
  List<Object> get props => [currentAyatId];
}

class _InternalPlayerStateChanged extends QuranAudioEvent {
  final QuranAudioStatus status;
  const _InternalPlayerStateChanged(this.status);

  @override
  List<Object> get props => [status];
}

class _InternalError extends QuranAudioEvent {
  final String message;
  const _InternalError(this.message);

  @override
  List<Object> get props => [message];
}

