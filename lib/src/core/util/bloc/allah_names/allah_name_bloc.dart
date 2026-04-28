import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

part 'allah_name_event.dart';
part 'allah_name_state.dart';

class AllahNameBloc extends Bloc<AllahNameEvent, AllahNameState> {
  AllahNameBloc() : super(AllahNameState([])) {
    on<AllahNameEvent>((event, emit) async {
      if (event is FetchAllahName) {
        final muslimRepo = MuslimRepository();
        final names = await muslimRepo.getNames(language: Language.en);
        emit(AllahNameState(names));
      }
    });
  }
}
