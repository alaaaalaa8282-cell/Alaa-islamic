import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/model/timing.dart';

class _NextPrayerInfo {
  final String name;
  final Duration remaining;

  _NextPrayerInfo(this.name, this.remaining);
}

class UpcomingPrayerText extends StatefulWidget {
  const UpcomingPrayerText({super.key});

  @override
  State<UpcomingPrayerText> createState() => _UpcomingPrayerTextState();
}

class _UpcomingPrayerTextState extends State<UpcomingPrayerText> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  static DateTime? _atToday(String hhmm, DateTime now) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0].trim()) ?? 0;
    final m = int.tryParse(parts[1].trim().split(' ').first) ?? 0;
    return DateTime(now.year, now.month, now.day, h, m);
  }

  static String _formatDuration(Duration d) {
    if (d.isNegative) return '0 minutes';
    if (d.inMinutes < 1) return 'less than a minute';
    if (d.inMinutes < 60) {
      final mins = d.inMinutes;
      return '$mins ${mins == 1 ? 'minute' : 'minutes'}';
    }
    final h = d.inHours;
    final mins = d.inMinutes.remainder(60);
    if (mins == 0) {
      return '$h ${h == 1 ? 'hour' : 'hours'}';
    }
    return '$h ${h == 1 ? 'hour' : 'hours'} $mins ${mins == 1 ? 'minute' : 'minutes'}';
  }

  static _NextPrayerInfo? _nextPrayer(Timings t) {
    final now = DateTime.now();
    final items = <MapEntry<String, String>>[
      MapEntry('Fajr', t.fajr),
      MapEntry('Sunrise', t.sunrise),
      MapEntry('Dhuhr', t.dhuhr),
      MapEntry('Asr', t.asr),
      MapEntry('Maghrib', t.maghrib),
      MapEntry('Isha', t.isha),
    ];

    for (final e in items) {
      final at = _atToday(e.value, now);
      if (at != null && now.isBefore(at)) {
        return _NextPrayerInfo(e.key, at.difference(now));
      }
    }

    final fajr = _atToday(t.fajr, now);
    if (fajr == null) return null;
    final tomorrowFajr =
        DateTime(now.year, now.month, now.day + 1, fajr.hour, fajr.minute);
    return _NextPrayerInfo('Fajr', tomorrowFajr.difference(now));
  }

  static const _gold = Color(0xFFFFE082);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimingBloc, TimingState>(
      builder: (context, state) {
        if (state is! TimingLoaded) {
          return const SizedBox.shrink();
        }
        final next = _nextPrayer(state.timing.data.timings);
        if (next == null) {
          return const SizedBox.shrink();
        }

        final durationStr = _formatDuration(next.remaining);
        final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 14.sp,
              height: 1.25,
            );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text.rich(
            TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: '${next.name} is only away from '),
                TextSpan(
                  text: durationStr,
                  style: baseStyle?.copyWith(
                    color: _gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
