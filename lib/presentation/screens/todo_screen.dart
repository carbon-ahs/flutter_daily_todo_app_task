import 'package:daily_todo_app/presentation/widgets/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../domain/models/todo.dart';
import '../cubits/todo_cubit.dart';
import '../sensor_traking_page.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void _showAddTodoDialog(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final headingController = TextEditingController();
    final detailsController = TextEditingController();
    DateTime? selectedDate;

    void pickDate() async {
      final selectedDateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );

      if (selectedDateTime != null) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          setState(() {
            selectedDate = DateTime(
              selectedDateTime.year,
              selectedDateTime.month,
              selectedDateTime.day,
              selectedTime.hour,
              selectedTime.minute,
            );
          });
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: headingController,
              decoration: const InputDecoration(labelText: 'Heading'),
            ),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            TextButton(
              onPressed: pickDate,
              child: const Text('Pick Due Date'),
            ),
            if (selectedDate != null)
              Text('Selected Date: ${selectedDate.toString()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (headingController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Heading cannot be empty!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                return;
              }
              if (detailsController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Details cannot be empty!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                return;
              }
              if (selectedDate == null) {
                Fluttertoast.showToast(
                  msg: 'Pls pick date',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                return;
              }
              todoCubit.addTodo(
                headingController.text,
                detailsController.text,
                selectedDate!,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showUpdateTodoDialog(BuildContext context, Todo todo) {
    final todoCubit = context.read<TodoCubit>();
    // final headingController = TextEditingController();
    // final detailsController = TextEditingController();
    DateTime selectedDate = todo.dueDate;

    void pickDate() async {
      final selectedDateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );

      if (selectedDateTime != null) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          setState(() {
            selectedDate = todo.dueDate;
          });
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        final headingController = TextEditingController(text: todo.heading);
        final detailsController = TextEditingController(text: todo.details!);

        return AlertDialog(
          title: const Text('Update Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: headingController,
                decoration: const InputDecoration(labelText: 'New Heading'),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'New Details'),
              ),
              TextButton(
                onPressed: pickDate,
                child: const Text('Pick Due Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (headingController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Heading cannot be empty!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                if (detailsController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Details cannot be empty!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                if (selectedDate == null) {
                  Fluttertoast.showToast(
                    msg: 'Details cannot be empty!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                todoCubit.updateTodo(
                  todo.id,
                  headingController.text,
                  detailsController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    return BlocBuilder<TodoCubit, TodoLoadState>(
      builder: (context, state) {
        final todos = state.todos;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Daily-Todo App'),
            leading: const Icon(Icons.sensors),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ProfileInfoCard(
                  completedTasks: state.completedCount,
                  incompletedTasks: state.incompleteCount,
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(
                        todo.heading,
                        style: todo.isCompleted
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough)
                            : null,
                      ),
                      subtitle: Text(
                        todo.details!,
                        style: todo.isCompleted
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough)
                            : null,
                      ),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) => todoCubit.toggleCompletion(todo),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => todoCubit.deleteTodo(todo),
                      ),
                      onTap: () => _showUpdateTodoDialog(context, todo),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.sensors),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SensorTrackingPage(),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _showAddTodoDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
