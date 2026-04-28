import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import 'prayer_timing_widget.dart';

class KiblatCard extends StatelessWidget {
  const KiblatCard({super.key});

  static const _fajrIcon = 'assets/images/home_icon/svg/fajr.svg';
  static const _sunriseIcon = 'assets/images/home_icon/svg/sunrise.png';
  static const _dhuhrIcon = 'assets/images/home_icon/svg/sun.png';
  static const _asrIcon = 'assets/images/home_icon/svg/asar.png';
  static const _maghribIcon = 'assets/images/home_icon/svg/maghrib.png';
  static const _ishaIcon = 'assets/images/home_icon/svg/isha.png';

  int _nextPrayerIndex(List<String> times) {
    final now = DateTime.now();
    for (int i = 0; i < times.length; i++) {
      final parts = times[i].split(':');
      if (parts.length < 2) continue;
      final hour = int.tryParse(parts[0]) ?? 0;
      final min = int.tryParse(parts[1]) ?? 0;
      final t = DateTime(now.year, now.month, now.day, hour, min);
      if (now.isBefore(t)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: BlocBuilder<TimingBloc, TimingState>(
        builder: (context, state) {
          if (state is TimingLoaded) {
            final items = [
              _PrayerItem('Fazr', state.timing.data.timings.fajr, _fajrIcon),
              _PrayerItem(
                  'Sunrise', state.timing.data.timings.sunrise, _sunriseIcon),
              _PrayerItem('Dhuhr', state.timing.data.timings.dhuhr, _dhuhrIcon),
              _PrayerItem('Asr', state.timing.data.timings.asr, _asrIcon),
              _PrayerItem(
                  'Maghrib', state.timing.data.timings.maghrib, _maghribIcon),
              _PrayerItem('Isha', state.timing.data.timings.isha, _ishaIcon),
            ];

            final nextIdx = _nextPrayerIndex(items.map((e) => e.time).toList());

            return Row(
              children: [
                for (int i = 0; i < items.length; i++)
                  Expanded(
                    child: PrayerTimingWidget(
                      title: items[i].title,
                      time: items[i].time,
                      iconAsset: items[i].iconAsset,
                      selected: i == nextIdx,
                    ),
                  ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class _PrayerItem {
  final String title;
  final String time;
  final String iconAsset;
  const _PrayerItem(this.title, this.time, this.iconAsset);
}
