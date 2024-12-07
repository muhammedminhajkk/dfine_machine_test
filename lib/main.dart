import 'package:dfine_machine_test/features/home/controller/todo_bloc.dart';
import 'package:dfine_machine_test/features/home/controller/todo_event.dart';
import 'package:dfine_machine_test/features/home/repository/todo_repository.dart';
import 'package:dfine_machine_test/features/home/view/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final repository = TodoRepository(prefs);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TodoRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TodoBloc(repository)..add(LoadTodos()), // Initialize TodoBloc here
      child: const MaterialApp(
        home: TodoPage(),
      ),
    );
  }
}
