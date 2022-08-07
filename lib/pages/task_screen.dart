import 'package:flutter/material.dart';
//import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/s.dart';
import 'package:to_do_app/services/sidebar.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  dynamic importanceValue = 'Нет';
  final items = ['Нет', 'Низкий', 'Высокий'];
  bool dateState = false;
  bool dateTextState = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? gameDateTime;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

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
        body: Form(
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
              Text('Важность', style: TextStyle(fontWeight: FontWeight.bold)),
              /*const SizedBox(
                height: 8,
              ),*/
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
                            //style: TextStyle(fontWeight: FontWeight.bold),
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
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Сделать до'),
                        TextField(
                          controller: _dateController,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Switch(
                      value: dateState,
                      onChanged: (bool state) {
                        setState(() {
                          dateState = state;
                        });
                        _selectDate(context);
                      },
                    ),
                  )
                ],
              ),
              /*Row(
                children: [
                  Column(
                    children: [
                      Text('Сделать до'),
                      Text('Сделать до'),
                    ],
                  ),
                  /*TextField(
              controller: _dateController,
              enabled: dateTextState,
            ),*/
                  Switch(
                    value: dateState,
                    onChanged: (bool state) {
                      setState(() {
                        dateState = state;
                      });
                      _selectDate(context);
                    },
                  ),
                ],
              ),*/
            ],
          ),
        ),
      );
}
