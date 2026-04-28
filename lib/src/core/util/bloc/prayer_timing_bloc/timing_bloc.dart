import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/util/controller/timing_controller.dart';
import '../../../error/failures.dart';
import '../../../notification/notification_service.dart';
import '../../model/timing.dart';
import '../location/location_bloc.dart';

part 'timing_event.dart';
part 'timing_state.dart';

class TimingBloc extends Bloc<TimingEvent, TimingState> {
  /// storage for data to prevent unneccessary api call
  Timing? _timing;
  List<Map<String, Object>> _notificationList = [];

  /// constructor
  TimingBloc() : super(TimingInitial()) {
    on<TimingEvent>((event, emit) async {
      if (event is RequestTiming) {
        emit(TimingLoading());

        if (!(event.locationState is LocationSuccess)) {
          emit(TimingFailed(event.locationState.failure!));
        } else {
          final result = await getPrayerTiming(
            event.locationState.latitude,
            event.locationState.longitude,
            method: event.method,
            school: event.school,
            dayOffset: event.dayOffset,
            hijriAdjustmentDays: event.hijriAdjustmentDays,
          );

          result.fold(
            (failure) => emit(TimingFailed(failure)),
            (timing) => emit(TimingLoaded(timing)),
          );
        }
      } else if (event is RequestTimingForTomorrow) {
        emit(TimingLoading());

        if (!(event.locationState is LocationSuccess)) {
          emit(TimingFailed(event.locationState.failure!));
          return;
        }

        final result = await getPrayerTiming(
          event.locationState.latitude,
          event.locationState.longitude,
          forTomorrow: true,
          method: event.method,
          school: event.school,
          dayOffset: event.dayOffset,
          hijriAdjustmentDays: event.hijriAdjustmentDays,
        );

        if (result.isLeft()) {
          emit(TimingFailed(result.fold((l) => l, (r) => throw StateError(''))));
          return;
        }

        final timing = result.fold((l) => throw StateError(''), (r) => r);
        final controller = TimingController(timing.data.timings);

        _notificationList = await loadLocalNotification(controller.timingsList);

        if (event.notificationEnabled == PermissionStatus.granted) {
          await addToLocalNotification(_notificationList);
        }

        _timing = timing;

        emit(TimingLoaded(timing));
      }

      /// when initialize app and toggle switch
      ///
      else if (event is PushNotification) {
        await addToLocalNotification(_notificationList);
      }

      /// cancel all notification when toggle switch
      ///
      else if (event is CancelNotification) {
        await NotificationService().cancelAllNotifications();
      }

      /// if data is not yet outdated, we just update the data
      /// to the new [dataCount] from [TimingController]
      else if (event is UpdateTiming) {
        if (_timing != null) {
          final Timing timing = Timing(
            code: _timing!.code,
            data: _timing!.data,
            status: _timing!.status,
          );

          emit(TimingLoaded(timing));
        }
      }
    });
  }
}
