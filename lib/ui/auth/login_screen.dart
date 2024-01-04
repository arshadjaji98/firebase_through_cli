import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_through_cli/ui/auth/login_with_phone_number.dart';
import 'package:firebase_through_cli/ui/auth/signup_screen.dart';
import 'package:firebase_through_cli/ui/posts/posts_screen.dart';
import 'package:firebase_through_cli/utills/utility.dart';
import 'package:firebase_through_cli/widgets/rounds_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          title: const Text(
            'Log in ',
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
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have account?',
                      style: TextStyle(fontSize: 15)),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: const Text(
                        'SignUp',
                        style: TextStyle(fontSize: 15),
                      )),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginWithPhoneNumber()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.blue)),
                  child: const Center(
                    child: Text(
                      'Login with Phone Number',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
