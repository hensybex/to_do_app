import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/bloc/task_state.dart';

import '../bloc/task_event.dart';
import '../model/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({Key? key, required this.task}) : super(key: key);

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
            taskBloc.add(TaskDoneEvent());
          },
        ),
      ]),
      endActionPane:
          ActionPane(extentRatio: 0.2, motion: ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            taskBloc.add(TaskDeleteEvent(widget.task.id));
          },
        ),
      ]),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Checkbox(
                activeColor: Colors.green,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),
          ),
          Flexible(
            flex: 8,
            child: ListTile(
              title: Text(widget.task.text),
              subtitle: (widget.task.deadline != null)
                  ? (Text(widget.task.deadline.toString()))
                  : (Text('')),
            ),
          ),
          Flexible(
              flex: 1,
              child: IconButton(
                  onPressed: (() => {}), icon: Icon(Icons.info_outline))),
        ],
      ),
    );
  }
}
