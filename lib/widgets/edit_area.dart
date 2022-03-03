import 'package:flutter/material.dart';

class EditArea extends StatelessWidget {
  EditArea({Key? key, required this.name, required this.textEditingController})
      : super(key: key);

  final String name;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
