import '../model/task.dart';

abstract class TaskEvent {}

class TasksLoadEvent extends TaskEvent {}

class TaskPostEvent extends TaskEvent {
  Task task;

  TaskPostEvent(this.task);
}

class TaskDoneEvent extends TaskEvent {
  Task task;

  TaskDoneEvent(this.task);
}

class TaskDeleteEvent extends TaskEvent {
  String id;

  TaskDeleteEvent(this.id);
}

class TaskEditEvent extends TaskEvent {
  Task task;

  TaskEditEvent(this.task);
}
