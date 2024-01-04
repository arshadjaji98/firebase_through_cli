import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_through_cli/ui/auth/login_screen.dart';
import 'package:firebase_through_cli/utills/utility.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: Icon(Icons.logout))
          ],
          title: const Text(
            'Post Screen',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
