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
            Task newTask = Task(
              id: widget.task.id,
              text: widget.task.text,
              importance: widget.task.importance,
              done: !widget.task.done,
              created_at: widget.task.created_at,
              changed_at: widget.task.changed_at,
              last_updated_by: widget.task.last_updated_by,
            );
            taskBloc.add(TaskEditEvent(newTask));
          },
        ),
      ]),
      endActionPane:
          ActionPane(extentRatio: 0.2, motion: ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            logger.info('from task card');
            logger.info(widget.task.id);
            taskBloc.add(TaskDeleteEvent(widget.task.id, widget.index));
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
                  Task newTask = Task(
                    id: widget.task.id,
                    text: widget.task.text,
                    importance: widget.task.importance,
                    done: !widget.task.done,
                    created_at: widget.task.created_at,
                    changed_at: widget.task.changed_at,
                    last_updated_by: widget.task.last_updated_by,
                  );
                  taskBloc.add(TaskEditEvent(newTask));
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
                  onPressed: (() => {}), icon: Icon(Icons.info_outline))),
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
