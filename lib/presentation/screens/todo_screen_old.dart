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
  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final headingTextController = TextEditingController();
    final detailsTextController = TextEditingController();
    DateTime? selectedDate0;

    void pickDate(BuildContext context) async {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
      );

      if (selectedDate != null) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          setState(() {
            selectedDate0 = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
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
              controller: headingTextController,
              decoration: const InputDecoration(labelText: 'Heading'),
            ),
            TextField(
              controller: detailsTextController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            TextButton(
              onPressed: () => pickDate(context),
              child: const Text('Pick Due Date'),
            ),
            if (selectedDate0 != null)
              Text('Selected Date: ${selectedDate0.toString()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (headingTextController.text.isEmpty) {
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
              if (detailsTextController.text.isEmpty) {
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
              if (headingTextController.text.isNotEmpty &&
                  detailsTextController.text.isNotEmpty &&
                  selectedDate0 != null) {
                todoCubit.addTodo(
                  headingTextController.text,
                  detailsTextController.text,
                  selectedDate0!,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // cubit
    final todoCubit = context.read<TodoCubit>();
    return BlocBuilder<TodoCubit, TodoLoadState>(
      builder: (context, state) {
        var todos = state.todos;
        // List View
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
                    incompletedTasks: state.incompleteCount),
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
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) => todoCubit.toggleCompletion(todo),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => todoCubit.deleteTodo(todo),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final headingTextEditingController =
                                TextEditingController(text: todo.heading);
                            final detailsTextEditingController =
                                TextEditingController(text: todo.details!);
                            return AlertDialog(
                              title: const Text('Update Todo'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: headingTextEditingController,
                                    decoration: const InputDecoration(
                                        labelText: 'New Heading'),
                                  ),
                                  TextField(
                                    controller: detailsTextEditingController,
                                    decoration: const InputDecoration(
                                        labelText: 'New Details'),
                                  )
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
                                    todoCubit.updateTodo(
                                      todo.id,
                                      headingTextEditingController.text,
                                      detailsTextEditingController.text,
                                    );
                                    // todoCubit.updateTodo(todo);

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
                onPressed: () => _showAddTodoBox(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
