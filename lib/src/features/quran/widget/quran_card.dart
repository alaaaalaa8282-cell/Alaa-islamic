import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcf_quran/qcf_quran.dart';

import '../../../core/util/bloc/quran/quran_bloc.dart';
import '../../../core/util/bloc/quran_audio/quran_audio_bloc.dart';
import '../../../core/util/bloc/surah/surah_bloc.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/model/quran.dart';
import '../../bookmark/bloc/category_bloc.dart';
import '../bloc/quran_theme/quran_theme_bloc.dart';
import '../bloc/selected_surah/selected_surah_bloc.dart';
import '../controller/quran_controller.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_reading_cubit.dart';
import '../screen/selected_quran_screen.dart';

class QuranCard extends StatelessWidget {
  const QuranCard(
    this.quran, {
    this.bookmarkScreen = false,
    this.qcfVerseNumberOverride,
  });

  final Quran quran;
  final bool bookmarkScreen;
  final int? qcfVerseNumberOverride;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        final bool isQcfMode = state.quranType == 'QCF' ||
            state.quranFontFamily.trim().toLowerCase() == 'qcf';

        final int baseVerseNumber = qcfVerseNumberOverride ?? quran.ayatNumber;
        final int? resolvedQcfVerseNumber = isQcfMode
            ? _resolveValidQcfVerseNumber(
                surahNumber: quran.surahId,
                baseVerseNumber: baseVerseNumber,
              )
            : null;

        final int? verseNumberOverrideForQcf =
            resolvedQcfVerseNumber ?? qcfVerseNumberOverride;

        final audioState = context.watch<QuranAudioBloc>().state;
        final isCurrentAyah = audioState.currentAyatId == quran.ayatId;
        final isPlayingThisAyah =
            isCurrentAyah && audioState.status == QuranAudioStatus.playing;
        final isLoadingThisAyah =
            isCurrentAyah && audioState.status == QuranAudioStatus.loading;

        return Container(
          padding: kPagePadding,
          decoration: BoxDecoration(
            color: isCurrentAyah && audioState.isActive
                ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
                : null,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await toggleQuranFavorite(context, quran);

                      if (bookmarkScreen) {
                        await Future.delayed(Duration.zero);

                        BlocProvider.of<CategoryBloc>(context).add(
                          UpdateFavoriteItem(
                            qurans:
                                BlocProvider.of<QuranBloc>(context).state.qurans,
                          ),
                        );
                      }
                    },
                    child: SvgPicture.asset(
                      quran.favorite == 0
                          ? 'assets/images/navigation_icon/svg/bookmark_nfill.svg'
                          : 'assets/images/navigation_icon/svg/bookmark_fill.svg',
                      color: Theme.of(context).primaryColor,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      final bloc = BlocProvider.of<QuranAudioBloc>(context);
                      bloc.add(
                        ToggleAyahPlayPause(
                          ayatId: quran.ayatId,
                          surahId: quran.surahId,
                          edition: state.audioEdition,
                          bitrate: state.audioBitrate,
                        ),
                      );

                      final msg = bloc.state.errorMessage;
                      if (msg != null && msg.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );
                        bloc.add(const ClearAudioError());
                      }
                    },
                    child: Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: isLoadingThisAyah
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : Icon(
                              isPlayingThisAyah ? Icons.pause : Icons.play_arrow,
                              color: Theme.of(context).primaryColor,
                              size: 20.sp,
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 16.w,
              ),
              Expanded(
                child: _BookmarkAyahBody(
                  bookmarkScreen: bookmarkScreen,
                  quran: quran,
                  showTranslation: state.showTranslation,
                  translationMode: state.translationMode,
                  translationFontFamily: state.translationFontFamily,
                  translationFontSize: state.translationFontSize,
                  quranFontFamily: state.quranFontFamily,
                  quranFontSize: state.quranFontSize,
                  qcfVerseNumberOverride: verseNumberOverrideForQcf,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

TextStyle _translationTextStyle({
  required BuildContext context,
  required String translationMode,
  required String translationFontFamily,
  required double fontSize,
}) {
  final baseStyle = Theme.of(context).textTheme.titleLarge!;

  if (translationMode == 'Urdu') {
    return baseStyle.copyWith(
      fontFamily: 'Jameel',
      fontSize: fontSize,
    );
  }

  try {
    return GoogleFonts.getFont(
      translationFontFamily,
      textStyle: baseStyle.copyWith(
        fontSize: fontSize,
      ),
    );
  } catch (_) {
    return GoogleFonts.poppins(
      textStyle: baseStyle.copyWith(
        fontSize: fontSize,
      ),
    );
  }
}

int? _resolveValidQcfVerseNumber({
  required int surahNumber,
  required int baseVerseNumber,
}) {
  final candidates = <int>[
    baseVerseNumber,
    baseVerseNumber - 1,
    baseVerseNumber + 1,
  ];

  for (final candidate in candidates) {
    if (candidate < 1) continue;
    try {
      getPageNumber(surahNumber, candidate);
      return candidate;
    } catch (_) {
    }
  }

  return null;
}

void _openQuranReaderAtBookmarkedAyah(BuildContext context, Quran quran) {
  final surahs = BlocProvider.of<SurahBloc>(context).state.surahs;
  final index = surahs.surahs.indexWhere((s) => s.id == quran.surahId);
  if (index < 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open this verse in the Quran.')),
    );
    return;
  }

  QuranReadingCubit? readingCubit;
  try {
    readingCubit = BlocProvider.of<QuranReadingCubit>(context);
  } catch (_) {
    readingCubit = null;
  }

  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (_) => SelectedSurahBloc(surahs, index),
        child: BlocProvider(
          create: (_) => QuranCubit(true),
          child: readingCubit != null
              ? BlocProvider<QuranReadingCubit>.value(
                  value: readingCubit,
                  child: SelectedQuranScreen(
                    surah: true,
                    initialAyatId: quran.ayatId,
                  ),
                )
              : BlocProvider(
                  create: (_) => QuranReadingCubit(),
                  child: SelectedQuranScreen(
                    surah: true,
                    initialAyatId: quran.ayatId,
                  ),
                ),
        ),
      ),
    ),
  );
}

class _BookmarkAyahBody extends StatelessWidget {
  const _BookmarkAyahBody({
    required this.bookmarkScreen,
    required this.quran,
    required this.showTranslation,
    required this.translationMode,
    required this.translationFontFamily,
    required this.translationFontSize,
    required this.quranFontFamily,
    required this.quranFontSize,
    this.qcfVerseNumberOverride,
  });

  final bool bookmarkScreen;
  final Quran quran;
  final bool showTranslation;
  final String translationMode;
  final String translationFontFamily;
  final double translationFontSize;
  final String quranFontFamily;
  final double quranFontSize;
  final int? qcfVerseNumberOverride;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surface,
            width: 2.sp,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _QuranArabicText(
            quran: quran,
            withArabs: true,
            selectedFontFamily: quranFontFamily,
            fontSize: quranFontSize,
            qcfVerseNumberOverride: qcfVerseNumberOverride,
          ),
          SizedBox(height: 8.h),
          if (showTranslation)
            Text(
              quran.getTranslationText(
                translationMode,
                verseNumberOverride: qcfVerseNumberOverride,
              ),
              textAlign: TextAlign.end,
              style: _translationTextStyle(
                context: context,
                translationMode: translationMode,
                translationFontFamily: translationFontFamily,
                fontSize: translationFontSize,
              ),
            ),
          SizedBox(height: 8.h),
        ],
      ),
    );

    if (!bookmarkScreen) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openQuranReaderAtBookmarkedAyah(context, quran),
        borderRadius: BorderRadius.circular(12.r),
        child: content,
      ),
    );
  }
}

class _QuranArabicText extends StatelessWidget {
  const _QuranArabicText({
    required this.quran,
    required this.withArabs,
    required this.selectedFontFamily,
    required this.fontSize,
    this.qcfVerseNumberOverride,
  });

  final Quran quran;
  final bool withArabs;
  final String selectedFontFamily;
  final double fontSize;
  final int? qcfVerseNumberOverride;

  bool get _shouldUseQcf =>
      withArabs && selectedFontFamily.trim().toLowerCase() == 'qcf';

  bool _isValidQcfVerse(int surahNumber, int verseNumber) {
    try {
      getPageNumber(surahNumber, verseNumber);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldUseQcf) {
      final surahNumber = quran.surahId;
      final baseVerseNumber = qcfVerseNumberOverride ?? quran.ayatNumber;
      final candidates = <int>[
        baseVerseNumber,
        baseVerseNumber + 1,
      ];

      for (final candidate in candidates) {
        if (candidate < 1) continue;
        if (!_isValidQcfVerse(surahNumber, candidate)) continue;

        return Align(
          alignment: Alignment.centerRight,
          child: QcfVerse(
            surahNumber: surahNumber,
            verseNumber: candidate,
            fontSize: fontSize,
            textColor: Theme.of(context).textTheme.displaySmall?.color ??
                Theme.of(context).primaryColor,
            sp: 1.sp,
            h: 1.h,
          ),
        );
      }
    }

    return Text(
      withArabs ? quran.arabicText : quran.withoutAerab,
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontFamily: 'Uthman',
            fontSize: fontSize,
          ),
    );
  }
}
