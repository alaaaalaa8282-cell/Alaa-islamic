part of 'prayer_time_config_bloc.dart';

abstract class PrayerTimeConfigEvent extends Equatable {
  const PrayerTimeConfigEvent();
}

class SetPrayerTimeMethod extends PrayerTimeConfigEvent {
  final PrayerTimeMethod method;
  const SetPrayerTimeMethod(this.method);

  @override
  List<Object> get props => [method];
}

class SetPrayerTimeSchool extends PrayerTimeConfigEvent {
  final PrayerTimeSchool school;
  const SetPrayerTimeSchool(this.school);

  @override
  List<Object> get props => [school];
}

class SetPrayerDayOffset extends PrayerTimeConfigEvent {
  final int offset;
  const SetPrayerDayOffset(this.offset);

  @override
  List<Object> get props => [offset];
}

class SetHijriAdjustmentDays extends PrayerTimeConfigEvent {
  final int offset;
  const SetHijriAdjustmentDays(this.offset);

  @override
  List<Object> get props => [offset];
}

class ResetPrayerTimeConfig extends PrayerTimeConfigEvent {
  const ResetPrayerTimeConfig();

  @override
  List<Object> get props => [];
}

