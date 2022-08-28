import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data_processing/tasks_repositoty.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/tasks_state.dart';
import '../logger.dart';
import '../model/task.dart';
import 'package:uuid/uuid.dart';

import '../navigation/nav_cubit.dart';
import '../theme/constants.dart';
import 'edit_cubit/edit_cubit.dart';

class TaskScreen extends StatefulWidget {
  final Task? task;

  TaskScreen({Key? key, this.task}) : super(key: key);
  @override
  State<TaskScreen> createState() {
    // TODO: implement createState
    return TaskScreenState();
  }
}

class TaskScreenState extends State<TaskScreen> {
  @override
  var scrollOverflow = false;
  dynamic importanceValue = 'low';
  final items = ['low', 'basic', 'important'];
  bool _dateState = false;
  bool dateTextState = false;
  bool isEditing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DateTime? gameDateTime;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.millisecondsSinceEpoch.toString();
        _dateTextController.text =
            DateFormat.yMMMMd('ru').format(selectedDate).toString();
      });
    }
  }

  @override
  void initState() {
    if (widget.task != null) {
      setState(() {
        isEditing = true;
        importanceValue = widget.task!.importance;
        _textController.text = widget.task!.text;
        if (widget.task!.deadline != null) {
          selectedDate =
              DateTime.fromMillisecondsSinceEpoch(widget.task!.deadline!);
          _dateController.text = selectedDate.millisecondsSinceEpoch.toString();
          _dateTextController.text =
              DateFormat.yMMMd('ru').format(selectedDate).toString();
          _dateState = true;
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.info('Task Screen');
    return Scaffold(
      appBar: AppBar(
        elevation: scrollOverflow ? 4 : 0,
        backgroundColor: backLightPrimary,
        actions: [
          TextButton(
            style: ButtonStyle(
              alignment: Alignment.topRight,
            ),
            onPressed: () {
              submit(BlocProvider.of<TaskBloc>(context), context);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 6, 0),
              child: Text(
                'СОХРАНИТЬ',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: lightBlue),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: labelLightPrimary,
          onPressed: () {
            BlocProvider.of<NavCubit>(context).popHome();
          },
        ),
      ),
      body: SafeArea(
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (n) {
            if (n.metrics.pixels > 40) {
              setState(() {
                scrollOverflow = true;
              });
            } else {
              setState(() {
                scrollOverflow = false;
              });
            }
            return true;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                //              key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextField(
                          style: TextStyle(fontSize: 20),
                          minLines: 5,
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Что надо сделать...',
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
                      child: Text('Важность',
                          style: Theme.of(context).textTheme.bodyText2!),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 10, 10),
                      child: DropdownButton(
                          icon: Visibility(
                              visible: false,
                              child: Icon(Icons.arrow_downward)),
                          value: importanceValue,
                          items: items
                              .map(
                                (dynamic value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        Theme.of(context).textTheme.subtitle2!,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (newMenu) {
                            setState(() {
                              importanceValue = newMenu;
                            });
                          }),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
                                child: Text('Сделать до',
                                    style:
                                        Theme.of(context).textTheme.bodyText2!),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 10, 10),
                                child: Opacity(
                                  opacity: _dateState ? 1 : 0,
                                  child: TextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: lightBlue),
                                    controller: _dateTextController,
                                    enabled: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Switch(
                            value: _dateState,
                            onChanged: (bool state) {
                              if (_dateState == false) {
                                _selectDate(context);
                              } else {
                                _dateController.text = '';
                              }
                              setState(() {
                                _dateState = state;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    isEditing == true
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: backLightPrimary,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: lightRed,
                                ),
                                Text('Удалить',
                                    style:
                                        Theme.of(context).textTheme.bodyText2!)
                              ],
                            ),
                            onPressed: () {
                              delete(
                                  BlocProvider.of<TaskBloc>(context),
                                  context,
                                  widget.task!,
                                  widget.task!.hiveIndex!);
                            },
                          )
                        : Opacity(
                            opacity: 0.3,
                            child: Row(children: [
                              IconButton(
                                alignment: Alignment.centerLeft,
                                icon: Icon(Icons.delete),
                                onPressed: () {},
                              ),
                              Text('Удалить',
                                  style: Theme.of(context).textTheme.bodyText2!)
                            ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void delete(TaskBloc taskBloc, context, Task task, int index) async {
    taskBloc.add(TaskDeleteEvent(task, index));
    //taskBloc.add(TaskGetListEvent());
    BlocProvider.of<NavCubit>(context).popHome();
  }

  void submit(TaskBloc taskBloc, context) {
    if (widget.task != null) {
      Task task = Task(
        id: widget.task!.id,
        text: _textController.text,
        importance: importanceValue,
        done: widget.task!.done,
        created_at: widget.task!.created_at,
        changed_at: DateTime.now().millisecondsSinceEpoch,
        last_updated_by: '1',
        deadline: (_dateController.text != '')
            ? int.parse(_dateController.text)
            : null,
      );
      logger.info(_dateController.text);
      taskBloc.add(TaskEditEvent(task, widget.task!.hiveIndex!));
    } else {
      Task task = Task(
        id: const Uuid().v1(),
        text: _textController.text,
        importance: importanceValue,
        done: false,
        created_at: DateTime.now().millisecondsSinceEpoch,
        changed_at: DateTime.now().millisecondsSinceEpoch,
        last_updated_by: '1',
        deadline: (_dateController.text != '')
            ? int.parse(_dateController.text)
            : null,
      );
      taskBloc.add(TaskPostEvent(task));
    }
    BlocProvider.of<NavCubit>(context).popHome();
  }
}
