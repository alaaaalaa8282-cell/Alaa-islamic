import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:sirat_e_mustaqeem/src/core/util/constants.dart';

import '../../../core/util/bloc/juz/juz_bloc.dart';
import '../../../core/util/bloc/surah/surah_bloc.dart';
import '../../bottom_tab/bloc/tab/tab_bloc.dart' as btb;
import '../bloc/selected_juz/selected_juz_bloc.dart';
import '../bloc/selected_surah/selected_surah_bloc.dart';
import '../bloc/tab/tab_bloc.dart' as qtb;
import '../cubit/quran_cubit.dart';
import '../cubit/quran_reading_cubit.dart';
import '../screen/selected_quran_screen.dart';
import '../screen/quran_search_screen.dart';
import 'juz_card.dart';
import 'quran_tab.dart';
import 'surah_card.dart';

class QuranScaffold extends StatelessWidget {
  const QuranScaffold();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final overlay = (brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          brightness == Brightness.dark ? Brightness.dark : Brightness.light,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        systemOverlayStyle: overlay,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        title: Text(
          'Al-Quran',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              if (!BlocProvider.of<QuranCubit>(context).state.fromNav)
                Navigator.of(context).pop();
              BlocProvider.of<btb.TabBloc>(context).add(btb.SetTab(3));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: SvgPicture.asset(
                'assets/images/navigation_icon/svg/bookmark_nfill.svg',
                width: 24.w,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final quranCubit = BlocProvider.of<QuranCubit>(context);
              QuranReadingCubit? readingCubit;
              try {
                readingCubit = BlocProvider.of<QuranReadingCubit>(context);
              } catch (_) {
                readingCubit = null;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider<QuranCubit>.value(value: quranCubit),
                      if (readingCubit != null)
                        BlocProvider<QuranReadingCubit>.value(
                            value: readingCubit),
                    ],
                    child: const QuranSearchScreen(),
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: SvgPicture.asset(
                'assets/images/navigation_icon/svg/search.svg',
                width: 24.w,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.h,
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 32.w),
            //   child: Text(
            //     'Al-Qur\'an',
            //     style: Theme.of(context).textTheme.displayMedium!.copyWith(
            //           fontWeight: FontWeight.bold,
            //         ),
            //   ),
            // ),
            // SizedBox(
            //   height: 16.h,
            // ),
            QuranTab(),
            BlocBuilder<QuranReadingCubit, QuranReadingState>(
              builder: (context, readingState) {
                if (!readingState.hasLastReading) {
                  return const SizedBox.shrink();
                }

                final fromNav =
                    BlocProvider.of<QuranCubit>(context).state.fromNav;
                final lastAyatId = readingState.lastAyatId;

                if (lastAyatId == null) {
                  return const SizedBox.shrink();
                }

                if (readingState.lastMode == 'surah') {
                  return BlocBuilder<SurahBloc, SurahState>(
                    builder: (context, surahState) {
                      final lastSurahId = readingState.lastSurahId;
                      if (lastSurahId == null) return const SizedBox.shrink();

                      final index = surahState.surahs.surahs
                          .indexWhere((s) => s.id == lastSurahId);

                      if (index < 0) return const SizedBox.shrink();

                      final lastSurahName =
                          surahState.surahs.surahs[index].nameEn;

                      return GestureDetector(
                        onTap: () {
                          QuranReadingCubit? parentCubit;
                          try {
                            parentCubit =
                                BlocProvider.of<QuranReadingCubit>(context);
                          } catch (_) {
                            parentCubit = null;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    SelectedSurahBloc(surahState.surahs, index),
                                child: BlocProvider(
                                  create: (context) => QuranCubit(fromNav),
                                  child: parentCubit != null
                                      ? BlocProvider.value(
                                          value: parentCubit,
                                          child: SelectedQuranScreen(
                                            surah: true,
                                            initialAyatId: lastAyatId,
                                          ),
                                        )
                                      : BlocProvider(
                                          create: (context) =>
                                              QuranReadingCubit(),
                                          child: SelectedQuranScreen(
                                            surah: true,
                                            initialAyatId: lastAyatId,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12.h,
                            vertical: 10.h,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 10.h,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(
                                  alpha: 0.15,
                                ),
                            borderRadius: kAppIconBorderRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Continue Reading Surah $lastSurahName",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (readingState.lastMode == 'juz') {
                  return BlocBuilder<JuzBloc, JuzState>(
                    builder: (context, juzState) {
                      final lastJuzId = readingState.lastJuzId;
                      if (lastJuzId == null) return const SizedBox.shrink();

                      final index = juzState.juzs.juzs
                          .indexWhere((j) => j.id == lastJuzId);

                      if (index < 0) return const SizedBox.shrink();

                      final lastJuzName = juzState.juzs.juzs[index].englishName;

                      return GestureDetector(
                        onTap: () {
                          QuranReadingCubit? parentCubit;
                          try {
                            parentCubit =
                                BlocProvider.of<QuranReadingCubit>(context);
                          } catch (_) {
                            parentCubit = null;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    SelectedJuzBloc(juzState.juzs, index),
                                child: BlocProvider(
                                  create: (context) => QuranCubit(fromNav),
                                  child: parentCubit != null
                                      ? BlocProvider.value(
                                          value: parentCubit,
                                          child: SelectedQuranScreen(
                                            surah: false,
                                            initialAyatId: lastAyatId,
                                          ),
                                        )
                                      : BlocProvider(
                                          create: (context) =>
                                              QuranReadingCubit(),
                                          child: SelectedQuranScreen(
                                            surah: false,
                                            initialAyatId: lastAyatId,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12.h,
                            vertical: 10.h,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 10.h,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(
                                  alpha: 0.15,
                                ),
                            borderRadius: kAppIconBorderRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Continue Reading $lastJuzName",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<qtb.TabBloc, qtb.TabState>(
              builder: (context, tabState) {
                return Expanded(
                  child: PageView.builder(
                      controller: tabState.controller,
                      itemCount: 2,
                      onPageChanged: (index) {
                        BlocProvider.of<qtb.TabBloc>(context)
                            .add(qtb.ToggleTab(index == 0));
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return BlocBuilder<SurahBloc, SurahState>(
                            builder: (context, state) {
                              return ListView.builder(
                                  itemCount: state.surahs.surahs.length,
                                  itemBuilder: (context, index) {
                                    return SurahCard(
                                      state.surahs,
                                      index,
                                    );
                                  });
                            },
                          );
                        } else {
                          return BlocBuilder<JuzBloc, JuzState>(
                            builder: (context, state) {
                              return ListView.builder(
                                  itemCount: state.juzs.juzs.length,
                                  itemBuilder: (context, index) {
                                    return JuzCard(
                                      state.juzs,
                                      index,
                                    );
                                  });
                            },
                          );
                        }
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
