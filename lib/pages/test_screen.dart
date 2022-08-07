import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import 'package:to_do_app/services/sidebar.dart';
import '../network/api.dart';
import '../network/api_key.dart';
import '../network/dio_factory.dart';
import '../network/api2.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<Task> _TasksFuture;
  late Future<List<Task>> _TasksListFuture;
  //late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    print("Start fetch");
    _TasksFuture = fetchTask();
    _TasksListFuture = getTasks();
  }

  void _loadItems() {
    final streamController = StreamController<int>();
    api.get();
  }

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBarWidget(),
        appBar: AppBar(),
        body: Center(
          child: FutureBuilder<List<Task>>(
            future: _TasksListFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('wer here');
                final items = snapshot.requireData;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return ListTile(title: Text(item.text));
                  },
                );
                //return Text(snapshot.data!.text);
              } else if (snapshot.hasError) {
                print("Or here");
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
