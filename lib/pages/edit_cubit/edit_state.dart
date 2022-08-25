part of 'edit_cubit.dart';

@immutable
abstract class EditState {}

class EditInitial extends EditState {
  final String textInput;
  String importanceInput;
  final DateTime dateInput = DateTime.now();
  EditInitial({
    this.textInput = '',
    this.importanceInput = 'low',
  });
}

class Success extends EditState {
  final String okay;
  Success({
    required this.okay,
  });
}

class Failed extends EditState {
  final String notOkay;
  Failed({
    required this.notOkay,
  });
}
