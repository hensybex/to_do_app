import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/bloc/tasks_state.dart';
import 'package:intl/intl.dart';
import '../bloc/task_event.dart';
import '../logger.dart';
import '../model/task.dart';
import '../navigation/nav_cubit.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final int index;
  const TaskCard({Key? key, required this.task, required this.index})
      : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = context.read<TaskBloc>();
    return Slidable(
      startActionPane:
          ActionPane(extentRatio: 0.2, motion: ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.green,
          icon: Icons.plus_one,
          onPressed: (context) {
            taskBloc.add(TaskDoneEvent(widget.task, widget.index));
          },
        ),
      ]),
      endActionPane:
          ActionPane(extentRatio: 0.2, motion: ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            taskBloc.add(TaskDeleteEvent(widget.task, widget.index));
          },
        ),
      ]),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Checkbox(
                //overlayColor: MaterialStateProperty.all<Color>(Colors.red),
                //focusColor: Colors.red,
                side: (widget.task.importance == 'important')
                    ? BorderSide(color: Colors.red)
                    : BorderSide(),
                //fillColor: MaterialStateProperty.all<Color>(Colors.red),
                //checkColor: Colors.red,
                activeColor: Colors.green,
                value: widget.task.done,
                onChanged: (bool? value) {
                  logger.info('am i here');
                  taskBloc.add(TaskDoneEvent(widget.task, widget.index));
                }),
          ),
          Visibility(
            child: Icon(Icons.info_outline),
            visible: (widget.task.importance == 'low') ? false : true,
          ),
          Flexible(
            flex: 8,
            child: ListTile(
              title: (widget.task.done == true)
                  ? Text(
                      widget.task.text,
                      overflow: TextOverflow.clip,
                      maxLines: 3,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    )
                  : Text(
                      widget.task.text,
                      overflow: TextOverflow.clip,
                      maxLines: 3,
                    ),
              subtitle: (widget.task.deadline != null)
                  ? (Text(
                      DateTime.fromMillisecondsSinceEpoch(widget.task.deadline!)
                          .toString()))
                  : (const SizedBox.shrink()),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {
                BlocProvider.of<NavCubit>(context).editTask(widget.task);
              },
              icon: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
    );
  }
}

String kostya(String id) {
  if (id[0] == '#') {
    return ('%23' + id.substring(1));
  } else if (id[0] == '[') {
    return ('[%23' + id.substring(2));
  } else {
    return id;
  }
}
