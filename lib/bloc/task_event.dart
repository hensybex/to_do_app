abstract class TaskEvent {}

class TaskLoadEvent extends TaskEvent {}

class TaskAddEvent extends TaskEvent {}

class TaskDoneEvent extends TaskEvent {}

class TaskDeleteEvent extends TaskEvent {
  TaskDeleteEvent(String id);
}

class TaskEditEvent extends TaskEvent {}
