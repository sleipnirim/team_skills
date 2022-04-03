// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      uid: json['uid'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => SkillHolder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'surname': instance.surname,
      'skills': instance.skills?.map((e) => e.toJson()).toList(),
    };

SkillHolder _$SkillHolderFromJson(Map<String, dynamic> json) => SkillHolder(
      skillId: json['skillId'] as String,
      rating: json['rating'] as int? ?? 0,
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SkillHolderToJson(SkillHolder instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'rating': instance.rating,
      'likes': instance.likes,
    };
