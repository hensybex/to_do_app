import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../logger.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;

import 'api_key.dart';

class HiveProvider {
  Future<Task?> getTask(int index) async {
    var box = Hive.box<Task>('ToDos');
    Task? task = box.getAt(index);
    return task;
  }

  Future<List<dynamic>> getListTask() async {
    var box = Hive.box<Task>('ToDos');
    List<dynamic> loadedTasksList = box.values.cast().toList();
    logger.info(loadedTasksList.length);
    return loadedTasksList;
  }

  Future<void> postTask(Task task) async {
    var box = Hive.box<Task>('ToDos');
    box.add(task);
  }

  Future<void> deleteTask(int index) async {
    var box = Hive.box<Task>('ToDos');
    box.deleteAt(index);
  }

  Future<void> editTask(int index, Task newTask) async {
    var box = Hive.box<Task>('ToDos');
    box.putAt(index, newTask);
  }
}
