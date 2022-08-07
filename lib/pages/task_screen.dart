import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/s.dart';
import 'package:to_do_app/services/sidebar.dart';
import 'package:http/http.dart' as http;
import '../logger.dart';
import '../model/task.dart';
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
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    logger.info('Start fetch');
    getRevision().then((val) => setState(() {
          _revision = val;
        }));
  }

  Future<String> getRevision() async {
    final response = await http.get(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list/'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    return (jsonDecode(response.body)['revision']).toString();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: SideBarWidget(),
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
              child: Text('Сохранить'),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: TextField(
                      minLines: 5,
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Что надо сделать...',
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text('Важность',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton(
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
                  Stack(
                    children: [
                      Positioned(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Сделать до'),
                            Opacity(
                              opacity: _dateState ? 0 : 1,
                              child: TextField(
                                controller: _dateController,
                                enabled: false,
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

  Future<void> postTask(Task task) async {
    final response = await http.post(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list/'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'X-Last-Known-Revision': _revision,
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'status': 'ok',
          'element': {
            'id': task.id,
            'text': task.text,
            'importance': task.importance,
            'done': task.done,
            'created_at': task.created_at,
            'changed_at': task.changed_at,
            'last_updated_by': task.last_updated_by,
          },
          //'revision': _revision,
        },
      ),
    );
    if (response.statusCode == 200) {
      print("Success");
    } else {
      throw Exception('Failed to create album.');
    }
  }

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
    postTask(task);
    Navigator.pushNamedAndRemoveUntil(context, './home', (route) => false);
  }
}
