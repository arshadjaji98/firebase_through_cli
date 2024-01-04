import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_through_cli/ui/posts/posts_screen.dart';
// ignore: unused_import
import 'package:firebase_through_cli/utills/utility.dart';
import 'package:firebase_through_cli/widgets/rounds_button.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  final String verficationId;
  const VerifyCode({super.key, required this.verficationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final verficationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 61, 7, 255),
          centerTitle: true,
          title: const Text(
            'Verify',
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            keyboardType: const TextInputType.numberWithOptions(),
            controller: verficationCodeController,
            decoration: const InputDecoration(
                hintText: 'Enter 6 digit code',
                hintStyle: TextStyle(fontWeight: FontWeight.w100)),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final credintial = PhoneAuthProvider.credential(
                    verificationId: widget.verficationId,
                    smsCode: verficationCodeController.text.toString());
                try {
                  await auth.signInWithCredential(credintial);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
                } catch (e) {
                  setState(() {
                    loading = true;
                  });
                }
              })
        ]),
      ),
    );
  }
}
