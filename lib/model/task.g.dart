// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Task _$$_TaskFromJson(Map<String, dynamic> json) => _$_Task(
      id: json['id'] as String,
      text: json['text'] as String,
      importance: json['importance'] as String,
      done: json['done'] as bool,
      created_at: json['created_at'] as int,
      changed_at: json['changed_at'] as int,
      last_updated_by: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$$_TaskToJson(_$_Task instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': instance.importance,
      'done': instance.done,
      'created_at': instance.created_at,
      'changed_at': instance.changed_at,
      'last_updated_by': instance.last_updated_by,
    };
