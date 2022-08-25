import '../model/task.dart';

abstract class TaskEvent {}

class TasksLoadEvent extends TaskEvent {}

class TaskGetListEvent extends TaskEvent {}

class TaskGetEvent extends TaskEvent {
  int index;

  TaskGetEvent(this.index);
}

class TaskPostEvent extends TaskEvent {
  Task task;

  TaskPostEvent(this.task);
}

class TaskDoneEvent extends TaskEvent {
  Task task;
  int index;

  TaskDoneEvent(this.task, this.index);
}

class TaskDeleteEvent extends TaskEvent {
  Task task;
  int index;

  TaskDeleteEvent(this.task, this.index);
}

class TaskEditEvent extends TaskEvent {
  Task task;
  int index;

  TaskEditEvent(this.task, this.index);
}
