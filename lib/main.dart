import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team_skills/auth_controller.dart';
import 'package:team_skills/screens/edit_screen.dart';
import 'package:team_skills/screens/login_screen.dart';
import 'package:team_skills/screens/persons_screen.dart';
import 'package:team_skills/screens/registration_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  await FirebaseAuth.instance.authStateChanges().first;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final authController = AuthController();

  Widget homeScreenRoute() {
    if (authController.auth.currentUser != null) {
      return PersonScreen();
    } else {
      return const LoginScreen();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Skills',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        PersonScreen.id: (context) => PersonScreen(),
        EditScreen.id: (context) => EditScreen(),
      },
      home: homeScreenRoute(),
    );
  }
}
