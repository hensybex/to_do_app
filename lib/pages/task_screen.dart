import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/s.dart';
import 'package:http/http.dart' as http;
import '../logger.dart';
import '../model/task.dart';
import '../network/task_provider.dart';
import '../network/api_key.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late String _revision;
  late Future<int> _RevisionFuture;
  dynamic importanceValue = 'low';
  final items = ['low', 'basic', 'important'];
  bool _dateState = false;
  bool dateTextState = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DateTime? gameDateTime;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    logger.info('Task Screen');
  }

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
        _dateController.text = DateFormat.yMd().format(selectedDate);
        _dateTextController.text =
            DateFormat.yMMMMd('ru').format(selectedDate).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              style: ButtonStyle(
                alignment: Alignment.topRight,
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.only(top: 40)),
              ),
              onPressed: () {
                submit();
                //Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  'СОХРАНИТЬ',
                ),
              ),
            ),
            Form(
              key: _formKey,
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
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 10, 10),
                    child: DropdownButton(
                        icon: Visibility(
                            visible: false, child: Icon(Icons.arrow_downward)),
                        value: importanceValue,
                        items: items
                            .map(
                              (dynamic value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
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
                              child: Text('Сделать до'),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 10, 10),
                              child: Opacity(
                                opacity: _dateState ? 1 : 0,
                                child: TextField(
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
                            }
                            setState(() {
                              _dateState = state;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void submit() {
    Task task = Task(
      id: UniqueKey().toString(),
      text: _textController.text,
      importance: importanceValue,
      done: false,
      created_at: DateTime.now().millisecondsSinceEpoch,
      changed_at: DateTime.now().millisecondsSinceEpoch,
      last_updated_by: '1',
    );
    //TaskProvider.postTask(task);
    Navigator.pushNamedAndRemoveUntil(context, './home', (route) => false);
  }
}
