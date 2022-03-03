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
  final String name;
  final String surname;
  Map<String, int>? skills;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
