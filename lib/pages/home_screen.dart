import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import 'package:to_do_app/services/sidebar.dart';
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
    _TasksFuture = Api.fetchTask();
    _TasksListFuture = Api.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F6F2),
      drawer: SideBarWidget(),
      body: FutureBuilder<List<Task>>(
        future: _TasksListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.requireData;
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: Card(
                color: Color(0xFFFFFFFF),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 40),
                  physics: ScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Мои дела',
                        style: TextStyle(fontSize: 32),
                      ),
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
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
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
