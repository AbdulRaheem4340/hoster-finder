import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/data/models/user_model.dart';
import 'package:hostel_finder/data/models/hostel_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //  Save/Update User
  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  //  Get User Data
  Future<UserModel?> getUserData(String uid) async {
    var doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  //  DELETE Hostel
  Future<void> deleteHostel(String hostelId) async {
    await _db.collection('hostels').doc(hostelId).delete();
  }

  //  UPLOAD/UPDATE Hostel
  Future<void> uploadHostel(HostelModel hostel) async {
    await _db.collection('hostels').doc(hostel.id).set(hostel.toMap());
  }

  //  Get ALL Hostels (For Students)
  Stream<List<HostelModel>> hostelStream() {
    return _db
        .collection('hostels')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (query) => query.docs
              .map((item) => HostelModel.fromMap(item.data()))
              .toList(),
        );
  }

  //   Get ONLY MY Hostels (For Owner Dashboard)
  // This prevents owners from seeing other owners' hostels
  Stream<List<HostelModel>> ownerHostelStream(String ownerId) {
    return _db
        .collection('hostels')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map(
          (query) => query.docs
              .map((item) => HostelModel.fromMap(item.data()))
              .toList(),
        );
  }

  //  Get all hostels (admin sees everything)
  Stream<List<HostelModel>> getAllHostelsForAdmin() {
    return _db
        .collection('hostels')
        .snapshots()
        .map(
          (query) =>
              query.docs.map((e) => HostelModel.fromMap(e.data())).toList(),
        );
  }

  //  Approve / Unapprove
  Future<void> updateHostelApproval(String id, bool status) async {
    await _db.collection('hostels').doc(id).update({'isActive': status});
  }

  //  Get all users for admin stats
  Stream<Map<String, int>> getAdminStats() {
    return _db.collection('users').snapshots().map((snapshot) {
      int totalUsers = snapshot.docs.length;
      int students = 0;
      int owners = 0;
      int admins = 0;

      for (var doc in snapshot.docs) {
        String role = doc['role'];
        if (role == 'student') students++;
        if (role == 'owner') owners++;
        if (role == 'admin') admins++;
      }

      return {
        'totalUsers': totalUsers,
        'students': students,
        'owners': owners,
        'admins': admins,
      };
    });
  }
}
