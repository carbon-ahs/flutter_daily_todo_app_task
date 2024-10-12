/*

ISAR TODO MODEL

Converts todo model into isar_todo model for store in db;

 */

import 'package:daily_todo_app/domain/models/todo.dart';
import 'package:isar/isar.dart';

// to generate isar_todo object, run: dart run build_runner build
part 'isar_todo.g.dart';

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String heading;
  late String? details;
  late DateTime dueDate;
  late bool isCompleted;

  // isar_todo -> todo
  Todo toDomain() {
    return Todo(
      id: id,
      heading: heading,
      details: details,
      dueDate: dueDate,
      isCompleted: isCompleted,
    );
  }

  // todo -> isar_todo
  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..heading = todo.heading
      ..details = todo.details
      ..dueDate = todo.dueDate
      ..isCompleted = todo.isCompleted;
  }
}
