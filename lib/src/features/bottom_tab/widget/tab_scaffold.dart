import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/bloc/quran_audio/quran_audio_bloc.dart';
import '../../../core/util/constants.dart';
import '../../utils/loading_widget.dart';
import '../bloc/tab/tab_bloc.dart';
import 'sirat_bottom_tab.dart';

class TabScaffold extends StatefulWidget {
  const TabScaffold();

  @override
  State<TabScaffold> createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> {
  bool _solidStatusBar = false;
  int _currentTabIndex = 0;

  bool _effectiveSolidForTab(int tabIndex) {
    if (tabIndex == 0 || tabIndex == 4) return _solidStatusBar;
    return true;
  }

  SystemUiOverlayStyle _overlayStyleFor(BuildContext context, int tabIndex) {
    final brightness = Theme.of(context).brightness;
    final base = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    final statusBarColor = _effectiveSolidForTab(tabIndex)
        ? Theme.of(context).scaffoldBackgroundColor
        : Colors.transparent;

    return base.copyWith(
      statusBarColor: statusBarColor,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          brightness == Brightness.dark ? Brightness.dark : Brightness.light,
    );
  }

  bool _shouldUseSolidStatusBar({
    required int tabIndex,
    required double pixels,
  }) {
    if (tabIndex == 0) return pixels > 0.2.sh;
    if (tabIndex == 4) return pixels > 40.h;
    return true;
  }

  @override
  void didChangeDependencies() {
    final prayerConfig = BlocProvider.of<PrayerTimeConfigBloc>(context).state;
    BlocProvider.of<TimingBloc>(context).add(
      RequestTiming(
        BlocProvider.of<NotificationBloc>(context).state.status,
        BlocProvider.of<LocationBloc>(context).state,
        prayerConfig.method.id,
        prayerConfig.school.id,
        prayerConfig.dayOffset,
        prayerConfig.hijriAdjustmentDays,
      ),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimingBloc, TimingState>(
      builder: (context, state) {
        if (state is TimingLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: LoadingWidget(),
          );
        }
        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     await NotificationService().checkNotification();
          //   },
          // ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0,
            systemOverlayStyle: _overlayStyleFor(context, _currentTabIndex),
          ),
          bottomNavigationBar: SiratNavigationBar(),
          body: BlocListener<TabBloc, TabState>(
            listenWhen: (previous, current) => previous.index != current.index,
            listener: (context, tabState) {
              _currentTabIndex = tabState.index;
              final nextSolid = (_currentTabIndex == 0 || _currentTabIndex == 4)
                  ? _shouldUseSolidStatusBar(
                      tabIndex: _currentTabIndex,
                      pixels: 0,
                    )
                  : true;
              if (nextSolid != _solidStatusBar) {
                setState(() => _solidStatusBar = nextSolid);
              }
              if (tabState.index != 2) {
                BlocProvider.of<QuranAudioBloc>(context)
                    .add(const StopAudio());
              }
            },
            child: BlocBuilder<TabBloc, TabState>(
              builder: (context, state) {
                final statusBarFillColor = Theme.of(context).scaffoldBackgroundColor;
                final statusBarHeight = MediaQuery.of(context).padding.top;
                final showStatusBarFill = _effectiveSolidForTab(state.index);

                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.axis != Axis.vertical) {
                      return false;
                    }
                    final nextSolid = _shouldUseSolidStatusBar(
                      tabIndex: state.index,
                      pixels: notification.metrics.pixels,
                    );
                    if (nextSolid != _solidStatusBar) {
                      setState(() => _solidStatusBar = nextSolid);
                    }
                    return false;
                  },
                  child: Stack(
                    children: [
                      AnimatedSwitcher(
                        duration: kAnimationDuration,
                        switchInCurve: kAnimationCurve,
                        child: state.screen,
                      ),
                      if (showStatusBarFill && statusBarHeight > 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: statusBarHeight,
                          child: IgnorePointer(
                            ignoring: true,
                            child: ColoredBox(color: statusBarFillColor),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
