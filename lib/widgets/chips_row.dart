import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_skills/Model/person.dart';
import 'package:team_skills/storage_controller.dart';

import '../Model/skill.dart';

class ChipsRow extends StatelessWidget {
  const ChipsRow(
      {Key? key,
      required this.type,
      required this.skills,
      required this.onDeleted,
      required this.addChipAreaVisible,
      required this.textEditingController,
      required this.storageController,
      required this.onSuggestionSelected,
      required this.chipAddInProgress,
      required this.onPressed,
      required this.onRatingUpdate})
      : super(key: key);

  final SkillType type;
  final Map<Skill, SkillHolder?> skills;
  final Function(Skill) onDeleted;
  final bool addChipAreaVisible;
  final TextEditingController textEditingController;
  final StorageController storageController;
  final Function(Skill) onSuggestionSelected;
  final bool chipAddInProgress;
  final Function() onPressed;
  final Function(Skill, double) onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(type.value),
        Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (skills.isNotEmpty)
              for (Skill skill in skills.keys)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black12,
                      ),
                      child: Row(
                        children: [
                          Text(skill.name),
                          RatingBar.builder(
                            itemCount: 3,
                            itemSize: 20,
                            initialRating:
                                skills[skill]?.rating.toDouble() ?? 0,
                            unratedColor: Colors.black26,
                            itemPadding: const EdgeInsets.all(3),
                            itemBuilder: (context, position) => Stack(
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
                            onRatingUpdate: (rating) {
                              onRatingUpdate(skill, rating);
                            },
                          ),
                          IconButton(
                            //onPressed: ,
                            icon: const FaIcon(
                              FontAwesomeIcons.circleXmark,
                              size: 20,
                            ),
                            onPressed: () {
                              onDeleted(skill);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            if (addChipAreaVisible)
              SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: textEditingController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    minCharsForSuggestions: 1,
                    suggestionsCallback: (pattern) {
                      return storageController.getSkillForAutocomplete(
                          pattern, type);
                    },
                    itemBuilder: (context, Skill skill) {
                      return ListTile(
                        title: Text(skill.name),
                      );
                    },
                    onSuggestionSelected: onSuggestionSelected,
                  ),
                ),
              ),
            chipAddInProgress
                ? const CircularProgressIndicator()
                : IconButton(onPressed: onPressed, icon: const Icon(Icons.add))
          ],
        ),
      ],
    );
  }
}
