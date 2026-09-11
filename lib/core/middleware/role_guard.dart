import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';

class RoleGuard extends GetMiddleware {
  final String requiredRole;

  RoleGuard(this.requiredRole);

  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const RouteSettings(name: AppRoutes.welcome);
    }

    return null;
  }
}
