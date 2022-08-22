import 'package:to_do_app/network/task_provider.dart';

import '../logger.dart';
import '../model/task.dart';

class TasksRepository {
  final TaskProvider _tasksProvider = TaskProvider();
  Future<List<Task>> getAllTasks() {
    return _tasksProvider.getTasks();
  }

  Future<void> deleteSingleTask(String id) {
    return _tasksProvider.deleteTask(id);
  }

  Future<void> postSingleTask(Task task) {
    return _tasksProvider.postTask(task);
  }

  Future<void> editSingleTask(Task task) {
    return _tasksProvider.editTask(task);
  }
}
