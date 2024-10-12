import 'package:daily_todo_app/domain/models/todo.dart';

class TodoCategory {
  final int id;
  final String title;
  final List<Todo>? todos;

  const TodoCategory({
    required this.id,
    required this.title,
    this.todos,
  });
}
