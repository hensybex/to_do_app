import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/bloc/tasks_bloc.dart';
import 'package:to_do_app/bloc/tasks_state.dart';
import 'package:to_do_app/widgets/task_card.dart';

import '../logger.dart';
import '../model/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TasksState>(
      listener: ((context, state) {
        logger.info(state.toString());
        if (state is TasksLoadedState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Tasks loaded')));
        }
      }),
      builder: (context, state) {
        if (state is TasksEmptyState) {
          return const Center(
            child: Text(
              'No data received',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        if (state is TasksLoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is TasksLoadedState) {
          return CustomScrollView(
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) => TaskCard(task: state.loadedTasks[index]),
                  childCount: state.loadedTasks.length,
                ),
              ),
            ],
          );
        }

        if (state is TasksErrorState) {
          return const Center(
            child: Text('Error fetching tasks'),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
