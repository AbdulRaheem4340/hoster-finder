

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/utils/connectivity_helper.dart';

///  Centralized authentication service for the entire app.
class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable user (Listens to Firebase changes automatically)
  final Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  ///  Register a new user
  Future<UserCredential> register(String email, String password) async {
    if (!await ConnectivityHelper.hasInternet()) {
      throw NoInternetException();
    }
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(), 
      password: password,
    );
  }

  ///  Login an existing user
  Future<UserCredential> login(String email, String password) async {
    if (!await ConnectivityHelper.hasInternet()) {
      throw NoInternetException();
    }
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),   
      password: password,
    );
  }

  ///  Sign out the current user
  Future<void> logout() async => await _auth.signOut();
}

///  Custom exception thrown when the device has no internet connection.
class NoInternetException implements Exception {
  final String message;
  NoInternetException([
    this.message =
        "No internet connection. Please check your WiFi or mobile data.",
  ]);

  @override
  String toString() => message;
}
