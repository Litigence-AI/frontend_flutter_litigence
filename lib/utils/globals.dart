import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';

class Globals {
  const Globals._();

  static final auth = FirebaseAuth.instance;

  static User? get firebaseUser => auth.currentUser;

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();



  // Primary legal base URL (change this as needed)
  static const legalBaseUrl = 'https://litigence-ai.tech';
  
  // Fallback base URL in case the primary fails
  static const legalFallbackBaseUrl = 'https://litigence-ai.web.app';
}
