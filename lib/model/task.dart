import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
@HiveType(typeId: 1)
class Task with _$Task {
  const factory Task({
    @HiveField(0) required String id,
    @HiveField(1) required String text,
    @HiveField(2) required String importance,
    @HiveField(3) int? deadline,
    @HiveField(4) required bool done,
    @HiveField(5) String? color,
    @HiveField(6) required int created_at,
    @HiveField(7) required int changed_at,
    @HiveField(8) required String last_updated_by,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
