part of 'timing_bloc.dart';

abstract class TimingEvent extends Equatable {
  const TimingEvent();
}

class RequestTiming extends TimingEvent {
  final LocationState locationState;

  final PermissionStatus notificationEnabled;
  final int method;
  final int school;
  final int dayOffset;
  final int hijriAdjustmentDays;

  const RequestTiming(
    this.notificationEnabled,
    this.locationState,
    this.method,
    this.school,
    this.dayOffset,
    this.hijriAdjustmentDays,
  );

  @override
  List<Object> get props => [
        notificationEnabled,
        locationState,
        method,
        school,
        dayOffset,
        hijriAdjustmentDays,
      ];
}

class RequestTimingForTomorrow extends TimingEvent {
  final LocationState locationState;
  final PermissionStatus notificationEnabled;
  final int method;
  final int school;
  final int dayOffset;
  final int hijriAdjustmentDays;

  const RequestTimingForTomorrow(
    this.notificationEnabled,
    this.locationState,
    this.method,
    this.school,
    this.dayOffset,
    this.hijriAdjustmentDays,
  );

  @override
  List<Object> get props => [
        notificationEnabled,
        locationState,
        method,
        school,
        dayOffset,
        hijriAdjustmentDays,
      ];
}

class UpdateTiming extends TimingEvent {
  @override
  List<Object> get props => [];
}

class PushNotification extends TimingEvent {
  @override
  List<Object> get props => [];
}

class CancelNotification extends TimingEvent {
  @override
  List<Object> get props => [];
}
