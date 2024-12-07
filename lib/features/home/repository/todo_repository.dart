import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo.dart';

class TodoRepository {
  final SharedPreferences prefs;

  TodoRepository(this.prefs);

  Future<List<Todo>> loadTodos() async {
    final todosString = prefs.getString('todos');
    if (todosString != null) {
      final List decoded = jsonDecode(todosString);
      return decoded.map((item) => Todo.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final todosString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosString);
  }
}
