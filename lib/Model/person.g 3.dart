// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      uid: json['uid'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      skills: (json['skills'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'surname': instance.surname,
      'skills': instance.skills,
    };
