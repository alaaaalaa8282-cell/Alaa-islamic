import 'package:muslim_data_flutter/muslim_data_flutter.dart';

class AzkarRepository {
  AzkarRepository({MuslimRepository? repo}) : _repo = repo ?? MuslimRepository();

  final MuslimRepository _repo;

  Future<List<AzkarCategory>> getCategories({
    required Language language,
  }) async {
    return await _repo.getAzkarCategories(language: language);
  }

  Future<List<AzkarChapter>> getChapters({
    required Language language,
    required int categoryId,
  }) async {
    return await _repo.getAzkarChapters(
      language: language,
      categoryId: categoryId,
    );
  }

  Future<List<AzkarItem>> getItems({
    required Language language,
    required int chapterId,
  }) async {
    return await _repo.getAzkarItems(
      language: language,
      chapterId: chapterId,
    );
  }
}

