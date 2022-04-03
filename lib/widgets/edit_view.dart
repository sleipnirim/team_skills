import 'package:flutter/material.dart';
import 'package:team_skills/Model/person.dart';
import 'package:team_skills/auth_controller.dart';
import 'package:team_skills/screens/persons_screen.dart';
import 'package:team_skills/shared_functions.dart';
import 'package:team_skills/storage_controller.dart';
import 'package:team_skills/widgets/chips_row.dart';

import '../Model/skill.dart';
import 'edit_area.dart';

class EditView extends StatefulWidget {
  const EditView({Key? key}) : super(key: key);

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  late String name;
  late String surname;
  late TextEditingController nameTextEditingController;
  late TextEditingController surnameTextEditingController;
  List<String> skillsUids = [];
  Map<Skill, SkillHolder?> skills = {};
  late AuthController authController;
  late StorageController storageController;
  Person? person;

  var savingPersonInProgress = false;

  var addChipAreaVisible = <SkillType, bool>{};
  var chipAddInProgress = <SkillType, bool>{};
  var chipTextEditingController = <SkillType, TextEditingController>{};

  var errorText = "";

  bool isDataLoaded = false;

  @override
  initState() {
    super.initState();
    nameTextEditingController = TextEditingController();
    surnameTextEditingController = TextEditingController();
    authController = AuthController();
    storageController = StorageController();

    for (SkillType type in SkillType.values) {
      addChipAreaVisible[type] = false;
      chipAddInProgress[type] = false;
      chipTextEditingController[type] = TextEditingController();
    }
  }

  Future<void> prepareData() async {
    if (!isDataLoaded) {
      var uid = authController.auth.currentUser!.uid;

      if (await storageController.checkIfPersonExists(uid)) {
        person = await storageController.getPerson(uid);
        skillsUids = person?.skills?.map((e) => e.skillId).toList() ?? [];
        for (String uid in skillsUids) {
          var skill = await storageController.getSkillByUid(uid);
          skills[skill] =
              person?.skills?.firstWhere((element) => element.skillId == uid);
        }
      }
      nameTextEditingController.text = person?.name ?? "";
      surnameTextEditingController.text = person?.surname ?? "";
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prepareData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: UnconstrainedBox(
            constrainedAxis: Axis.horizontal,
            child: Card(
              elevation: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: SizedBox(
                      width: 500,
                      child: Center(
                        child: TextFormField(
                          enabled: false,
                          initialValue:
                              SharedFunctions.getCurrentUserMail() ?? "No mail",
                        ),
                      ),
                    ),
                  ),
                  Text(
                    errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                  EditArea(
                    name: 'name',
                    textEditingController: nameTextEditingController,
                  ),
                  EditArea(
                    name: 'surname',
                    textEditingController: surnameTextEditingController,
                  ),
                  for (SkillType type in SkillType.values)
                    ChipsRow(
                      type: type,
                      skills: Map.fromEntries(skills.entries
                          .where((element) => element.key.type == type)),
                      onDeleted: (skill) async {
                        var uid = await storageController.getSkillId(
                            skill.name, skill.type);
                        setState(() {
                          skillsUids.remove(uid);
                          skills.remove(skill);
                          person?.skills?.removeWhere(
                              (element) => element.skillId == uid);
                        });
                      },
                      addChipAreaVisible: addChipAreaVisible[type]!,
                      textEditingController: chipTextEditingController[type]!,
                      storageController: storageController,
                      onRatingUpdate: (skill, rating) {
                        setState(() {
                          skills[skill]?.rating = rating as int;
                          person?.skills
                              ?.firstWhere((element) =>
                                  element.skillId == skills[skill]?.skillId)
                              .rating = rating as int;
                        });
                      },
                      onSuggestionSelected: (Skill skill) async {
                        setState(() {
                          chipAddInProgress[type] = true;
                        });
                        var skillUid = await storageController.getSkillId(
                            skill.name, skill.type);
                        setState(() {
                          skills[skill] = SkillHolder(skillId: skillUid);
                          skillsUids.add(skillUid);
                          person?.skills?.add(SkillHolder(skillId: skillUid));
                          chipAddInProgress[type] = false;
                          addChipAreaVisible[type] = false;
                          chipTextEditingController[type]!.clear();
                        });
                      },
                      chipAddInProgress: chipAddInProgress[type]!,
                      onPressed: () async {
                        if (!(addChipAreaVisible[type] ?? false)) {
                          setState(() {
                            addChipAreaVisible[type] = true;
                          });
                        } else {
                          if (chipTextEditingController[type]!
                              .text
                              .trim()
                              .isNotEmpty) {
                            setState(() {
                              chipAddInProgress[type] = true;
                            });
                            var skillUid = await storageController.getSkillId(
                                chipTextEditingController[type]!.text, type);
                            setState(() {
                              skills[(Skill(
                                  name: chipTextEditingController[type]!.text,
                                  type:
                                      type))] = SkillHolder(skillId: skillUid);
                              skillsUids.add(skillUid);
                              person?.skills
                                  ?.add(SkillHolder(skillId: skillUid));
                              chipAddInProgress[type] = false;
                              addChipAreaVisible[type] = false;
                              chipTextEditingController[type]!.clear();
                            });
                          } else {
                            setState(() {
                              errorText = "Skill name can't be empty";
                            });
                          }
                        }
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            savingPersonInProgress = true;
                          });
                          if (nameTextEditingController.text
                                  .trim()
                                  .isNotEmpty &&
                              surnameTextEditingController.text
                                  .trim()
                                  .isNotEmpty) {
                            if (person != null) {
                              person!.name = nameTextEditingController.text;
                              person!.surname =
                                  surnameTextEditingController.text;
                              await storageController.updatePerson(person!);
                            } else {
                              await storageController.addPerson(
                                Person(
                                  uid: authController.auth.currentUser!.uid,
                                  name: nameTextEditingController.text,
                                  surname: surnameTextEditingController.text,
                                  skills: skillsUids
                                      .map((e) => SkillHolder(skillId: e))
                                      .toList(),
                                ),
                              );
                            }
                            Navigator.pushReplacementNamed(
                                context, PersonScreen.id);
                          } else {
                            setState(() {
                              errorText = "Name or surname can't be empty";
                            });
                          }
                          setState(() {
                            savingPersonInProgress = false;
                          });
                        },
                        child: savingPersonInProgress
                            ? const CircularProgressIndicator()
                            : const Text("Save")),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    surnameTextEditingController.dispose();
    for (TextEditingController controller in chipTextEditingController.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
