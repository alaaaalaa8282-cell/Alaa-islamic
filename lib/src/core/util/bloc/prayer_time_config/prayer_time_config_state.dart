part of 'prayer_time_config_bloc.dart';

class PrayerTimeConfigState extends Equatable {
  final PrayerTimeMethod method;
  final PrayerTimeSchool school;
  final int dayOffset;
  final int hijriAdjustmentDays;

  const PrayerTimeConfigState({
    required this.method,
    required this.school,
    required this.dayOffset,
    required this.hijriAdjustmentDays,
  });

  PrayerTimeConfigState copyWith({
    PrayerTimeMethod? method,
    PrayerTimeSchool? school,
    int? dayOffset,
    int? hijriAdjustmentDays,
  }) {
    return PrayerTimeConfigState(
      method: method ?? this.method,
      school: school ?? this.school,
      dayOffset: dayOffset ?? this.dayOffset,
      hijriAdjustmentDays: hijriAdjustmentDays ?? this.hijriAdjustmentDays,
    );
  }

  @override
  List<Object> get props => [
        method,
        school,
        dayOffset,
        hijriAdjustmentDays,
      ];
}

