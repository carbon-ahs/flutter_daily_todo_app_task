import 'package:daily_todo_app/core/notification_helper.dart';
import 'package:daily_todo_app/presentation/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'package:daily_todo_app/domain/repository/todo_repo.dart';
import 'data/repository/isar_todo_repo.dart';
import 'core/database_helper.dart';
import 'presentation/cubits/todo_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  Workmanager().initialize(NotificationHelper.executeNotification, isInDebugMode: false);

  final isar = await DatabaseHelper.getDatabase();
  final todoRepo = IsarTodoRepo(isar);

  runApp(MyApp(todoRepo: todoRepo));
}

class MyApp extends StatelessWidget {
  final TodoRepo todoRepo;

  const MyApp({super.key, required this.todoRepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoCubit(todoRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoPage(todoRepo: todoRepo),
      ),
    );
  }
}
