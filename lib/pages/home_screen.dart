import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data_processing/tasks_repositoty.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import 'package:to_do_app/theme/constants.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/tasks_state.dart';
import '../logger.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/navigation/nav_cubit.dart';
import '../widgets/task_card.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backLightPrimary,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: backLightPrimary,
            //collapsedHeight: 100,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мои дела',
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: primaryTextColorLight),
                  ),
                  BlocBuilder<TaskBloc, TasksState>(
                    builder: (_, state) {
                      if (state is TasksLoadedState) {
                        return Text(
                          'Выполнено - ${state.doneTasks}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: labelLightTertiary),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BlocBuilder<TaskBloc, TasksState>(
                builder: (_, state) {
                  if (state is TasksLoadedState) {
                    return Container(
                      decoration: BoxDecoration(
                          color: backLightSecondary,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      margin:
                          EdgeInsets.only(left: 8.0, right: 8.0, bottom: 28.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.loadedTasks.length,
                        itemBuilder: (_, index) {
                          Task task = state.loadedTasks[index];

                          return TaskCard(task: task, index: index);
                        },
                      ),
                    );
                  } else if (state is TasksErrorState) {
                    return Center(
                      child: Text('$state'),
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
