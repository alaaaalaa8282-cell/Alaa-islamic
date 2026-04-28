import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../../core/util/constants.dart';
import '../../utils/loading_widget.dart';
import '../cubit/azkar_items_cubit.dart';
import '../cubit/azkar_categories_cubit.dart';

class AzkarItemsScreen extends StatelessWidget {
  const AzkarItemsScreen({
    super.key,
    required this.chapterId,
    required this.chapterTitle,
    required this.language,
  });

  final int chapterId;
  final String chapterTitle;
  final Language language;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarItemsCubit(
        chapterId: chapterId,
        chapterTitle: chapterTitle,
        language: language,
      )..load(),
      child: const _AzkarItemsView(),
    );
  }
}

class _AzkarItemsView extends StatelessWidget {
  const _AzkarItemsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarItemsCubit, AzkarItemsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.chapterTitle),
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

                if (state.items.isEmpty) {
                  return Center(
                    child: Text(
                      'No Azkars found.',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }

                return ListView.separated(
                  padding: kPagePadding,
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    final arabic = item.item;
                    final translation = item.translation;
                    final reference = item.reference;

                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1.1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (arabic.isNotEmpty)
                            Text(
                              arabic,
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontFamily: 'Uthman',
                                    height: 1.6,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          if (arabic.isNotEmpty && translation.isNotEmpty)
                            SizedBox(height: 10.h),
                          if (translation.isNotEmpty)
                            Text(
                              translation,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.4,
                                  ),
                            ),
                          if (reference.isNotEmpty) ...[
                            SizedBox(height: 10.h),
                            Text(
                              reference,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.75),
                                  ),
                            ),
                          ],
                        ],
                      ),
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

