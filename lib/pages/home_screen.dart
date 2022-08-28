import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data_processing/tasks_repositoty.dart';
import 'dart:async';
import 'package:to_do_app/s.dart';
import 'package:to_do_app/theme/constants.dart';
import 'package:uuid/uuid.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/tasks_state.dart';
import '../logger.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/navigation/nav_cubit.dart';
import '../widgets/task_card.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool visibleDone = true;
  final TextEditingController _textController = TextEditingController();

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
                        .copyWith(color: labelLightPrimary),
                  ),
                  BlocBuilder<TaskBloc, TasksState>(
                    builder: (_, state) {
                      if (state is TasksLoadedState) {
                        return Row(
                          children: [
                            Text(
                              'Выполнено - ${state.doneTasks}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: labelLightPrimary),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibleDone = !visibleDone;
                                  });
                                },
                                icon: Icon(color: lightBlue, Icons.visibility)),
                          ],
                        );
                      } else if (state is TasksErrorState) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.error)));
                        return Row(
                          children: [
                            Text(
                              'Выполнено - ${state.tasks.where((element) => element.done == true).length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: labelLightPrimary),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibleDone = !visibleDone;
                                  });
                                },
                                icon: Icon(color: lightBlue, Icons.visibility)),
                          ],
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
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: visibleDone == true
                                ? state.loadedTasks.length
                                : state.loadedTasks
                                    .where((element) => element.done != true)
                                    .toList()
                                    .length,
                            itemBuilder: (_, index) {
                              late Task task;
                              visibleDone == true
                                  ? task = state.loadedTasks[index]
                                  : task = state.loadedTasks
                                      .where((element) => element.done != true)
                                      .toList()[index];

                              return TaskCard(task: task, index: index);
                            },
                          ),
                          TextField(
                            style: TextStyle(fontSize: 20),
                            minLines: 1,
                            controller: _textController,
                            onSubmitted: (value) {
                              Task task = Task(
                                id: const Uuid().v1(),
                                text: _textController.text,
                                importance: 'low',
                                done: false,
                                created_at:
                                    DateTime.now().millisecondsSinceEpoch,
                                changed_at:
                                    DateTime.now().millisecondsSinceEpoch,
                                last_updated_by: '1',
                                deadline: null,
                              );
                              BlocProvider.of<TaskBloc>(context)
                                  .add(TaskPostEvent(task));
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: 'Новое...',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.multiline,
                          ),
                        ],
                      ),
                    );
                  } else if (state is TasksErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));

                    return Container(
                      decoration: BoxDecoration(
                          color: backLightSecondary,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      margin:
                          EdgeInsets.only(left: 8.0, right: 8.0, bottom: 28.0),
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: visibleDone == true
                                ? state.tasks.length
                                : state.tasks
                                    .where((element) => element.done != true)
                                    .toList()
                                    .length,
                            itemBuilder: (_, index) {
                              late Task task;
                              visibleDone == true
                                  ? task = state.tasks[index]
                                  : task = state.tasks
                                      .where((element) => element.done != true)
                                      .toList()[index];

                              return TaskCard(task: task, index: index);
                            },
                          ),
                          TextField(
                            style: TextStyle(fontSize: 20),
                            minLines: 1,
                            controller: _textController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: 'Новое...',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.multiline,
                          ),
                        ],
                      ),
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
