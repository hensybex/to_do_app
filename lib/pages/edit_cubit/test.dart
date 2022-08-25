import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_cubit.dart';

class ScrambledUnscrambled extends StatelessWidget {
  final String? userInputFromFirstTextField;
  //final String? secondSTring;

  ScrambledUnscrambled({
    required this.userInputFromFirstTextField,
    //this.secondSTring,
  });

  @override
  Widget build(BuildContext context) {
    String str = "";
    final mycontroller = TextEditingController();

    List<String> inputs = userInputFromFirstTextField!.split(" ");
    String shuffledWords(List<String> input) {
      input.shuffle();
      // print(input);
      return input.join(" ");
    }

    return BlocProvider<EditCubit>(
      create: (context) => EditCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Unscramble'),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.only(top: 50),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 100,
                color: Colors.blueAccent,
                padding: const EdgeInsets.all(15),
                child: Text(
                  shuffledWords(inputs),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: TextField(
                controller: mycontroller,
                onChanged: (String text) {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Please, enter a grammatically correct sentence.',
                  labelText: 'Second Input',
                  labelStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                str = mycontroller.text;
              },
              child: const Text("Submit"),
            ),
            if (str == mycontroller.text)
              BlocBuilder<EditCubit, EditState>(
                builder: (context, state) {
                  return Container(
                    color: Colors.blueAccent,
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: 100,
                    child: Text(
                      BlocProvider.of<EditCubit>(context).checkForError(
                        str,
                        userInputFromFirstTextField!,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
