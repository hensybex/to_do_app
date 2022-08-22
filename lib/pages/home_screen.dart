import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/network/tasks_repositoty.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
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
    return RepositoryProvider(
      create: (context) => TasksRepository(),
      child: BlocProvider(
          create: (context) =>
              TaskBloc(tasksRepository: context.read<TasksRepository>())
                ..add(TasksLoadEvent()),
          child: Scaffold(
            body: TasksList(),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  //Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, './task', (route) => false);
                }),
          )),
    );
  }
}
