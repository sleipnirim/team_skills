import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_skills/Model/person.dart';
import 'package:team_skills/shared_functions.dart';
import 'package:team_skills/storage_controller.dart';

import '../widgets/person_view.dart';

class PersonScreen extends StatelessWidget {
  static String id = 'person_screen';

  final title = "TeamSkills";

  PersonScreen({Key? key}) : super(key: key);

  final storageController = StorageController();

  Future<List<Widget>> personGridBuilder() async {
    //final StorageController storageController = StorageController();

    List<QueryDocumentSnapshot<Person>> document =
        await storageController.persons.get().then((snapshot) => snapshot.docs);

    return List.generate(
        document.length,
        (index) => PersonView(
              person: document[index].data(),
              //storageController: storageController,
            ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
          actions: SharedFunctions.appBarLoginActions(context),
        ),
        body: StreamBuilder(
          stream: storageController.persons.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Person>> snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 3,
                children: snapshot.data!.docs
                    .map((e) => PersonView(
                          person: e.data(),
                        ))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading persons'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
