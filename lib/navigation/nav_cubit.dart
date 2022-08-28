import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/task.dart';

class NavCubit extends Cubit<Task?> {
  NavCubit() : super(null);

  void editTask(Task task) {
    AppMetrica.reportEvent('Moving to task editing screen');
    emit(task);
  }

  void createTask(Task task) {
    AppMetrica.reportEvent('Moving to task creation screen');
    emit(task);
  }

  void popHome() {
    AppMetrica.reportEvent('Moving to home screen');
    emit(null);
  }
}
