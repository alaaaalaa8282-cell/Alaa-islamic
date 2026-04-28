import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    show AlignedGridView;
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../../core/util/constants.dart';
import '../../utils/bottom_sheet_select.dart';
import '../../utils/loading_widget.dart';
import '../cubit/azkar_categories_cubit.dart';
import '../widget/azkar_language.dart';
import 'azkar_chapters_screen.dart';


class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarCategoriesCubit()..load(),
      child: const _AzkarView(),
    );
  }
}

class _AzkarView extends StatelessWidget {
  const _AzkarView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Azkars (Hisnul Muslim)'),
          ),
          body: SafeArea(
            child: Padding(
              padding: kPagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AzkarLanguageRow(
                    value: azkarSupportedLanguages.contains(state.language)
                        ? state.language
                        : azkarSupportedLanguages.first,
                    onChanged: (lang) {
                      context.read<AzkarCategoriesCubit>().load(language: lang);
                    },
                  ),
                  const Divider(),
                  Expanded(
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

                        if (state.categories.isEmpty) {
                          return Center(
                            child: Text(
                              'No Azkar categories available.',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          );
                        }

                        return AlignedGridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.w,
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            final title = category.name;

                            return SizedBox(
                              height: kCategoryTileHeight.h,
                              child: _AzkarCategoryTile(
                                title: title,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AzkarChaptersScreen(
                                        categoryId: category.id,
                                        categoryTitle: title,
                                        language: state.language,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          itemCount: state.categories.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AzkarLanguageRow extends StatelessWidget {
  const _AzkarLanguageRow({
    required this.value,
    required this.onChanged,
  });

  final Language value;
  final ValueChanged<Language> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Language',
            style: theme.textTheme.titleLarge?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          BottomSheetSelect<Language>(
            dense: true,
            shrinkWrapWidth: true,
            label: '',
            value: value,
            options: azkarSupportedLanguages,
            optionLabelBuilder: azkarLanguageLabel,
            selectedLabelBuilder: azkarLanguageLabel,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _AzkarCategoryTile extends StatelessWidget {
  const _AzkarCategoryTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final bg = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : primary.withValues(alpha: 0.10);
    final borderColor =
        isDark ? Colors.white.withValues(alpha: 0.08) : primary.withValues(alpha: 0.16);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? null : primary.withValues(alpha: 0.85),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

