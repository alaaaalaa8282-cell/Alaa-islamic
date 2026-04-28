import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/quran/quran_bloc.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/model/quran.dart';
import '../bloc/selected_surah/selected_surah_bloc.dart';
import 'quran_card.dart';

class SurahContent extends StatefulWidget {
  const SurahContent({
    this.scrollDirection = Axis.vertical,
    this.initialAyatId,
    required this.onLastAyatChanged,
  });

  final Axis scrollDirection;
  final int? initialAyatId;
  final ValueChanged<int> onLastAyatChanged;

  @override
  State<SurahContent> createState() => _SurahContentState();
}

class _SurahContentState extends State<SurahContent> {
  late final ScrollController _scrollController;
  final Map<int, GlobalKey> _itemKeys = {};

  List<Quran> _sorted = [];
  double? _estimatedItemExtent;
  int? _lastSavedAyatId;
  int? _lastInitSurahId;
  int? _lastInitAyatId;
  Axis? _lastInitAxis;

  double? _averageItemExtentFromScrollMetrics() {
    if (!_scrollController.hasClients) return null;
    if (_sorted.length <= 1) return null;

    final max = _scrollController.position.maxScrollExtent;
    if (max <= 0) return null;

    return max / (_sorted.length - 1);
  }

  Future<void> _scrollToAyahId(int ayatId) async {
    if (!mounted || _sorted.isEmpty) return;

    final targetIndex = _sorted.indexWhere((e) => e.ayatId == ayatId);
    if (targetIndex < 0) return;

    await Future<void>.delayed(const Duration(milliseconds: 50));

    if (!mounted || !_scrollController.hasClients) return;

    double lowOffset = _scrollController.position.minScrollExtent;
    double highOffset = _scrollController.position.maxScrollExtent;

    for (int attempt = 0; attempt < 30; attempt++) {
      if (!mounted) return;

      final ctx = _itemKeys[ayatId]?.currentContext;
      if (ctx != null) {
        await Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
        return;
      }

      if (!_scrollController.hasClients) {
        await Future<void>.delayed(const Duration(milliseconds: 16));
        continue;
      }

      int? firstVisibleIndex;
      int? lastVisibleIndex;

      for (int i = 0; i < _sorted.length; i++) {
        final key = _itemKeys[_sorted[i].ayatId];
        if (key?.currentContext != null) {
          firstVisibleIndex ??= i;
          lastVisibleIndex = i;
        }
      }

      if (firstVisibleIndex != null && lastVisibleIndex != null) {
        if (targetIndex < firstVisibleIndex) {
          highOffset = _scrollController.offset;
          final newOffset = (lowOffset + highOffset) / 2;
          _scrollController.jumpTo(newOffset);
        } else if (targetIndex > lastVisibleIndex) {
          lowOffset = _scrollController.offset;
          final newOffset = (lowOffset + highOffset) / 2;
          _scrollController.jumpTo(newOffset);
        }
      } else {
        _estimatedItemExtent ??= _measureFirstItemExtent();
        final avg = _averageItemExtentFromScrollMetrics();
        final extent =
            (avg != null && avg > 0) ? avg : (_estimatedItemExtent ?? 200.0);

        final targetOffset = targetIndex * extent;
        final clamped = targetOffset.clamp(lowOffset, highOffset);
        _scrollController.jumpTo(clamped);
      }

      await Future<void>.delayed(const Duration(milliseconds: 32));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    try {
      _saveCurrentAyahFromOffset();
    } catch (_) {}
    _scrollController.dispose();
    super.dispose();
  }

  void _postFrameInitIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_sorted.isEmpty) return;

      final initialFromWidget = widget.initialAyatId;
      final initialId = initialFromWidget != null &&
              _sorted.any((e) => e.ayatId == initialFromWidget)
          ? initialFromWidget
          : _sorted.first.ayatId;

      await _scrollToAyahId(initialId);

      if (_lastSavedAyatId != initialId) {
        _lastSavedAyatId = initialId;
        widget.onLastAyatChanged(initialId);
      }
    });
  }

  double? _measureFirstItemExtent() {
    if (_sorted.isEmpty) return null;
    final first = _sorted.first;
    final ctx = _itemKeys[first.ayatId]?.currentContext;
    if (ctx == null) return null;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;

    return widget.scrollDirection == Axis.vertical
        ? box.size.height
        : box.size.width;
  }

  void _saveCurrentAyahFromOffset() {
    if (_sorted.isEmpty) return;
    if (_estimatedItemExtent == null || _estimatedItemExtent! <= 0) return;

    final pixels = _scrollController.position.pixels;
    final index = ((pixels / _estimatedItemExtent!).round())
        .clamp(0, _sorted.length - 1)
        .toInt();
    final ayatId = _sorted[index].ayatId;

    if (_lastSavedAyatId == ayatId) return;
    _lastSavedAyatId = ayatId;
    widget.onLastAyatChanged(ayatId);
  }

  void _maybeInitOnce(int surahId) {
    final currentInitAyatId = widget.initialAyatId;
    final currentAxis = widget.scrollDirection;

    final listChanged = _lastInitSurahId != surahId;
    final initChanged =
        _lastInitAyatId != currentInitAyatId || _lastInitAxis != currentAxis;

    if (!listChanged && !initChanged) return;

    _lastInitSurahId = surahId;
    _lastInitAyatId = currentInitAyatId;
    _lastInitAxis = currentAxis;

    _estimatedItemExtent = null;
    _lastSavedAyatId = null;

    _itemKeys.clear();

    _postFrameInitIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedSurahBloc, SelectedSurahState>(
      builder: (context, currentSurahState) {
        return BlocBuilder<QuranBloc, QuranState>(
          builder: (context, quranState) {
            final items =
                quranState.qurans.getQuransBySurah(currentSurahState.surah.id);
            final sorted = List.of(items)
              ..sort((a, b) => a.ayatId.compareTo(b.ayatId));

            _sorted = sorted;
            for (final q in sorted) {
              _itemKeys.putIfAbsent(q.ayatId, () => GlobalKey());
            }
            _maybeInitOnce(currentSurahState.surah.id);

            return SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: Text(
                              currentSurahState.surah.nameAr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kDarkTextColor,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: Text(
                              '${currentSurahState.surah.place} - ${currentSurahState.surah.ayats} asdf',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: kDarkTextColor),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Text(
                          '${currentSurahState.surah.id}',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: kDarkTextColor,
                                fontFamily: 'arsura',
                              ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // SurahScrollSelection(),
                  // SizedBox(height: 16.h),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: kBottomSheetBorderRadius,
                      ),
                      child: NotificationListener<ScrollEndNotification>(
                        onNotification: (notification) {
                          _saveCurrentAyahFromOffset();
                          return false;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: widget.scrollDirection,
                          itemCount: sorted.length,
                          itemBuilder: (context, index) {
                            final quran = sorted[index];
                            final key = _itemKeys.putIfAbsent(
                              quran.ayatId,
                              () => GlobalKey(),
                            );

                            final card = QuranCard(
                              quran,
                              qcfVerseNumberOverride: index + 1,
                            );

                            final wrapped = KeyedSubtree(
                              key: key,
                              child: card,
                            );

                            if (widget.scrollDirection == Axis.horizontal) {
                              return SizedBox(width: 1.sw, child: wrapped);
                            }

                            return wrapped;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
