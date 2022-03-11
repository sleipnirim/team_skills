import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:team_skills/auth_controller.dart';
import 'package:team_skills/screens/persons_screen.dart';
import 'package:team_skills/screens/registration_screen.dart';
import 'package:team_skills/storage_controller.dart';

import '../constraints.dart';
import 'edit_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = AuthController();
  late String email;
  late String password;
  String? errorInfo;
  bool saving = false;

  StorageController storageController = StorageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: saving,
        opacity: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Center(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Text(
                      "TeamSkills",
                      style:
                          TextStyle(fontSize: 70, fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 48.0,
                        child: Text(errorInfo ?? ""),
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kInputTextDecoration.copyWith(
                            hintText: 'Enter your email'),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kInputTextDecoration.copyWith(
                            hintText: 'Enter your password'),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButtonTheme.of(context).style,
                          onPressed: () async {
                            setState(() {
                              saving = true;
                            });
                            if (email.contains('@a1.by')) {
                              try {
                                var userCredentials = await authController.auth
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);
                                if (userCredentials.user != null) {
                                  if (await storageController
                                      .checkIfPersonExists(
                                          userCredentials.user!.uid)) {
                                    Navigator.pushReplacementNamed(
                                        context, PersonScreen.id);
                                  } else {
                                    Future.delayed(Duration.zero, () {
                                      Navigator.pushReplacementNamed(
                                          context, EditScreen.id);
                                    });
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  errorInfo = e.message;
                                  saving = false;
                                });
                              }
                            } else {
                              setState(() {
                                saving = false;
                                errorInfo = "Email must be in company domain";
                              });
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegistrationScreen.id);
                            },
                            child: const Text("Register")),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
