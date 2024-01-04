import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_through_cli/ui/auth/verify_code.dart';
import 'package:firebase_through_cli/utills/utility.dart';
import 'package:firebase_through_cli/widgets/rounds_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 61, 7, 255),
          centerTitle: true,
          title: const Text(
            'Login with Phone Number',
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: phoneNumberController,
            decoration: const InputDecoration(
                hintText: '+92 321 1234567',
                hintStyle: TextStyle(fontWeight: FontWeight.w100)),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                      // print("error ${e}");
                    },
                    codeSent: (String verficationId, int? token) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyCode(
                                    verficationId: verficationId,
                                  )));
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    });
              })
        ]),
      ),
    );
  }
}
