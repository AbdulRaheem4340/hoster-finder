import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import 'package:hostel_finder/core/routes/app_routes.dart';

import 'package:hostel_finder/services/auth_service.dart';
import 'package:hostel_finder/services/firestore_service.dart';
import 'package:hostel_finder/data/models/hostel_model.dart';
import 'package:hostel_finder/core/utils/app_utils.dart';

class OwnerController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<HostelModel> myHostels = <HostelModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  HostelModel? editingHostel;

  // Form Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final rentController = TextEditingController();
  final roomsController = TextEditingController();
  final availableRoomsController = TextEditingController();
  final contactController = TextEditingController();

  // Location
  final Rxn<LatLng> selectedLocation = Rxn<LatLng>();

  //  Multi-Photo Support
  static const int maxPhotos = 5;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<String> existingImageUrls = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  //  IMGBB KEY
  final String _imgBBKey = "Your_Key";

  final RxList<String> selectedFacilities = <String>[].obs;
  final List<String> availableFacilities = [
    "WiFi",
    "AC",
    "Laundry",
    "Mess",
    "Generator",
    "Attach Bath",
    "CCTV",
    "Common bath",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMyHostels();
  }

  void fetchMyHostels() {
    String? uid = _authService.user?.uid;
    if (uid != null) {
      _firestoreService.hostelStream().listen((allHostels) {
        myHostels.value = allHostels.where((h) => h.ownerId == uid).toList();
      });
    }
  }

  void toggleFacility(String facility) {
    if (selectedFacilities.contains(facility)) {
      selectedFacilities.remove(facility);
    } else {
      selectedFacilities.add(facility);
    }
  }

  void setLocation(LatLng position) {
    selectedLocation.value = position;
  }

  //  MULTI IMAGE PICKER
  Future<void> pickImages() async {
    final currentCount = selectedImages.length + existingImageUrls.length;
    final remaining = maxPhotos - currentCount;

    if (remaining <= 0) {
      AppUtils.showError("Maximum $maxPhotos photos allowed");
      return;
    }

    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 75,
      limit: remaining,
    );

    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  void removeNewImage(int index) {
    selectedImages.removeAt(index);
  }

  void removeExistingImage(int index) {
    existingImageUrls.removeAt(index);
  }

  // ☁️ Upload Single Image to ImgBB
  Future<String?> _uploadSingleImage(XFile image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$_imgBBKey'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return json.decode(responseData)['data']['url'];
      }
    } catch (e) {
      debugPrint("ImgBB Error: $e");
    }
    return null;
  }

  // ☁️ Upload All New Images in Parallel
  Future<List<String>> _uploadAllImages() async {
    if (selectedImages.isEmpty) return [];

    final futures = selectedImages.map((image) => _uploadSingleImage(image));
    final results = await Future.wait(futures);
    return results.whereType<String>().toList();
  }

  /// ✅ Centralized validation
  String? _validateForm() {
    if (nameController.text.isEmpty ||
        rentController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedLocation.value == null ||
        contactController.text.length < 11) {
      return "Please fill all fields. Contact must be 11 digits.";
    }

    final total = int.tryParse(roomsController.text) ?? 0;
    final available = int.tryParse(availableRoomsController.text) ?? -1;

    if (total <= 0) {
      return "Total rooms must be greater than 0";
    }
    if (available < 0 || available > total) {
      return "Available rooms must be between 0 and $total";
    }

    return null;
  }

  // ➕ Upload New Hostel
  Future<void> uploadHostel() async {
    final error = _validateForm();
    if (error != null) {
      AppUtils.showError(error);
      return;
    }

    if (selectedImages.isEmpty && existingImageUrls.isEmpty) {
      AppUtils.showError("Please add at least one photo");
      return;
    }

    try {
      isLoading.value = true;

      final ownerData = await _firestoreService.getUserData(
        _authService.user!.uid,
      );
      final newUrls = await _uploadAllImages();
      final allImageUrls = [...existingImageUrls, ...newUrls];

      String hostelId = const Uuid().v4();

      HostelModel newHostel = HostelModel(
        id: hostelId,
        ownerId: _authService.user!.uid,
        ownerName: ownerData?.fullName ?? "",
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        latitude: selectedLocation.value!.latitude,
        longitude: selectedLocation.value!.longitude,
        totalRooms: int.parse(roomsController.text),
        availableRooms: int.parse(availableRoomsController.text),
        rent: double.tryParse(rentController.text) ?? 0.0,
        contact: contactController.text.trim(),
        facilities: selectedFacilities.toList(),
        isActive: false,
        imageUrls: allImageUrls,
        url: null,
      );

      await _firestoreService.uploadHostel(newHostel);

      isLoading.value = false;
      Get.back();
      _clearForm();
      AppUtils.showSuccess("Hostel submitted for approval ");
    } catch (e) {
      isLoading.value = false;
      AppUtils.showError("Upload failed: $e");
    }
  }

  // ✏️ Update Existing Hostel
  Future<void> updateHostel() async {
    if (editingHostel == null) return;

    final error = _validateForm();
    if (error != null) {
      AppUtils.showError(error);
      return;
    }

    if (selectedImages.isEmpty && existingImageUrls.isEmpty) {
      AppUtils.showError("Please keep at least one photo");
      return;
    }

    try {
      isLoading.value = true;

      final newUrls = await _uploadAllImages();
      final allImageUrls = [...existingImageUrls, ...newUrls];

      HostelModel updatedHostel = HostelModel(
        id: editingHostel!.id,
        ownerId: editingHostel!.ownerId,
        ownerName: editingHostel!.ownerName,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        latitude: selectedLocation.value!.latitude,
        longitude: selectedLocation.value!.longitude,
        totalRooms: int.parse(roomsController.text),
        availableRooms: int.parse(availableRoomsController.text),
        rent: double.tryParse(rentController.text) ?? 0.0,
        contact: contactController.text.trim(),
        facilities: selectedFacilities.toList(),
        isActive: false,
        imageUrls: allImageUrls,
        url: null,
      );

      await _firestoreService.uploadHostel(updatedHostel);

      isLoading.value = false;
      Get.back();
      _clearForm();
      AppUtils.showSuccess("Hostel updated & sent for re-approval ✅");
    } catch (e) {
      isLoading.value = false;
      AppUtils.showError("Update failed: $e");
    }
  }

  // 📡 GPS Capture
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppUtils.showError("Please turn on your Phone's GPS");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      selectedLocation.value = LatLng(position.latitude, position.longitude);
      AppUtils.showSuccess("Location Captured! ");
    } catch (e) {
      AppUtils.showError("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveHostel() async {
    if (editingHostel == null) {
      await uploadHostel();
    } else {
      await updateHostel();
    }
  }

  Future<void> deleteHostel(String id) async {
    try {
      isLoading.value = true;
      await _firestoreService.deleteHostel(id);
      AppUtils.showSuccess("Hostel removed");
    } catch (e) {
      AppUtils.showError("Delete failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchLocation(String query, MapController mapController) async {
    if (query.isEmpty) return;
    try {
      isSearching.value = true;
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=1&countrycodes=pk',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'hostel_finder_app'},
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          LatLng newPos = LatLng(
            double.parse(data[0]['lat']),
            double.parse(data[0]['lon']),
          );
          selectedLocation.value = newPos;
          mapController.move(newPos, 16.0);
        }
      }
    } finally {
      isSearching.value = false;
    }
  }

  void prepareEdit(HostelModel hostel) {
    editingHostel = hostel;
    nameController.text = hostel.name;
    addressController.text = hostel.address;
    rentController.text = hostel.rent.toString();
    roomsController.text = hostel.totalRooms.toString();
    availableRoomsController.text = hostel.availableRooms.toString();
    contactController.text = hostel.contact;
    selectedFacilities.assignAll(hostel.facilities);
    selectedLocation.value = LatLng(hostel.latitude, hostel.longitude);

    // ✅ Load existing images for editing
    existingImageUrls.assignAll(hostel.allImages);
    selectedImages.clear();

    Get.toNamed(AppRoutes.addHostel);
  }

  void clearFormForNewHostel() {
    editingHostel = null;
    selectedImages.clear();
    existingImageUrls.clear();
    _clearForm();
  }

  void _clearForm() {
    nameController.clear();
    addressController.clear();
    rentController.clear();
    roomsController.clear();
    availableRoomsController.clear();
    contactController.clear();
    selectedFacilities.clear();
    selectedLocation.value = null;
    selectedImages.clear();
    existingImageUrls.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    rentController.dispose();
    roomsController.dispose();
    availableRoomsController.dispose();
    contactController.dispose();
    super.onClose();
  }
}
