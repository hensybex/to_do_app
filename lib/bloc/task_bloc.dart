import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/bloc/task_state.dart';
import 'package:to_do_app/bloc/task_state.dart';
import 'package:to_do_app/logger.dart';

import '../model/task.dart';
import '../network/tasks_repositoty.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TasksRepository tasksRepository,
    required Task task,
  }) : super(TaskEmptyState()) {
    on<TaskDeleteEvent>(
      (event, emit) async {
        logger.info("Task delete event");
        try {
          tasksRepository.deleteSingleTask(task.id);
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          //emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TaskErrorState());
        }
      },
    );
    on<TaskAddEvent>(
      (event, emit) async {
        logger.info("Task add event");
        try {
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          //emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TaskErrorState());
        }
      },
    );
    on<TaskEditEvent>(
      (event, emit) async {
        logger.info("Task edit event");
        try {
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          //emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TaskErrorState());
        }
      },
    );
    on<TaskDoneEvent>(
      (event, emit) async {
        logger.info("Task done event");
        try {
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          //emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TaskErrorState());
        }
      },
    );
  }
}
