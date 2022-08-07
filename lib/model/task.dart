// This file is "main.dart"
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String text,
    required String importance,
    //int? deadline,
    required bool done,
    //String? color,
    required int created_at,
    required int changed_at,
    required String last_updated_by,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
