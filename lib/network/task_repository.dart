import 'package:to_do_app/network/task_provider.dart';

import '../model/task.dart';

class TaskRepository {
  final TaskProvider _taskProvider = TaskProvider();
  //Future<List<Task>> getAllTasks() => _taskProvider.getTasks();
  Future<void> deleteSingleTask(String id) => _taskProvider.deleteTask(id);
}
