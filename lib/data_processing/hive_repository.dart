import 'package:to_do_app/data_processing/task_provider.dart';

import '../logger.dart';
import '../model/task.dart';
import 'hive_provider.dart';

class HiveRepository {
  final HiveProvider _hiveProvider = HiveProvider();
  Future<void> getTask(int index) {
    return _hiveProvider.getTask(index);
  }

  Future<List<dynamic>> getListTasks() {
    return _hiveProvider.getListTask();
  }

  Future<void> postTask(Task task) {
    return _hiveProvider.postTask(task);
  }

  Future<void> deleteTask(int index) {
    return _hiveProvider.deleteTask(index);
  }

  Future<void> editTask(int index, Task newTask) {
    return _hiveProvider.editTask(index, newTask);
  }
}
