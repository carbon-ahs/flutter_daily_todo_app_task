/*

  - responsible for provide cubit to view(ui) using BlockProvider and splash screen

*/
import 'package:daily_todo_app/domain/repository/todo_repo.dart';
import 'package:daily_todo_app/presentation/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/todo_cubit.dart';
import 'screens/splash_screen.dart';
// import 'screens/todo_screen_copy.dart';

class TodoPage extends StatefulWidget {
  final TodoRepo todoRepo;

  const TodoPage({
    super.key,
    required this.todoRepo,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool isInit = false;
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    // Perform async tasks like loading todos
    await Future.delayed(const Duration(seconds: 1)); // Simulating loading time

    setState(() {
      isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(widget.todoRepo),
      child: isInit ? const TodoScreen() : const SplashScreen(),
    );
  }
}
