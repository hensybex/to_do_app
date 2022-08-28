abstract class TasksState {}

class TasksEmptyState extends TasksState {}

class TasksLoadingState extends TasksState {}

class TasksErrorState extends TasksState {
  String error;
  List<dynamic> tasks;

  TasksErrorState({
    required this.tasks,
    required this.error,
  });
}

class TasksLoadedState extends TasksState {
  List<dynamic> loadedTasks;
  int doneTasks;
  bool isHidden;
  TasksLoadedState({
    required this.loadedTasks,
    required this.doneTasks,
    required this.isHidden,
  });
}
