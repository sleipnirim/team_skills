import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_skills/screens/edit_screen.dart';
import 'package:team_skills/screens/login_screen.dart';

class SharedFunctions {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static List<Widget> appBarLoginActions(
      BuildContext context, User currentUser) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: PopupMenuButton(
          child: Center(child: Text(currentUser.email ?? "No mail")),
          tooltip: _auth.currentUser!.email ?? "No mail",
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: const Text("Account"),
              onTap: () {
                Future.delayed(Duration.zero, () {
                  Navigator.pushNamed(context, EditScreen.id);
                });
              },
            ),
            PopupMenuItem(
              child: const Text("Logout"),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
      ),
    );
    return widgets;
  }

  static String? getCurrentUserMail() {
    return _auth.currentUser!.email;
  }

  static String getCurrentUserId() {
    return _auth.currentUser!.uid;
  }
}
