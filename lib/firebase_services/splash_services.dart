import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_through_cli/ui/auth/login_screen.dart';
import 'package:firebase_through_cli/ui/posts/posts_screen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    // ignore: unused_local_variable
    final auth = FirebaseAuth.instance;
    // ignore: unused_local_variable
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
