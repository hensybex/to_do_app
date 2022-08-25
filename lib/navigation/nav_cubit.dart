import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/task.dart';

class NavCubit extends Cubit<Task?> {
  NavCubit() : super(null);

  void editTask(Task task) => emit(task);

  void createTask(Task task) => emit(task);

  void popHome() => emit(null);
}
