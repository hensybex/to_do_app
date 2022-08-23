import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/network/tasks_repositoty.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/tasks_state.dart';
import '../logger.dart';
import '../network/task_provider.dart';
import '../network/api_key.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;

import '../widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  //bool isChecked = false;
  //late List<Task> _TasksList;
  //late Future<Task> _TasksFuture;
  //late Future<Album> futureAlbum;

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final box = Hive.box<Task>('ToDos');
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        slivers: [
          const SliverAppBar(
            collapsedHeight: 100,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Мои дела'),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (_, Box box, __) {
                  if (box.values.isEmpty) {
                    return Center(
                      child: Text('No todos'),
                    );
                  }
                  return BlocBuilder<TaskBloc, TasksState>(builder: (_, state) {
                    return TasksList();
                  });
                },
              ),
            ]),
          ),
        ],
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
