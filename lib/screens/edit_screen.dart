import 'package:flutter/material.dart';
import 'package:team_skills/auth_controller.dart';

import '../shared_functions.dart';
import '../widgets/edit_view.dart';

class EditScreen extends StatelessWidget {
  static const id = "edit_screen";

  EditScreen({Key? key}) : super(key: key);

  final authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        actions: SharedFunctions.appBarLoginActions(
            context, authController.auth.currentUser!),
      ),
      body: const EditView(),
    );
  }
}
