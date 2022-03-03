import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

  AuthController() {
    googleAuthProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
  }
}
