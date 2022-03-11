import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:team_skills/auth_controller.dart';
import 'package:team_skills/screens/edit_screen.dart';

import '../constraints.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final authController = AuthController();
  late String email;
  late String password;
  bool saving = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        opacity: 0.5,
        inAsyncCall: saving,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Text('TeamSkills'),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 48.0,
                        child: Text(
                          errorText ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kInputTextDecoration.copyWith(
                          hintText: 'Enter your email',
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kInputTextDecoration.copyWith(
                          hintText: 'Enter your password',
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (email.contains('@a1.by')) {
                            try {
                              await authController.auth
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              setState(() {
                                saving = true;
                              });
                              Future.delayed(Duration.zero, () {
                                Navigator.pushReplacementNamed(
                                    context, EditScreen.id);
                              });
                              setState(() {
                                saving = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                errorText = e.message;
                                saving = false;
                              });
                            }
                          } else {
                            setState(() {
                              saving = false;
                              errorText = "Email must be in company domain";
                            });
                          }
                        },
                        child: const Text("Register"),
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
