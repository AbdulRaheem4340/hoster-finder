import 'package:latlong2/latlong.dart';

class DistanceHelper {
  DistanceHelper._();

  static const Distance _distance = Distance();

  static double inMeters(LatLng from, LatLng to) {
    return _distance.as(LengthUnit.Meter, from, to);
  }

  static double inKilometers(LatLng from, LatLng to) {
    return _distance.as(LengthUnit.Kilometer, from, to);
  }

  static String formatted(LatLng from, LatLng to) {
    final meters = inMeters(from, to);

    if (meters < 1000) {
      return "${meters.toStringAsFixed(0)} m away";
    } else {
      final km = meters / 1000;
      return "${km.toStringAsFixed(1)} km away";
    }
  }

  static bool isValidLocation(LatLng point) {
    return point.latitude.isFinite &&
        point.longitude.isFinite &&
        point.latitude != 0 &&
        point.longitude != 0;
  }
}
