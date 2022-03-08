import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
      required this.onPressed})
      : super(key: key);

  final SkillType type;
  final List<Skill> skills;
  final Function(Skill) onDeleted;
  final bool addChipAreaVisible;
  final TextEditingController textEditingController;
  final StorageController storageController;
  final Function(Skill) onSuggestionSelected;
  final bool chipAddInProgress;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(type.value),
        Row(
          children: [
            Row(
              children: [
                if (skills.isNotEmpty)
                  for (Skill skill in skills)
                    Chip(
                      label: Text(skill.name),
                      onDeleted: () {
                        onDeleted(skill);
                      },
                    ),
              ],
            ),
            Row(
              children: [
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
                    : IconButton(
                        onPressed: onPressed, icon: const Icon(Icons.add)),
              ],
            )
          ],
        ),
      ],
    );
  }
}
