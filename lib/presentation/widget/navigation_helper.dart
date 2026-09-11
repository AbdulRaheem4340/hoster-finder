import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationHelper {
  NavigationHelper._();

  static Future<bool> openDirections({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=$latitude,$longitude'
        '&travelmode=driving',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        return await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      }

      // Fallback: open in browser
      return await launchUrl(googleMapsUrl);
    } catch (e) {
      debugPrint("Navigation Error: $e");
      return false;
    }
  }

  /// Opens a map app showing only the location pin (no navigation).
  /// Useful for "View on Map" feature.
  static Future<bool> openLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      final query = label != null
          ? '$latitude,$longitude($label)'
          : '$latitude,$longitude';

      final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query',
      );

      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return await launchUrl(url);
    } catch (e) {
      debugPrint("Open Location Error: $e");
      return false;
    }
  }
}
