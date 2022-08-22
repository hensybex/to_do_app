import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/bloc/tasks_state.dart';
import 'package:to_do_app/logger.dart';

import '../model/task.dart';
import '../network/tasks_repositoty.dart';

class TaskBloc extends Bloc<TaskEvent, TasksState> {
  TaskBloc({
    required TasksRepository tasksRepository,
    Task? task,
  }) : super(TasksEmptyState()) {
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
    on<TaskDeleteEvent>(
      (event, emit) async {
        logger.info('Task delete event');
        try {
          await tasksRepository.deleteSingleTask(event.id);
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TasksErrorState());
        }
      },
    );
    on<TaskPostEvent>(
      (event, emit) async {
        logger.info('Task add event');
        try {
          await tasksRepository.postSingleTask(event.task);
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          logger.info('Length of updated list:');
          logger.info(loadedTasksList.length);
          emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TasksErrorState());
        }
      },
    );
    on<TaskEditEvent>(
      (event, emit) async {
        logger.info('Task edit event');
        try {
          await tasksRepository.editSingleTask(event.task);
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TasksErrorState());
        }
      },
    );
    on<TaskDoneEvent>(
      (event, emit) async {
        logger.info('Task done event');
        try {
          final List<Task> loadedTasksList =
              await tasksRepository.getAllTasks();
          //emit(TasksLoadedState(loadedTasks: loadedTasksList));
        } catch (_) {
          emit(TasksErrorState());
        }
      },
    );
  }
}
