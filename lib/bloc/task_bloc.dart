import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/bloc/tasks_state.dart';
import 'package:to_do_app/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/task.dart';
import '../network/tasks_repositoty.dart';

class TaskBloc extends Bloc<TaskEvent, TasksState> {
  TaskBloc({
    required TasksRepository tasksRepository,
  })  : _tasksRepository = tasksRepository,
        super(TasksLoadingState()) {
    //on<TasksLoadEvent>(_loadTasks);
    on<TaskGetListEvent>(_getListTask);
    on<TaskGetEvent>(_getTask);
    on<TaskDoneEvent>(_markTaskDone);
    on<TaskEditEvent>(_editTask);
    on<TaskPostEvent>(_postTask);
    on<TaskDeleteEvent>(_deleteTask);
  }

  final TasksRepository _tasksRepository;
  /*Future<void> _loadTasks(TasksLoadEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    var task = TaskLoadEve
  }*/
  Future<Task?> _getTask(TaskGetEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    Task? task = box.getAt(event.index);
    return task;
  }

  Future<List<dynamic>> _getListTask(
      TaskGetListEvent event, Emitter<TasksState> emit) async {
    var box = Hive.box<Task>('ToDos');
    logger.info(box.values);
    List<dynamic> loadedTasksList = box.values.cast().toList();
    emit(TasksLoadedState(loadedTasks: loadedTasksList));
    return loadedTasksList;
  }

  Future<void> _postTask(TaskPostEvent event, Emitter<TasksState> emit) async {
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, deleteTask');
        //logger.info(event.index);
        var connectivityResult = await (Connectivity().checkConnectivity());
        var box = Hive.box<Task>('ToDos');
        final currentState = state as TasksLoadedState;
        final List<Task> newTasks = List.from(currentState.loadedTasks);
        newTasks.add(event.task);
        emit(TasksLoadedState(loadedTasks: newTasks));
        box.add(event.task);
        if (connectivityResult != ConnectivityResult.none) {
          logger.info(connectivityResult);
          logger.info(connectivityResult.name);
          logger.info('Update after post');
          await _tasksRepository.updateTasks(newTasks);
        }
      }
    } catch (e) {
      emit(TasksErrorState());
    }
  }

  Future<void> _editTask(TaskEditEvent event, Emitter<TasksState> emit) async {
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, editTask');
        var connectivityResult = await (Connectivity().checkConnectivity());
        //logger.info(event.index);
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
        final currentState = state as TasksLoadedState;
        final List<Task> newTasks = List.from(currentState.loadedTasks);
        newTasks[event.index] = newTask;
        emit(TasksLoadedState(loadedTasks: newTasks));
        box.putAt(event.index, newTask);
        if (connectivityResult != ConnectivityResult.none) {
          logger.info('Update after edit');
          await _tasksRepository.updateTasks(newTasks);
        }
      }
    } catch (e) {
      emit(TasksErrorState());
    }
  }

  Future<void> _deleteTask(
      TaskDeleteEvent event, Emitter<TasksState> emit) async {
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, deleteTask');
        //logger.info(event.index);
        var connectivityResult = await (Connectivity().checkConnectivity());
        var box = Hive.box<Task>('ToDos');
        final currentState = state as TasksLoadedState;
        final List<Task> newTasks = List.from(currentState.loadedTasks);
        newTasks.remove(event.task);
        emit(TasksLoadedState(loadedTasks: newTasks));
        box.deleteAt(event.index);
        if (connectivityResult != ConnectivityResult.none) {
          logger.info('Update after delete');
          await _tasksRepository.updateTasks(newTasks);
        }
      }
    } catch (e) {
      emit(TasksErrorState());
    }
    //var box = Hive.box<Task>('ToDos');
    //box.deleteAt(event.index);
    //_tasksRepository.deleteSingleTask(event.id);
  }

  Future<void> _markTaskDone(
      TaskDoneEvent event, Emitter<TasksState> emit) async {
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, markTaskDone');
        //logger.info(event.index);
        var connectivityResult = await Connectivity().checkConnectivity();
        var box = Hive.box<Task>('ToDos');
        final currentState = state as TasksLoadedState;
        final List<Task> newTasks = List.from(currentState.loadedTasks);
        var newTask = Task(
          id: event.task.id,
          text: event.task.text,
          importance: event.task.importance,
          deadline: event.task.deadline,
          done: !event.task.done,
          color: event.task.color,
          created_at: event.task.created_at,
          last_updated_by: event.task.last_updated_by,
          changed_at: DateTime.now().millisecondsSinceEpoch,
        );
        newTasks[event.index] = newTask;
        emit(TasksLoadedState(loadedTasks: newTasks));
        box.putAt(event.index, newTask);
        if (connectivityResult != ConnectivityResult.none) {
          logger.info('Update after done');
          await _tasksRepository.updateTasks(newTasks);
        }
      }
    } catch (e) {
      logger.info(e);
      emit(TasksErrorState());
    }
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