/*

Todo repo.

what app can do.

*/

import 'package:daily_todo_app/domain/models/todo.dart';

abstract class TodoRepo {
  // add
  Future<void> addTodo(Todo newTodo);

  // get
  Future<List<Todo>> getTodos();

  // update
  Future<void> updateTodo(Todo todo);

  // delete
  Future<void> deleteTodo(Todo todo);
}

/*

Notes:
- outline of app function.
- impl in data layer

*/
