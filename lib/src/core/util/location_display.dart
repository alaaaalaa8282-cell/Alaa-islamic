import 'package:geocoding/geocoding.dart';

String? _nonEmpty(String? s) {
  final t = s?.trim();
  if (t == null || t.isEmpty) return null;
  return t;
}

bool looksLikeCoordinates(String s) {
  final t = s.trim();
  if (RegExp(r'^-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?$').hasMatch(t)) {
    return true;
  }
  if (RegExp(r'^-?\d+\.\d+$').hasMatch(t)) return true;
  return false;
}

/// City, country style line for the home header (no lat/lng).
String cityCountryFromPlacemark(Placemark? p) {
  if (p == null) return '';

  String? city = _nonEmpty(p.locality) ??
      _nonEmpty(p.subAdministrativeArea) ??
      _nonEmpty(p.administrativeArea);

  if (city == null) {
    final name = _nonEmpty(p.name);
    if (name != null && !looksLikeCoordinates(name)) {
      city = name;
    }
  }

  final country = _nonEmpty(p.country) ?? '';

  if (city != null && country.isNotEmpty) {
    return '$city, $country';
  }
  if (city != null) return city;
  if (country.isNotEmpty) return country;

  final thoroughfare = _nonEmpty(p.thoroughfare);
  final subLocality = _nonEmpty(p.subLocality);
  if (thoroughfare != null && country.isNotEmpty) {
    return '$thoroughfare, $country';
  }
  if (subLocality != null && country.isNotEmpty) {
    return '$subLocality, $country';
  }

  return '';
}
