import 'package:json_annotation/json_annotation.dart';

part 'person_old.g.dart';

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
  Map<String, List<String>>? skills;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
