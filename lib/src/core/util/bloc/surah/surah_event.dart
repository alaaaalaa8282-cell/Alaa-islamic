part of 'surah_bloc.dart';

abstract class SurahEvent extends Equatable {
  const SurahEvent();
}

class FetchSurah extends SurahEvent {
  const FetchSurah();

  @override
  List<Object> get props => [];
}
