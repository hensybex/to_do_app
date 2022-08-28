import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/bloc/tasks_state.dart';
import 'package:to_do_app/data_processing/shared_pref.dart';
import 'package:to_do_app/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/task.dart';
import '../data_processing/hive_repository.dart';
import '../data_processing/tasks_repositoty.dart';

class TaskBloc extends Bloc<TaskEvent, TasksState> {
  TaskBloc({
    required TasksRepository tasksRepository,
    required HiveRepository hiveRepository,
  })  : _tasksRepository = tasksRepository,
        _hiveRepository = hiveRepository,
        super(TasksLoadingState()) {
    on<TaskGetListEvent>(_getListTask);
    on<TaskDoneEvent>(_markTaskDone);
    on<TaskEditEvent>(_editTask);
    on<TaskPostEvent>(_postTask);
    on<TaskDeleteEvent>(_deleteTask);
  }
  final TasksRepository _tasksRepository;
  final HiveRepository _hiveRepository;

  Future<List<dynamic>> _getListTask(
      TaskGetListEvent event, Emitter<TasksState> emit) async {
    AppMetrica.reportEvent('Getting list of tasks');
    List<dynamic> loadedTasksList = await _hiveRepository.getListTasks();
    int doneTasks =
        loadedTasksList.where((element) => element.done == true).length;
    emit(TasksLoadedState(
      loadedTasks: loadedTasksList,
      doneTasks: doneTasks,
      isHidden: await SharedPref.getCurrent(),
    ));
    return loadedTasksList;
  }

  Future<void> _postTask(TaskPostEvent event, Emitter<TasksState> emit) async {
    AppMetrica.reportEvent('Posting task');
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, postTask');
        var connectivityResult = await (Connectivity().checkConnectivity());
        final currentState = state as TasksLoadedState;
        final List<Task> newTasks = List.from(currentState.loadedTasks);
        newTasks.add(event.task);
        emit(
          TasksLoadedState(
              isHidden: await SharedPref.getCurrent(),
              loadedTasks: newTasks,
              doneTasks:
                  newTasks.where((element) => element.done == true).length),
        );
        await _hiveRepository.postTask(event.task);
        if (connectivityResult != ConnectivityResult.none) {
          //logger.info(connectivityResult);
          //logger.info(connectivityResult.name);
          //logger.info('Update after post');
          await _tasksRepository.updateTasks(newTasks);
        }
      }
    } catch (e) {
      emit(TasksErrorState());
    }
  }

  Future<void> _deleteTask(
      TaskDeleteEvent event, Emitter<TasksState> emit) async {
    AppMetrica.reportEvent('Deleting task');
    logger.info('Start of task delete');
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, deleteTask');
        var connectivityResult = await (Connectivity().checkConnectivity());
        final currentState = state as TasksLoadedState;
        final List<Task> newTasks = List.from(currentState.loadedTasks);
        logger.info('Im here');
        logger.info(newTasks.length);
        logger.info('Task in hive');
        logger.info(newTasks.last);
        logger.info('Task to be deleted');
        logger.info(event.task);
        newTasks.removeWhere((item) => item.id == event.task.id);
        logger.info(newTasks.length);
        emit(TasksLoadedState(
            isHidden: await SharedPref.getCurrent(),
            loadedTasks: newTasks,
            doneTasks:
                newTasks.where((element) => element.done == true).length));
        await _hiveRepository.deleteTask(event.index);
        if (connectivityResult != ConnectivityResult.none) {
          logger.info('Update after delete');
          await _tasksRepository.updateTasks(newTasks);
        }
      }
    } catch (e) {
      logger.info(e);
      emit(TasksErrorState());
    }
    //var box = Hive.box<Task>('ToDos');
    //box.deleteAt(event.index);
    //_tasksRepository.deleteSingleTask(event.id);
  }

  Future<void> _editTask(TaskEditEvent event, Emitter<TasksState> emit) async {
    AppMetrica.reportEvent('Editing task');
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, editTask');
        var connectivityResult = await (Connectivity().checkConnectivity());
        //logger.info(event.index);
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
        emit(TasksLoadedState(
            isHidden: await SharedPref.getCurrent(),
            loadedTasks: newTasks,
            doneTasks:
                newTasks.where((element) => element.done == true).length));
        await _hiveRepository.editTask(event.index, newTask);
        if (connectivityResult != ConnectivityResult.none) {
          logger.info('Update after edit');
          await _tasksRepository.updateTasks(newTasks);
        }
      }
    } catch (e) {
      emit(TasksErrorState());
    }
  }

  Future<void> _markTaskDone(
      TaskDoneEvent event, Emitter<TasksState> emit) async {
    AppMetrica.reportEvent('Marking task done');
    try {
      if (state is TasksLoadedState) {
        logger.info('wer in task_bloc.dart, markTaskDone');
        //logger.info(event.index);
        var connectivityResult = await Connectivity().checkConnectivity();
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
        emit(TasksLoadedState(
            isHidden: await SharedPref.getCurrent(),
            loadedTasks: newTasks,
            doneTasks:
                newTasks.where((element) => element.done == true).length));
        await _hiveRepository.editTask(event.index, newTask);
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