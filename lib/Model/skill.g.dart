// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      name: json['name'] as String,
      type: $enumDecode(_$SkillTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'name': instance.name,
      'type': _$SkillTypeEnumMap[instance.type],
    };

const _$SkillTypeEnumMap = {
  SkillType.programmingLang: 'programmingLang',
  SkillType.responsibleSystem: 'responsibleSystem',
};
