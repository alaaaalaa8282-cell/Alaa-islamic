import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class QuranReadingState extends Equatable {
  final String? lastMode; // 'surah' | 'juz'
  final int? lastSurahId;
  final int? lastJuzId;
  final int? lastAyatId;

  const QuranReadingState({
    this.lastMode,
    this.lastSurahId,
    this.lastJuzId,
    this.lastAyatId,
  });

  bool get hasLastReading =>
      lastMode != null &&
      lastAyatId != null &&
      (lastSurahId != null || lastJuzId != null);

  @override
  List<Object?> get props => [lastMode, lastSurahId, lastJuzId, lastAyatId];
}

class QuranReadingCubit extends HydratedCubit<QuranReadingState> {
  QuranReadingCubit() : super(const QuranReadingState());

  void saveSurahReading({
    required int surahId,
    required int ayatId,
  }) {
    emit(
      QuranReadingState(
        lastMode: 'surah',
        lastSurahId: surahId,
        lastJuzId: null,
        lastAyatId: ayatId,
      ),
    );
  }

  void saveJuzReading({
    required int juzId,
    required int ayatId,
  }) {
    emit(
      QuranReadingState(
        lastMode: 'juz',
        lastSurahId: null,
        lastJuzId: juzId,
        lastAyatId: ayatId,
      ),
    );
  }

  void reset() {
    emit(const QuranReadingState());
  }

  @override
  QuranReadingState? fromJson(Map<String, dynamic> json) {
    try {
      final lastMode = json['lastMode']?.toString();
      final lastSurahId = json['lastSurahId'] as int?;
      final lastJuzId = json['lastJuzId'] as int?;
      final lastAyatId = json['lastAyatId'] as int?;

      if (lastMode == null || lastAyatId == null) {
        return const QuranReadingState();
      }

      return QuranReadingState(
        lastMode: lastMode,
        lastSurahId: lastSurahId,
        lastJuzId: lastJuzId,
        lastAyatId: lastAyatId,
      );
    } catch (_) {
      return const QuranReadingState();
    }
  }

  @override
  Map<String, dynamic>? toJson(QuranReadingState state) {
    if (!state.hasLastReading) return null;

    return {
      'lastMode': state.lastMode,
      'lastSurahId': state.lastSurahId,
      'lastJuzId': state.lastJuzId,
      'lastAyatId': state.lastAyatId,
    };
  }
}
