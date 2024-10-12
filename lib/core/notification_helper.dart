import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daily_todo_app/domain/models/todo.dart';
import 'package:workmanager/workmanager.dart';

class NotificationHelper {
  static void init() async{
    await AwesomeNotifications().initialize(
      'assets/splash_logo.png',
      [
        NotificationChannel(
          channelKey: 'todo_channel',
          channelName: 'Todo Notifications',
          channelDescription: 'Notification channel for todo reminders',
        ),
      ],
    );
  }

  static void executeNotification() {
    Workmanager().executeTask((task, inputData) async {
      final int todoId = inputData?['todoId'] ?? 0;
      final String title = inputData?['title'] ?? 'Todo Reminder';

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: todoId,
          channelKey: 'todo_channel',
          title: 'Reminder: $title',
          body: 'It\'s time to complete your task!',
          notificationLayout: NotificationLayout.Default,
        ),
      );

      return Future.value(true);
    });
  }

  static void scheduleTodoNotification(Todo todo) {
    final notificationId = todo.id % 2147483647;

    Workmanager().registerOneOffTask(
      '$notificationId',
      'todo_notification',
      inputData: {
        'todoId': notificationId,
        'title': todo.heading,
      },
      initialDelay: todo.dueDate.difference(DateTime.now()),
    );
  }


}
