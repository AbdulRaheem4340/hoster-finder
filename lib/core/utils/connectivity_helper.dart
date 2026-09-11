import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityHelper {
  ConnectivityHelper._();

  static final Connectivity _connectivity = Connectivity();

  static Future<bool> hasInternet() async {
    try {
      final results = await _connectivity.checkConnectivity();

      return results.any(
        (result) =>
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet,
      );
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      return false;
    }
  }

  static Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any(
        (result) =>
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet,
      );
    });
  }
}
