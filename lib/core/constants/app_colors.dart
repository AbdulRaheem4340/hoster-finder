import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // PRIMARY
  static const Color primary       = Color(0xFF2563EB); 
  static const Color primaryLight  = Color(0xFFEFF6FF);
  static const Color primaryDark   = Color(0xFF1D4ED8);

  //  SECONDARY 
  static const Color secondary     = Color(0xFF10B981); 
  static const Color secondaryLight = Color(0xFFECFDF5);

  //  OWNER THEME 
  static const Color ownerPrimary  = Color(0xFF7C3AED); 
  static const Color ownerLight    = Color(0xFFF5F3FF);

  //  NEUTRAL 
  static const Color white         = Color(0xFFFFFFFF);
  static const Color black         = Color(0xFF000000);
  static const Color background    = Color(0xFFF8FAFC);
  static const Color surface       = Color(0xFFFFFFFF);

  //  TEXT 
  static const Color textPrimary   = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint      = Color(0xFF94A3B8);

  //  GREY 
  static const Color grey100       = Color(0xFFF1F5F9);
  static const Color grey200       = Color(0xFFE2E8F0);
  static const Color grey300       = Color(0xFFCBD5E1);
  static const Color grey400       = Color(0xFF94A3B8);

  //  STATUS 
  static const Color success       = Color(0xFF10B981);
  static const Color error         = Color(0xFFEF4444);
  static const Color warning       = Color(0xFFF59E0B);
  static const Color info          = Color(0xFF3B82F6);

  //  SHADOW 
  static Color shadow = Colors.black.withValues(alpha:0.08);
}