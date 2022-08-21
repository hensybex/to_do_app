import 'package:to_do_app/network/task_provider.dart';

import '../model/task.dart';

class TasksRepository {
  final TaskProvider _tasksProvider = TaskProvider();
  Future<List<Task>> getAllTasks() => _tasksProvider.getTasks();
  Future<void> deleteSingleTask(String id) => _tasksProvider.deleteTask(id);
}
