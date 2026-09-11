import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapAnimationHelper {
  MapAnimationHelper._();

  static const Duration defaultDuration = Duration(milliseconds: 700);

  static Future<void> animatedMove({
    required MapController mapController,
    required LatLng destination,
    required TickerProvider vsync,
    double? destinationZoom,
    Duration duration = defaultDuration,
    Curve curve = Curves.fastOutSlowIn,
  }) async {
    // Capture starting state
    final startLat = mapController.camera.center.latitude;
    final startLng = mapController.camera.center.longitude;
    final startZoom = mapController.camera.zoom;
    final endZoom = destinationZoom ?? startZoom;

    // Build tweens for each property
    final latTween = Tween<double>(begin: startLat, end: destination.latitude);
    final lngTween = Tween<double>(begin: startLng, end: destination.longitude);
    final zoomTween = Tween<double>(begin: startZoom, end: endZoom);

    final controller = AnimationController(duration: duration, vsync: vsync);

    final animation = CurvedAnimation(parent: controller, curve: curve);

    // Update map on every frame
    controller.addListener(() {
      mapController.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    // Cleanup when done
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    await controller.forward();
  }
}