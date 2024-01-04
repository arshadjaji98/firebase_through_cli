//ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_through_cli/utills/utility.dart';
import 'package:firebase_through_cli/widgets/rounds_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        title: const Text(
          'Sign up ',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Email',
                          // helperText: 'abc@gmail.com',
                          prefixIcon: Icon(Icons.mail)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email please';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Enter password',
                          // helperText: 'abc@gmail.com',
                          prefixIcon: Icon(Icons.key),
                          suffixIcon: Icon(Icons.visibility)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter passward please';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
              title: 'Sign Up',
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  _auth
                      .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have account',
                    style: TextStyle(fontSize: 15)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'LogIn',
                      style: TextStyle(fontSize: 15),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
