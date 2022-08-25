import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';

import '../../model/task.dart';

part 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  // final String secondString;
  EditCubit(
      //this.secondString,
      )
      : super(EditInitial());

  String checkForError(String getSecondText, String getFirstString) {
    // getSecondText = secondString;
    final okay = Success(okay: "Okay");
    final notOkay = Failed(notOkay: "Not Okay");

    if (getSecondText == getFirstString) {
      return okay.okay;
    } else {
      return notOkay.notOkay;
    }
  }
}
