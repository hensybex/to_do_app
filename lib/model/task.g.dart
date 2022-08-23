// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      text: fields[1] as String,
      importance: fields[2] as String,
      deadline: fields[3] as int?,
      done: fields[4] as bool,
      color: fields[5] as String?,
      created_at: fields[6] as int,
      changed_at: fields[7] as int,
      last_updated_by: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.importance)
      ..writeByte(3)
      ..write(obj.deadline)
      ..writeByte(4)
      ..write(obj.done)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.created_at)
      ..writeByte(7)
      ..write(obj.changed_at)
      ..writeByte(8)
      ..write(obj.last_updated_by);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Task _$$_TaskFromJson(Map<String, dynamic> json) => _$_Task(
      id: json['id'] as String,
      text: json['text'] as String,
      importance: json['importance'] as String,
      deadline: json['deadline'] as int?,
      done: json['done'] as bool,
      color: json['color'] as String?,
      created_at: json['created_at'] as int,
      changed_at: json['changed_at'] as int,
      last_updated_by: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$$_TaskToJson(_$_Task instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': instance.importance,
      'deadline': instance.deadline,
      'done': instance.done,
      'color': instance.color,
      'created_at': instance.created_at,
      'changed_at': instance.changed_at,
      'last_updated_by': instance.last_updated_by,
    };
