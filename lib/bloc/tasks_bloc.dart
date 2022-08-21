import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/tasks_state.dart';
import 'package:to_do_app/bloc/tasks_event.dart';
import 'package:to_do_app/logger.dart';

import '../model/task.dart';
import '../network/tasks_repositoty.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository tasksRepository;

  TasksBloc({required this.tasksRepository}) : super(TasksEmptyState()) {
    on<TasksLoadEvent>(
      (event, emit) async {
        emit(TasksLoadingState());
        try {
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TasksErrorState());
        }
      },
    );
  }
}
