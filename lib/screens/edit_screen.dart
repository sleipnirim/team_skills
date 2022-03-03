import 'package:flutter/material.dart';

import '../shared_functions.dart';
import '../widgets/edit_view.dart';

class EditScreen extends StatelessWidget {
  static const id = "edit_screen";

  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        actions: SharedFunctions.appBarLoginActions(context),
      ),
      body: const EditView(),
    );
  }
}
