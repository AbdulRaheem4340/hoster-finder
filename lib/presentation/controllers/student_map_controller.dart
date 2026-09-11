import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/utils/distance_helper.dart';
import 'package:hostel_finder/data/models/hostel_model.dart';
import 'package:hostel_finder/presentation/widget/map_animation_helper.dart';
import 'package:hostel_finder/services/firestore_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:hostel_finder/core/utils/app_utils.dart';

class StudentMapController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final MapController mapController = MapController();

  final RxList<HostelModel> allHostels = <HostelModel>[].obs;
  final RxList<HostelModel> filteredHostels = <HostelModel>[].obs;
  final Rxn<HostelModel> selectedHostel = Rxn<HostelModel>();

  final Rx<LatLng> studentLocation = const LatLng(30.3753, 69.3451).obs;
  final RxBool isLoading = true.obs;

  final RxDouble maxRent = 20000.0.obs;
  final RxList<String> selectedFacilities = <String>[].obs;

  final RxString selectedSortType = 'default'.obs;

  Worker? _hostelWorker;
  TickerProvider? _vsync;

  void attachVsync(TickerProvider vsync) {
    _vsync = vsync;
  }

  void _animateTo(LatLng destination, {double? zoom}) {
    if (_vsync != null) {
      MapAnimationHelper.animatedMove(
        mapController: mapController,
        destination: destination,
        destinationZoom: zoom,
        vsync: _vsync!,
      );
    } else {
      mapController.move(destination, zoom ?? mapController.camera.zoom);
    }
  }

  @override
  void onInit() {
    super.onInit();

    allHostels.bindStream(_firestoreService.hostelStream());
    _hostelWorker = ever(allHostels, (list) => filteredHostels.assignAll(list));

    _initStudentDashboard();
  }

  Future<void> _initStudentDashboard() async {
    try {
      isLoading.value = false;

      await _handlePermissions();
    } catch (e) {
      debugPrint("Init Error: $e");
    }
  }

  Future<void> _handlePermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppUtils.showError("Please turn ON your phone's GPS");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position? lastPos = await Geolocator.getLastKnownPosition();
    if (lastPos != null) {
      LatLng instantPos = LatLng(lastPos.latitude, lastPos.longitude);

      studentLocation.value = instantPos;
    }

    _getFreshGPS();
  }

  Future<void> _getFreshGPS() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (position.latitude.isFinite && position.longitude.isFinite) {
        LatLng newPos = LatLng(position.latitude, position.longitude);
        studentLocation.value = newPos;

        if (_vsync != null) {
          _animateTo(newPos, zoom: 14.0);
        }
      }
    } catch (e) {
      debugPrint("Background GPS Update failed: $e");
    }
  }

  void filterByCity(String query) {
    if (query.isEmpty) {
      filteredHostels.assignAll(allHostels);
    } else {
      var result = allHostels
          .where(
            (h) =>
                h.address.toLowerCase().contains(query.toLowerCase()) ||
                h.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      filteredHostels.assignAll(result);
      if (result.isNotEmpty) {
        _animateTo(LatLng(result[0].latitude, result[0].longitude), zoom: 14.0);
      }
    }
  }

  void selectHostel(HostelModel hostel) {
    selectedHostel.value = hostel;
    _animateTo(LatLng(hostel.latitude, hostel.longitude), zoom: 16.0);
  }

  void applyFilters() {
    var result = allHostels.where((hostel) {
      bool matchPrice = hostel.rent <= maxRent.value;
      bool matchFacilities =
          selectedFacilities.isEmpty ||
          selectedFacilities.every((f) => hostel.facilities.contains(f));
      return matchPrice && matchFacilities;
    }).toList();

    filteredHostels.assignAll(result);

    _applySorting();

    if (Get.isBottomSheetOpen ?? false) Get.back();

    if (result.isEmpty) {
      AppUtils.showError("No hostels match these filters");
    }
  }

  void changeSortType(String newType) {
    selectedSortType.value = newType;

    _applySorting();
  }

  void _applySorting() {
    final list = filteredHostels.toList();

    switch (selectedSortType.value) {
      case 'distance':
        _sortByDistance(list);
        break;

      case 'default':
      default:
        break;
    }

    filteredHostels.assignAll(list);
  }

  void _sortByDistance(List<HostelModel> list) {
    final userLoc = studentLocation.value;

    if (!DistanceHelper.isValidLocation(userLoc)) {
      AppUtils.showError("Waiting for GPS... please try again");
      return;
    }

    final Map<String, double> distanceCache = {};

    for (final hostel in list) {
      distanceCache[hostel.id] = DistanceHelper.inKilometers(
        userLoc,
        LatLng(hostel.latitude, hostel.longitude),
      );
    }

    list.sort((a, b) {
      final distA = distanceCache[a.id] ?? double.infinity;
      final distB = distanceCache[b.id] ?? double.infinity;

      return distA.compareTo(distB);
    });
  }

  void toggleFilterFacility(String facility) {
    if (selectedFacilities.contains(facility)) {
      selectedFacilities.remove(facility);
    } else {
      selectedFacilities.add(facility);
    }
  }

  String? distanceToHostel(double hostelLat, double hostelLng) {
    final userLoc = studentLocation.value;

    if (!DistanceHelper.isValidLocation(userLoc)) {
      return null;
    }

    return DistanceHelper.formatted(userLoc, LatLng(hostelLat, hostelLng));
  }

  void resetFilters() {
    maxRent.value = 20000.0;
    selectedFacilities.clear();
    filteredHostels.assignAll(allHostels);
    selectedSortType.value = 'default';
    if (Get.isBottomSheetOpen ?? false) Get.back();
  }

  Future<void> locateMe() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppUtils.showError("Please turn ON your GPS");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position? lastPos = await Geolocator.getLastKnownPosition();
      if (lastPos != null) {
        LatLng instantPos = LatLng(lastPos.latitude, lastPos.longitude);
        studentLocation.value = instantPos;
        _animateTo(instantPos, zoom: 14.0);
      }

      Position freshPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (freshPos.latitude.isFinite && freshPos.longitude.isFinite) {
        LatLng accuratePos = LatLng(freshPos.latitude, freshPos.longitude);
        studentLocation.value = accuratePos;
        _animateTo(accuratePos, zoom: 15.0);
      }
    } catch (e) {
      AppUtils.showError("Unable to locate you");
    }
  }

  @override
  void onClose() {
    _hostelWorker?.dispose();
    super.onClose();
  }

  void clearSelection() => selectedHostel.value = null;
}
