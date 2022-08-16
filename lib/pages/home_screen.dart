import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import '../logger.dart';
import '../network/api.dart';
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
    logger.info("Home Screen");
    _TasksListFuture = Api.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Task>>(
          future: _TasksListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return scrollMenu(context, snapshot.requireData);
            else
              return Text("Snapshot error");
          }),
    );
  }

  Widget eventCard(Task task) {
    return Row(
      children: [
        Flexible(flex: 1, child: Icon(Icons.abc)),
        Flexible(flex: 8, child: ListTile(title: Text(task.text))),
        Flexible(flex: 1, child: Icon(Icons.abc)),
      ],
    );
  }

  Widget scrollMenu(BuildContext context, List<Task> tasks) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => eventCard(tasks[index]),
            childCount: tasks.length,
          ),
        )
      ],
    );
  }
}
