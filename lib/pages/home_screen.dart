import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/bloc/tasks_bloc.dart';
import 'package:to_do_app/bloc/tasks_event.dart';
import 'package:to_do_app/network/tasks_repositoty.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import '../bloc/tasks_bloc.dart';
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
              TasksBloc(tasksRepository: context.read<TasksRepository>())
                ..add(TasksLoadEvent()),
          child: const Scaffold(
            body: TasksList(),
          )),
    );
  }
}

String kostya(String id) {
  logger.info("WTF");
  logger.info(id);
  if (id[0] == '#') {
    logger.info('0');
    logger.info('%23' + id.substring(1));
    return ('%23' + id.substring(1));
  } else if (id[0] == '[') {
    logger.info('1');
    logger.info('[%23' + id.substring(2));
    return ('[%23' + id.substring(2));
  } else {
    logger.info('2');
    logger.info(id);
    return id;
  }
}
