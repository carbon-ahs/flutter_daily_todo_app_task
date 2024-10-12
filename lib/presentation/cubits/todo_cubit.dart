import 'dart:ffi';

import 'package:daily_todo_app/core/notification_helper.dart';
import 'package:daily_todo_app/domain/models/todo.dart';
import 'package:daily_todo_app/domain/repository/todo_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

class TodoLoadState {
  final List<Todo> todos;
  final int completedCount;
  final int incompleteCount;

  TodoLoadState({
    required this.todos,
    required this.completedCount,
    required this.incompleteCount,
  });
}

class TodoCubit extends Cubit<TodoLoadState> {
  final TodoRepo todoRepo;
  TodoCubit(this.todoRepo)
      : super(TodoLoadState(todos: [], completedCount: 0, incompleteCount: 0)) {
    loadTodos();
  }

  // Future<void> loadTodos() async {
  //   final todolist = await todoRepo.getTodos();
  //   emit(todolist);
  // }
  Future<void> loadTodos() async {
    final todolist = await todoRepo.getTodos();

    // Calculate the completed and incomplete counts
    final completedCount = todolist.where((todo) => todo.isCompleted).length;
    final incompleteCount = todolist.length - completedCount;

    // Emit the new state with todos and counts
    emit(TodoLoadState(
      todos: todolist,
      completedCount: completedCount,
      incompleteCount: incompleteCount,
    ));
  }

  Future<void> addTodo(String heading, String details, DateTime dueDate) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      heading: heading,
      details: details,
      dueDate: dueDate,
    );

    await todoRepo.addTodo(newTodo);
    NotificationHelper.scheduleTodoNotification(newTodo);
    loadTodos();
  }

  Future<void> updateTodo(int id, String heading, String details) async {
    // Future<void> updateTodo(Todo todo) async {
    final updatedTodo = Todo(
      id: id,
      heading: heading,
      details: details,
      dueDate: DateTime.now(),
    );

    // send to repo
    await todoRepo.updateTodo(updatedTodo);

    //re-load ui
    loadTodos();
  }

  Future<void> deleteTodo(Todo todo) async {
    // send to repo
    await todoRepo.deleteTodo(todo);

    //re-load ui
    loadTodos();
  }

  Future<void> toggleCompletion(Todo todo) async {
    final updatedTodo = todo.toggleCompletion();

    // update to repo
    await todoRepo.updateTodo(updatedTodo);

    //re-load ui
    loadTodos();
  }
}
