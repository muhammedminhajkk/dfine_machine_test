import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/todo_bloc.dart';
import '../controller/todo_event.dart';
import '../controller/todo_state.dart';
import '../model/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 60, 60, 60),
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 60, 60, 60),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoaded) {
            final todos = state.todos;
            final categories = todos.map((todo) => todo.category).toSet();

            return ListView(
              children: categories.map((category) {
                final categoryTodos =
                    todos.where((todo) => todo.category == category).toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    backgroundColor: Colors.blueGrey[50],
                    collapsedBackgroundColor: Colors.grey,
                    title: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    children: categoryTodos.map((todo) {
                      final index = todos.indexOf(todo);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 2, // Adds a slight shadow for depth
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) {
                              context
                                  .read<TodoBloc>()
                                  .add(ToggleTodoCompletion(index));
                            },
                            activeColor:
                                Colors.green, // Checkbox color when checked
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.isCompleted
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              context.read<TodoBloc>().add(DeleteTodo(index));
                            },
                            tooltip: 'Delete Todo',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          } else if (state is TodosError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No Todos'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final category = categoryController.text;
                if (title.isNotEmpty && category.isNotEmpty) {
                  context.read<TodoBloc>().add(AddTodo(Todo(
                        title: title,
                        isCompleted: false,
                        category: category,
                      )));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
