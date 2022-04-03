import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_skills/Model/person.dart';
import 'package:team_skills/shared_functions.dart';
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

  Future<Map<Skill, SkillHolder>> richSkills(List<SkillHolder>? skills) async {
    Map<Skill, SkillHolder> richedSkills = {};

    skills != null
        ? richedSkills = {
            for (String skillId in skills.map((e) => e.skillId).toList())
              await storageController.getSkillByUid(skillId):
                  skills.firstWhere((element) => element.skillId == skillId)
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              builder:
                  (context, AsyncSnapshot<Map<Skill, SkillHolder>> snapshot) {
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
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: sortedTypes.length,
                      itemBuilder: (context, index) {
                        var singleTypeSkills =
                            Map<Skill, SkillHolder>.fromEntries(
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
                                  List keys = singleTypeSkills.keys.toList();
                                  keys.sort((a, b) => a.name.compareTo(b.name));
                                  Skill key = keys.elementAt(index);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              key.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            RatingBar.builder(
                                              itemCount: 3,
                                              itemPadding:
                                                  const EdgeInsets.all(1),
                                              initialRating:
                                                  singleTypeSkills[key]
                                                          ?.rating
                                                          .toDouble() ??
                                                      0,
                                              itemSize: 15,
                                              itemBuilder:
                                                  (context, position) => Stack(
                                                alignment: Alignment.center,
                                                children: const [
                                                  FaIcon(
                                                    FontAwesomeIcons.diamond,
                                                    color: Colors.black,
                                                    size: 20,
                                                  ),
                                                  FaIcon(
                                                    FontAwesomeIcons.diamond,
                                                    color: Colors.redAccent,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                              onRatingUpdate: (double value) {},
                                              ignoreGestures: true,
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            likeSaving
                                                ? const CircularProgressIndicator()
                                                : IconButton(
                                                    icon: FutureBuilder(
                                                      future: storageController
                                                          .isLiked(
                                                              singleTypeSkills[
                                                                      key]
                                                                  ?.likes,
                                                              SharedFunctions
                                                                  .getCurrentUserId()),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          return snapshot.data!
                                                              ? const Icon(Icons
                                                                  .thumb_up)
                                                              : const Icon(Icons
                                                                  .thumb_up_outlined);
                                                        } else {
                                                          return const CircularProgressIndicator();
                                                        }
                                                      },
                                                    ),
                                                    iconSize: 18,
                                                    splashRadius: 20,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 10, 5, 10),
                                                    onPressed: () async {
                                                      if (await storageController
                                                          .isLiked(
                                                              singleTypeSkills[
                                                                      key]
                                                                  ?.likes,
                                                              SharedFunctions
                                                                  .getCurrentUserId())) {
                                                        var skillId =
                                                            await storageController
                                                                .getSkillId(
                                                                    key.name,
                                                                    key.type);
                                                        var likeId = await storageController
                                                            .deleteLike(
                                                                singleTypeSkills[
                                                                        key]
                                                                    ?.likes,
                                                                SharedFunctions
                                                                    .getCurrentUserId());
                                                        widget.person.skills!
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .skillId ==
                                                                    skillId)
                                                            .likes
                                                            .remove(likeId);
                                                        await storageController
                                                            .updatePerson(
                                                                widget.person);
                                                      } else {
                                                        var skillId =
                                                            await storageController
                                                                .getSkillId(
                                                                    key.name,
                                                                    key.type);
                                                        var likeId =
                                                            await storageController
                                                                .addLike(
                                                                    SharedFunctions
                                                                        .getCurrentUserId(),
                                                                    skillId);
                                                        widget.person.skills
                                                            ?.firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .skillId ==
                                                                    skillId)
                                                            .likes
                                                            .add(likeId);
                                                        await storageController
                                                            .updatePerson(
                                                                widget.person);
                                                      }
                                                    },
                                                  ),
                                            Text(
                                                "  ${singleTypeSkills[key]?.likes.length ?? "0"}"),
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
                    );
                  }
                  return const Text('No skills');
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
