import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/todo_cubit.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _headingController = TextEditingController();
  final _detailsController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDate = DateTime(
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

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _headingController,
              decoration: const InputDecoration(labelText: 'Heading'),
            ),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            TextButton(
              onPressed: () => _pickDate(context),
              child: const Text('Pick Due Date'),
            ),
            if (_selectedDate != null)
              Text('Selected Date: ${_selectedDate.toString()}'),
            ElevatedButton(
              onPressed: () {
                if (_headingController.text.isNotEmpty && _selectedDate != null) {
                  todoCubit.addTodo(
                    _headingController.text,
                    _detailsController.text,
                    _selectedDate!,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
