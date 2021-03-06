import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class Person {
  Person({
    required this.uid,
    required this.name,
    required this.surname,
    this.skills,
  });

  final String uid;
  String name;
  String surname;
  List<SkillHolder>? skills;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class SkillHolder {
  SkillHolder({required this.skillId, this.rating = 0, this.likes = const []});

  String skillId;
  int rating;
  List<String> likes;

  factory SkillHolder.fromJson(Map<String, dynamic> json) =>
      _$SkillHolderFromJson(json);

  Map<String, dynamic> toJson() => _$SkillHolderToJson(this);
}
