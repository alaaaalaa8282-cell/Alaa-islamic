part of 'allah_name_bloc.dart';

abstract class AllahNameEvent extends Equatable {
  const AllahNameEvent();
}

class FetchAllahName extends AllahNameEvent {
  FetchAllahName();

  @override
  List<Object> get props => [];
}
