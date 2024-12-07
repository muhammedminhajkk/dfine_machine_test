import '../model/todo.dart';

abstract class TodoState {}

class TodosLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;
  TodosLoaded(this.todos);
}

class TodosError extends TodoState {
  final String message;
  TodosError(this.message);
}
