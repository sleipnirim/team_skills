import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:team_skills/auth_controller.dart';
import 'package:team_skills/screens/edit_screen.dart';
import 'package:team_skills/screens/persons_screen.dart';
import 'package:team_skills/screens/registration_screen.dart';
import 'package:team_skills/storage_controller.dart';

import '../constraints.dart';

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
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Text("TeamSkills"),
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
                      SizedBox(
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
                      SizedBox(
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
                            try {
                              await authController.auth
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.pushReplacementNamed(
                                  context, PersonScreen.id);
                              setState(() {
                                saving = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                errorInfo = e.message;
                                saving = false;
                              });
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            SignInButton(Buttons.Google, onPressed: () async {
                          setState(() {
                            saving = true;
                          });
                          var googleProvider =
                              authController.googleAuthProvider;

                          UserCredential credentials = await authController.auth
                              .signInWithPopup(googleProvider);
                          if (credentials.user != null) {
                            if (await storageController
                                .checkIfPersonExists(credentials.user!.uid)) {
                              Navigator.pushReplacementNamed(
                                  context, PersonScreen.id);
                            } else {
                              Future.delayed(Duration.zero, () {
                                Navigator.pushReplacementNamed(
                                    context, EditScreen.id);
                              });
                            }
                          } else {
                            setState(() {
                              saving = false;
                              errorInfo = "Error signing with Google";
                            });
                          }
                        }),
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
