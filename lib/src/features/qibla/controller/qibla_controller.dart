import 'dart:math' show sin, cos, atan2, pi;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:vector_math/vector_math.dart' show radians;

import '../blocs/angle_bloc/angle_bloc.dart';

final kaabaLat = radians(21.4224779);
final kaabaLng = radians(39.8251832);

double calculateDirection(double latitude, double longitude) {
  final userLat = radians(latitude);
  final userLng = radians(longitude);
  final sinDiffLng = sin(kaabaLng - userLng);
  final cosLatEnd = cos(kaabaLat);
  final cosLatStart = cos(userLat);
  final sinLatEnd = sin(kaabaLat);
  final sinLatStart = sin(userLat);
  final cosDiffLng = cos(kaabaLng - userLng);
  final angleinRad = atan2(
    sinDiffLng * cosLatEnd,
    (cosLatStart * sinLatEnd - sinLatStart * cosLatEnd * cosDiffLng),
  );
  final angleinDeg = (angleinRad * 180 / pi + 360) % 360;
  return angleinDeg;
}

void updateEvent(CompassEvent event, BuildContext context) {
  final angle = event.heading ?? 0;
  BlocProvider.of<AngleBloc>(context).add(
    SetMagnetometerValue([angle]),
  );
}

double getCompassAngle(List<double> events) {
  if (events.isEmpty) return 0;
  final sum = events.reduce((a, b) => a + b);
  return (sum / events.length + 360) % 360;
}

Future<bool> getMagnetometerAvailability() async {
  return FlutterCompass.events != null;
}

String getDirectionText(int angle) {
  if (angle > 0 && angle < 90) return 'North-East';
  if (angle > 90 && angle < 180) return 'South-East';
  if (angle > 180 && angle < 270) return 'South-West';
  if (angle > 270 && angle < 360) return 'North-West';
  switch (angle) {
    case 0: return 'North';
    case 90: return 'East';
    case 180: return 'South';
    case 270: return 'West';
    case 360: return 'North';
    default: return '';
  }
}
