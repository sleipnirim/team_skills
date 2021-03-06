import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:team_skills/Model/person.dart';
import 'package:team_skills/auth_controller.dart';
import 'package:team_skills/shared_functions.dart';
import 'package:team_skills/storage_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/person_view.dart';

class PersonScreen extends StatelessWidget {
  static String id = 'person_screen';

  final title = "TeamSkills";

  PersonScreen({Key? key}) : super(key: key);

  final storageController = StorageController();
  final authController = AuthController();

  Future<List<Widget>> personGridBuilder() async {
    final StorageController storageController = StorageController();

    List<QueryDocumentSnapshot<Person>> document =
        await storageController.persons.get().then((snapshot) => snapshot.docs);

    var personsList = List<Person>.empty(growable: true);
    for (QueryDocumentSnapshot<Person> person in document) {
      personsList.add(person.data());
    }
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
        title: Hero(
          tag: 'logo',
          child: Text(title),
        ),
        actions: SharedFunctions.appBarLoginActions(
            context, authController.auth.currentUser!),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: StreamBuilder(
              stream: storageController.persons.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Person>> snapshot) {
                if (snapshot.hasData) {
                  return MasonryGridView.count(
                    itemCount: snapshot.data!.size,
                    crossAxisCount: MediaQuery.of(context).size.width > 1200
                        ? 3
                        : MediaQuery.of(context).size.width > 800
                            ? 2
                            : 1,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return PersonView(
                          person: snapshot.data!.docs[index].data());
                    },
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
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black38),
                  children: [
                    const TextSpan(
                      text: 'Created by Vladislav Zhukovskii with ',
                    ),
                    TextSpan(
                      text: 'Flutter',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://flutter.dev');
                        },
                    ),
                    const TextSpan(text: '. '),
                    TextSpan(
                        text: 'Source',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://github.com/sleipnirim/team_skills');
                          }),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ],
      ),
    );
  }
}
