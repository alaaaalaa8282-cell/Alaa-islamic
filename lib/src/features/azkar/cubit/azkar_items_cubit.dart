import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../repository/azkar_repository.dart';
import 'azkar_categories_cubit.dart';

class AzkarItemsState extends Equatable {
  final AzkarLoadStatus status;
  final Language language;
  final int chapterId;
  final String chapterTitle;
  final List<AzkarItem> items;
  final String? errorMessage;

  const AzkarItemsState({
    required this.status,
    required this.language,
    required this.chapterId,
    required this.chapterTitle,
    required this.items,
    this.errorMessage,
  });

  factory AzkarItemsState.initial({
    required int chapterId,
    required String chapterTitle,
    required Language language,
  }) =>
      AzkarItemsState(
        status: AzkarLoadStatus.initial,
        language: language,
        chapterId: chapterId,
        chapterTitle: chapterTitle,
        items: const [],
      );

  AzkarItemsState copyWith({
    AzkarLoadStatus? status,
    List<AzkarItem>? items,
    String? errorMessage,
  }) {
    return AzkarItemsState(
      status: status ?? this.status,
      language: language,
      chapterId: chapterId,
      chapterTitle: chapterTitle,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, language, chapterId, chapterTitle, items, errorMessage];
}

class AzkarItemsCubit extends Cubit<AzkarItemsState> {
  AzkarItemsCubit({
    required int chapterId,
    required String chapterTitle,
    required Language language,
    AzkarRepository? repository,
  })  : _repository = repository ?? AzkarRepository(),
        super(
          AzkarItemsState.initial(
            chapterId: chapterId,
            chapterTitle: chapterTitle,
            language: language,
          ),
        );

  final AzkarRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: AzkarLoadStatus.loading, errorMessage: null));
    try {
      final items = await _repository.getItems(
        language: state.language,
        chapterId: state.chapterId,
      );
      emit(state.copyWith(status: AzkarLoadStatus.loaded, items: items));
    } catch (_) {
      emit(state.copyWith(
        status: AzkarLoadStatus.error,
        errorMessage: 'Unable to load Azkars right now.',
      ));
    }
  }
}

