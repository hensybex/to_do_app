import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/bloc/tasks_state.dart';
import 'package:to_do_app/logger.dart';

import '../model/task.dart';
import '../network/tasks_repositoty.dart';

class TaskBloc extends Bloc<TaskEvent, TasksState> {
  TaskBloc() : super(TasksLoadingState()) {
    //on<TasksLoadEvent>(_loadTasks);
    on<TaskDoneEvent>(_markTaskDone);
    on<TaskEditEvent>(_editTask);
    on<TaskPostEvent>(_postTask);
    on<TaskDeleteEvent>(_deleteTask);
  }
  /*Future<void> _loadTasks(TasksLoadEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    var task = TaskLoadEve
  }*/
  Future<void> _postTask(TaskPostEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    box.add(event.task);
  }

  Future<void> _editTask(TaskEditEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    var newTask = Task(
      id: event.task.id,
      text: event.task.text,
      importance: event.task.importance,
      deadline: event.task.deadline,
      done: event.task.done,
      color: event.task.color,
      created_at: event.task.created_at,
      last_updated_by: event.task.last_updated_by,
      changed_at: DateTime.now().millisecondsSinceEpoch,
    );
    box.putAt(int.parse(event.task.id), newTask);
  }

  Future<void> _deleteTask(
      TaskDeleteEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    logger.info("wer here");
    logger.info('37651d20-228d-11ed-9dae-2fc5f9b06346');
    logger.info(event.index);
    //logger.info(event.id);
    //logger.info(int.parse(event.id));
    box.deleteAt(event.index);
  }

  Future<void> _markTaskDone(
      TaskDoneEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    box.add(event.task);
  }
}

/*class TaskBloc extends Bloc<TaskEvent, TasksState> {
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
*/