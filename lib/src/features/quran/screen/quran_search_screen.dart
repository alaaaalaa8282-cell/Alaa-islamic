import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/juz/juz_bloc.dart';
import '../../../core/util/bloc/surah/surah_bloc.dart';
import '../../../core/util/constants.dart';
import '../widget/juz_card.dart';
import '../widget/surah_card.dart';

class QuranSearchScreen extends StatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  State<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends State<QuranSearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  void _clear() {
    _controller.clear();
    setState(() => _query = '');
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Quran'),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52.h),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
              child: Container(
                height: 42.h,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : primary.withValues(alpha: 0.12),
                  ),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  dividerColor: Colors.transparent,
                  labelColor: primary,
                  unselectedLabelColor:
                      theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(height: double.infinity, text: 'Surah'),
                    Tab(height: double.infinity, text: 'Juz'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: (v) => setState(() => _query = v.trim()),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search by name, number, place…',
                      prefixIcon: Icon(Icons.search, color: primary),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _clear,
                              icon: Icon(Icons.close, color: primary),
                            ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Expanded(
                child: TabBarView(
                  children: [
                    _SurahSearchTab(query: _query),
                    _JuzSearchTab(query: _query),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahSearchTab extends StatelessWidget {
  const _SurahSearchTab({required this.query});
  final String query;

  bool _matches(String haystack, String q) =>
      haystack.toLowerCase().contains(q.toLowerCase());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurahBloc, SurahState>(
      builder: (context, state) {
        final surahs = state.surahs.surahs;
        final q = query.trim();

        final indices = <int>[];
        for (var i = 0; i < surahs.length; i++) {
          final s = surahs[i];
          if (q.isEmpty ||
              _matches(s.nameEn, q) ||
              _matches(s.nameAr, q) ||
              _matches(s.place, q) ||
              _matches('${s.id}', q)) {
            indices.add(i);
          }
        }

        if (indices.isEmpty) {
          return _SearchEmptyState(
            title: q.isEmpty ? 'Search Surahs' : 'No results',
            subtitle: q.isEmpty
                ? 'Type a Surah name (English/Arabic) or number.'
                : 'Nothing matched “$q”. Try a different spelling.',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 16.h),
          itemCount: indices.length,
          itemBuilder: (context, idx) {
            return SurahCard(state.surahs, indices[idx]);
          },
        );
      },
    );
  }
}

class _JuzSearchTab extends StatelessWidget {
  const _JuzSearchTab({required this.query});
  final String query;

  bool _matches(String haystack, String q) =>
      haystack.toLowerCase().contains(q.toLowerCase());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JuzBloc, JuzState>(
      builder: (context, state) {
        final juzs = state.juzs.juzs;
        final q = query.trim();

        final indices = <int>[];
        for (var i = 0; i < juzs.length; i++) {
          final j = juzs[i];
          if (q.isEmpty ||
              _matches(j.englishName, q) ||
              _matches(j.arabicName, q) ||
              _matches('${j.id}', q)) {
            indices.add(i);
          }
        }

        if (indices.isEmpty) {
          return _SearchEmptyState(
            title: q.isEmpty ? 'Search Juz' : 'No results',
            subtitle: q.isEmpty
                ? 'Type a Juz name or number (e.g. “2”).'
                : 'Nothing matched “$q”. Try searching by number.',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 16.h),
          itemCount: indices.length,
          itemBuilder: (context, idx) {
            return JuzCard(state.juzs, indices[idx]);
          },
        );
      },
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: kPagePadding,
        child: Container(
          constraints: BoxConstraints(maxWidth: 520.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : primary.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.search, color: primary, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
