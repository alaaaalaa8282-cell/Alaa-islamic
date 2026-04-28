part of 'allah_name_bloc.dart';

class AllahNameState extends Equatable {
  final List<NameOfAllah> allahNames;
  const AllahNameState(this.allahNames);

  @override
  List<Object> get props => [allahNames];
}
