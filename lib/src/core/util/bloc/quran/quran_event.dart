part of 'quran_bloc.dart';

abstract class QuranEvent extends Equatable {
  const QuranEvent();
}

class FetchQuran extends QuranEvent {
  final List<int> favoriteAyatIds;

  const FetchQuran({
    this.favoriteAyatIds = const [],
  });

  @override
  List<Object> get props => [favoriteAyatIds];
}

class SyncQuranFavorites extends QuranEvent {
  final List<int> favoriteAyatIds;

  const SyncQuranFavorites(this.favoriteAyatIds);

  @override
  List<Object> get props => [favoriteAyatIds];
}
