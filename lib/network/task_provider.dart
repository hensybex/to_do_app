import 'dart:convert';

import '../logger.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;

import 'api_key.dart';

class TaskProvider {
  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list/'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    List allTasks = jsonDecode(response.body)['list'];
    return allTasks.map((element) => Task.fromJson(element)).toList();
  }

  Future<Task> fetchTask() async {
    final response = await http.get(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list/0'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body)['element']);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<String> getRevision() async {
    final response = await http.get(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list/'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    return (jsonDecode(response.body)['revision']).toString();
  }

  Future<void> deleteTask(String id) async {
    String _revision = await getRevision();

    final response = await http.delete(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list/$id'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'X-Last-Known-Revision': _revision,
      },
    );
    if (response.statusCode == 200) {
      logger.info("Task successfully deleted!");
    } else {
      throw Exception('Smth went wrong');
    }
  }

  Future<void> postTask(Task task) async {
    String _revision = await getRevision();

    //getRevision().then((val) => {_revision = val});
    final response = await http.post(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list/'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'X-Last-Known-Revision': _revision,
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'status': 'ok',
          'element': {
            'id': task.id,
            'text': task.text,
            'importance': task.importance,
            'done': task.done,
            'created_at': task.created_at,
            'changed_at': task.changed_at,
            'last_updated_by': task.last_updated_by,
          },
        },
      ),
    );
    if (response.statusCode == 200) {
      logger.info("Success");
    } else {
      throw Exception('Failed to create album.');
    }
  }
}
