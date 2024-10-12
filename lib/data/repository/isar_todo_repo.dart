/*

DATABASE REPO

impl of domain repo to use db;

 */

import 'package:daily_todo_app/data/models/isar_todo.dart';
import 'package:daily_todo_app/domain/models/todo.dart';
import 'package:daily_todo_app/domain/repository/todo_repo.dart';
import 'package:isar/isar.dart';

class IsarTodoRepo implements TodoRepo {
  //db
  final Isar db;

  IsarTodoRepo(this.db);

  @override
  Future<void> addTodo(Todo newTodo) async {
    // convert todo into isar_todo
    final todoIsar = TodoIsar.fromDomain(newTodo);

    //store in db
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

  @override
  Future<List<Todo>> getTodos() async {
    // fetch from db
    final todos = await db.todoIsars.where().findAll();
    return todos.map((todoIsar) => todoIsar.toDomain()).toList();
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    // convert todo into isar_todo
    final todoIsar = TodoIsar.fromDomain(todo);

    //update in db
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await db.writeTxn(() => db.todoIsars.delete(todo.id));
  }
}
