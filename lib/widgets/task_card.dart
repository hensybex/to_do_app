//import 'dart:ffi';

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
import '../theme/constants.dart';

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
    //final TaskBloc taskBloc = context.read<TaskBloc>();
    return Slidable(
      startActionPane:
          ActionPane(extentRatio: 0.2, motion: ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.blue,
          icon: Icons.plus_one,
          onPressed: (context) {
            context
                .read<TaskBloc>()
                .add(TaskDoneEvent(widget.task, widget.index));
          },
        ),
      ]),
      endActionPane:
          ActionPane(extentRatio: 0.2, motion: ScrollMotion(), children: [
        SlidableAction(
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            context
                .read<TaskBloc>()
                .add(TaskDeleteEvent(widget.task, widget.index));
          },
        ),
      ]),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Checkbox(
                side: (widget.task.importance == 'important')
                    ? BorderSide(color: lightRed, width: 3.0)
                    : BorderSide(color: supportLightSeparator, width: 3.0),
                activeColor: lightGreen,
                value: widget.task.done,
                onChanged: (bool? value) {
                  context
                      .read<TaskBloc>()
                      .add(TaskDoneEvent(widget.task, widget.index));
                }),
          ),
          Visibility(
            child: Icon(Icons.info_outline),
            visible: (widget.task.importance == 'low') ? false : true,
          ),
          Flexible(
            flex: 8,
            child: Container(
              height: (widget.task.deadline != null) ? 72.0 : 48.0,
              child: ListTile(
                title: (widget.task.done == true)
                    ? Text(
                        widget.task.text,
                        overflow: TextOverflow.clip,
                        maxLines: 3,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(decoration: TextDecoration.lineThrough),
                      )
                    : Text(
                        widget.task.text,
                        overflow: TextOverflow.clip,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyText2!,
                      ),
                subtitle: (widget.task.deadline != null)
                    ? (Text(DateTime.fromMillisecondsSinceEpoch(
                            widget.task.deadline!)
                        .toString()))
                    : (const SizedBox.shrink()),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              color: labelLightTertiary,
              onPressed: () {
                BlocProvider.of<NavCubit>(context)
                    .editTask(widget.task.copyWith(hiveIndex: widget.index));
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
