import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../repository/azkar_repository.dart';

enum AzkarLoadStatus { initial, loading, loaded, error }

class AzkarCategoriesState extends Equatable {
  final AzkarLoadStatus status;
  final Language language;
  final List<AzkarCategory> categories;
  final String? errorMessage;

  const AzkarCategoriesState({
    required this.status,
    required this.language,
    required this.categories,
    this.errorMessage,
  });

  factory AzkarCategoriesState.initial() => const AzkarCategoriesState(
        status: AzkarLoadStatus.initial,
        language: Language.en,
        categories: [],
      );

  AzkarCategoriesState copyWith({
    AzkarLoadStatus? status,
    Language? language,
    List<AzkarCategory>? categories,
    String? errorMessage,
  }) {
    return AzkarCategoriesState(
      status: status ?? this.status,
      language: language ?? this.language,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, language, categories, errorMessage];
}

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit({AzkarRepository? repository})
      : _repository = repository ?? AzkarRepository(),
        super(AzkarCategoriesState.initial());

  final AzkarRepository _repository;

  Future<void> load({Language? language}) async {
    final nextLanguage = language ?? state.language;
    emit(state.copyWith(
      status: AzkarLoadStatus.loading,
      language: nextLanguage,
      errorMessage: null,
    ));

    try {
      final categories =
          await _repository.getCategories(language: nextLanguage);
      emit(state.copyWith(
        status: AzkarLoadStatus.loaded,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AzkarLoadStatus.error,
        errorMessage: 'Unable to load Azkars right now.',
      ));
    }
  }
}

