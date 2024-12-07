import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/todo_repository.dart';
import '../model/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodoCompletion>(_onToggleTodoCompletion);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodosLoading());
    try {
      final todos = await repository.loadTodos();
      emit(TodosLoaded(todos));
    } catch (e) {
      emit(TodosError('Failed to load todos'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final todos = List<Todo>.from((state as TodosLoaded).todos)
        ..add(event.todo);
      await repository.saveTodos(todos);
      emit(TodosLoaded(todos));
    }
  }

  Future<void> _onToggleTodoCompletion(
      ToggleTodoCompletion event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final todos = List<Todo>.from((state as TodosLoaded).todos);
      todos[event.index] = Todo(
          title: todos[event.index].title,
          isCompleted: !todos[event.index].isCompleted,
          category: todos[event.index].category);
      await repository.saveTodos(todos);
      emit(TodosLoaded(todos));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      final todos = List<Todo>.from((state as TodosLoaded).todos)
        ..removeAt(event.index);
      await repository.saveTodos(todos);
      emit(TodosLoaded(todos));
    }
  }
}
