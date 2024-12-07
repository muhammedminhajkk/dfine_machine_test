import 'package:dfine_machine_test/features/home/model/todo.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class ToggleTodoCompletion extends TodoEvent {
  final int index;
  ToggleTodoCompletion(this.index);
}

class DeleteTodo extends TodoEvent {
  final int index;
  DeleteTodo(this.index);
}
