class Todo {
  final int id;
  final String heading;
  final String? details;
  final DateTime dueDate;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.heading,
    this.details,
    required this.dueDate,
    this.isCompleted = false,
  });

  Todo toggleCompletion() {
    return Todo(
      id: id,
      heading: heading,
      details: details,
      dueDate: dueDate,
      isCompleted: !isCompleted,
    );
  }
}
