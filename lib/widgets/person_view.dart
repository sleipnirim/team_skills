import 'package:flutter/material.dart';
import 'package:team_skills/Model/person.dart';
import 'package:team_skills/storage_controller.dart';

import '../Model/skill.dart';

class PersonView extends StatefulWidget {
  const PersonView({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  final storageController = StorageController();

  bool likeSaving = false;

  Future<Map<Skill, int>> richSkills(Map<String, int>? skills) async {
    Map<Skill, int> richedSkills = {};

    skills != null
        ? richedSkills = {
            for (String skill in skills.keys)
              await storageController.getSkillByUid(skill): skills[skill]!
          }
        : richedSkills = {};

    return richedSkills;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(30),
      elevation: 20,
      borderOnForeground: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${widget.person.name} ${widget.person.surname}",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            const Divider(),
            FutureBuilder(
              future: richSkills(widget.person.skills),
              builder: (context, AsyncSnapshot<Map<Skill, int>> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                      "Error loading skills ${snapshot.error.toString()}");
                }
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    var keys = snapshot.data!.keys;
                    var types = <SkillType>{};
                    for (Skill key in keys) {
                      types.add(key.type);
                    }
                    var sortedTypes = types.toList();
                    sortedTypes.sort((a, b) => a.index - b.index);
                    return Expanded(
                      child: ListView.builder(
                        itemCount: sortedTypes.length,
                        itemBuilder: (context, index) {
                          var singleTypeSkills = Map<Skill, int>.fromEntries(
                              snapshot.data!.entries.where((element) =>
                                  element.key.type ==
                                  sortedTypes.elementAt(index)));
                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sortedTypes.elementAt(index).value,
                                  textAlign: TextAlign.left,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  //scrollDirection: Axis.vertical,
                                  itemCount: singleTypeSkills.length,
                                  itemBuilder: ((context, index) {
                                    Skill key =
                                        singleTypeSkills.keys.elementAt(index);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            key.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              likeSaving
                                                  ? const CircularProgressIndicator()
                                                  : IconButton(
                                                      icon: const Icon(
                                                        Icons.thumb_up,
                                                        size: 18,
                                                      ),
                                                      onPressed: () async {
                                                        widget.person.skills![
                                                                await storageController
                                                                    .getSkillId(
                                                                        key.name,
                                                                        key.type)] =
                                                            singleTypeSkills[
                                                                    key]! +
                                                                1;
                                                        await storageController
                                                            .updatePerson(
                                                                widget.person);
                                                      },
                                                    ),
                                              Text(
                                                  "  ${singleTypeSkills[key].toString()}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
