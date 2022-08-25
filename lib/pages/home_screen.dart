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
import 'package:to_do_app/navigation/nav_cubit.dart';
import '../widgets/task_card.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  //bool isChecked = false;
  //late List<Task> _TasksList;
  //late Future<Task> _TasksFuture;
  //late Future<Album> futureAlbum;

  @override
  Widget build(BuildContext context) {
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
              BlocBuilder<TaskBloc, TasksState>(
                builder: (_, state) {
                  if (state is TasksLoadedState) {
                    logger.info("wer in home_screen.dart");
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      itemCount: state.loadedTasks.length,
                      itemBuilder: (_, index) {
                        //taskBloc.add(TaskGetEvent(index));
                        Task task = state.loadedTasks[index];

                        return TaskCard(task: task, index: index);
                      },
                    );
                  } else if (state is TasksErrorState) {
                    return Center(
                      child: Text('$state.message'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
          //BlocProvider.of<NavCubit>(context).addTask();
          BlocProvider.of<NavCubit>(context).createTask(Task(
              id: 'tmp',
              text: 'tmp',
              importance: 'low',
              done: true,
              created_at: 0,
              changed_at: 0,
              last_updated_by: 'home_screen'));
        },
      ),
    );
  }
}
