part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  final double latitude;
  final double longitude;
  final LocalFailure? failure;
  final Geometry? geometry;

  const LocationState(
    this.latitude,
    this.longitude, {
    this.failure,
    this.geometry,
  });
}

class LocationInitial extends LocationState {
  const LocationInitial(
      super.latitude, super.longitude, LocalFailure failure, Geometry? geometry)
      : super(failure: failure, geometry: geometry);

  @override
  List<Object?> get props => [latitude, longitude, geometry];
}

class LocationLoading extends LocationState {
  const LocationLoading(super.latitude, super.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class LocationSuccess extends LocationState {
  final Placemark? placemark;

  const LocationSuccess(
    super.latitude,
    super.longitude,
    Geometry? geometry, {
    this.placemark,
  }) : super(geometry: geometry);

  @override
  List<Object?> get props => [latitude, longitude, geometry, placemark];
}

class LocationFailed extends LocationState {
  const LocationFailed(super.latitude, super.longitude, LocalFailure failure)
      : super(failure: failure);

  @override
  List<Object?> get props => [latitude, longitude, failure];
}
