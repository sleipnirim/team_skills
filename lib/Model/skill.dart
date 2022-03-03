import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class Skill {
  const Skill({required this.name, required this.type});

  final String name;
  final SkillType type;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}

@JsonEnum()
enum SkillType { programmingLang, technology, responsibleSystem, hobby }
