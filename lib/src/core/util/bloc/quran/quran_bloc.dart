import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/quran.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  QuranBloc() : super(QuranState(Qurans())) {
    on<QuranEvent>((event, emit) async {
      if (event is FetchQuran) {
        state.qurans.initializeFromPackage();
        final syncedQurans = state.qurans.withFavoriteAyatIds(
          event.favoriteAyatIds,
        );

        emit(QuranState(syncedQurans));
      }
      if (event is SyncQuranFavorites) {
        final updatedQurans =
            state.qurans.withFavoriteAyatIds(event.favoriteAyatIds);

        emit(QuranState(updatedQurans));
      }
    });
  }
}
