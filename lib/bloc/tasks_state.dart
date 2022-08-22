abstract class TasksState {}

class TasksEmptyState extends TasksState {}

class TasksLoadingState extends TasksState {}

class TasksErrorState extends TasksState {}

class TasksLoadedState extends TasksState {
  List<dynamic> loadedTasks;
  TasksLoadedState({
    required this.loadedTasks,
  });
}
