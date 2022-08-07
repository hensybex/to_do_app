import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import 'package:to_do_app/services/sidebar.dart';
import '../logger.dart';
import '../network/api_key.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Task> _TasksFuture;
  late Future<List<Task>> _TasksListFuture;
  //late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    logger.info("Start fetch");
    _TasksFuture = fetchTask();
    _TasksListFuture = getTasks();
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
      body: FutureBuilder<List<Task>>(
        future: _TasksListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.requireData;
            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 40),
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Hello'),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return ListTile(title: Text(item.text));
                    },
                  ),
                ],
              ),
            );
            //return Text(snapshot.data!.text);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            //Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, './task', (route) => false);
          }),
    );
  }
}
