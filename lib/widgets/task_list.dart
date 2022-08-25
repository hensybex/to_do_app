/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/widgets/task_card.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/tasks_state.dart';
import '../logger.dart';
import '../model/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final box = Hive.box<Task>('ToDos');
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: box.values.length,
      itemBuilder: (_, index) {
        taskBloc.add(TaskGetEvent(index));
        //Task task = box.getAt(index)!;

        return TaskCard(task: task, index: index);
      },
    );
  }
}
*/