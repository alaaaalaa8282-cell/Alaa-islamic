part of 'quran_audio_bloc.dart';

enum QuranAudioStatus { idle, loading, playing, paused, stopped, error }

enum QuranAudioMode { none, ayah, surah }

class QuranAudioState extends Equatable {
  final QuranAudioStatus status;
  final QuranAudioMode mode;
  final int? currentSurahId;
  final int? currentAyatId;
  final List<int> playlistAyatIds;
  final String? errorMessage;

  const QuranAudioState({
    this.status = QuranAudioStatus.idle,
    this.mode = QuranAudioMode.none,
    this.currentSurahId,
    this.currentAyatId,
    this.playlistAyatIds = const [],
    this.errorMessage,
  });

  QuranAudioState copyWith({
    QuranAudioStatus? status,
    QuranAudioMode? mode,
    int? currentSurahId,
    int? currentAyatId,
    List<int>? playlistAyatIds,
    String? errorMessage,
  }) {
    return QuranAudioState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentAyatId: currentAyatId ?? this.currentAyatId,
      playlistAyatIds: playlistAyatIds ?? this.playlistAyatIds,
      errorMessage: errorMessage,
    );
  }

  bool get isActive =>
      status == QuranAudioStatus.loading ||
      status == QuranAudioStatus.playing ||
      status == QuranAudioStatus.paused;

  @override
  List<Object?> get props => [
        status,
        mode,
        currentSurahId,
        currentAyatId,
        playlistAyatIds,
        errorMessage,
      ];
}

