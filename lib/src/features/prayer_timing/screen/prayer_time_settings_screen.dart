import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/constants.dart';
import '../../utils/bottom_sheet_select.dart';

class PrayerTimeSettingsScreen extends StatelessWidget {
  const PrayerTimeSettingsScreen({super.key});

  void _refreshTimings(BuildContext context) {
    final locationState = BlocProvider.of<LocationBloc>(context).state;
    final notificationStatus =
        BlocProvider.of<NotificationBloc>(context).state.status;
    final config = BlocProvider.of<PrayerTimeConfigBloc>(context).state;

    BlocProvider.of<TimingBloc>(context).add(
      RequestTiming(
        notificationStatus,
        locationState,
        config.method.id,
        config.school.id,
        config.dayOffset,
        config.hijriAdjustmentDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer time settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: kPagePadding,
            child: BlocBuilder<PrayerTimeConfigBloc, PrayerTimeConfigState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: 16.h),
                    BottomSheetSelect<PrayerTimeMethod>(
                      label: 'Calculation method',
                      value: state.method,
                      options: PrayerTimeMethod.values,
                      optionLabelBuilder: (m) => m.label,
                      onChanged: (method) {
                        BlocProvider.of<PrayerTimeConfigBloc>(context)
                            .add(SetPrayerTimeMethod(method));
                        _refreshTimings(context);
                      },
                    ),
                    const Divider(),
                    BottomSheetSelect<PrayerTimeSchool>(
                      label: 'Asr school',
                      value: state.school,
                      options: PrayerTimeSchool.values,
                      optionLabelBuilder: (s) => s.label,
                      onChanged: (school) {
                        BlocProvider.of<PrayerTimeConfigBloc>(context)
                            .add(SetPrayerTimeSchool(school));
                        _refreshTimings(context);
                      },
                    ),
                    const Divider(),
                    _StepSettingRow(
                      label: 'Prayer day offset',
                      value: state.dayOffset,
                      min: 0,
                      max: 2,
                      onChanged: (value) {
                        BlocProvider.of<PrayerTimeConfigBloc>(context)
                            .add(SetPrayerDayOffset(value));
                        _refreshTimings(context);
                      },
                    ),
                    const Divider(),
                    _StepSettingRow(
                      label: 'Hijri date adjustment',
                      value: state.hijriAdjustmentDays,
                      min: 0,
                      max: 2,
                      onChanged: (value) {
                        BlocProvider.of<PrayerTimeConfigBloc>(context)
                            .add(SetHijriAdjustmentDays(value));
                        _refreshTimings(context);
                      },
                    ),
                    const Divider(),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<PrayerTimeConfigBloc>(context)
                              .add(const ResetPrayerTimeConfig());
                          _refreshTimings(context);
                        },
                        child: const Text('Reset to defaults'),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StepSettingRow extends StatelessWidget {
  const _StepSettingRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrement = value > min;
    final canIncrement = value < max;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
          IconButton(
            onPressed: canDecrement ? () => onChanged(value - 1) : null,
            icon: Icon(Icons.remove, color: theme.primaryColor),
          ),
          Text(
            value.toString(),
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: canIncrement ? () => onChanged(value + 1) : null,
            icon: Icon(Icons.add, color: theme.primaryColor),
          ),
        ],
      ),
    );
  }
}

