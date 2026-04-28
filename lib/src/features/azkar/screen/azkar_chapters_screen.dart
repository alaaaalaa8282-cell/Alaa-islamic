import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../utils/loading_widget.dart';
import '../cubit/azkar_chapters_cubit.dart';
import '../cubit/azkar_categories_cubit.dart';
import 'azkar_items_screen.dart';

class AzkarChaptersScreen extends StatelessWidget {
  const AzkarChaptersScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.language,
  });

  final int categoryId;
  final String categoryTitle;
  final Language language;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarChaptersCubit(
        categoryId: categoryId,
        categoryTitle: categoryTitle,
        language: language,
      )..load(),
      child: const _AzkarChaptersView(),
    );
  }
}

class _AzkarChaptersView extends StatelessWidget {
  const _AzkarChaptersView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarChaptersCubit, AzkarChaptersState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.categoryTitle),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.status == AzkarLoadStatus.loading ||
                    state.status == AzkarLoadStatus.initial) {
                  return const LoadingWidget();
                }
                if (state.status == AzkarLoadStatus.error) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Something went wrong.',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (state.chapters.isEmpty) {
                  return Center(
                    child: Text(
                      'No chapters found.',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: state.chapters.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final chapter = state.chapters[index];
                    final title = chapter.name;

                    return ListTile(
                      title: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AzkarItemsScreen(
                              chapterId: chapter.id,
                              chapterTitle: title,
                              language: state.language,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

