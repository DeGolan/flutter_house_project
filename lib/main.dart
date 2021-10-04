import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './screens/add_task_screen.dart';
import './providers/tasks.dart';
import './providers/auth.dart';
import '../screens/task_detail_screen.dart';
import '../screens/tasks_completed_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/tasks_overview_screen.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Tasks>(
          update: (ctx, auth, previousTasks) => Tasks(
              auth.token,
              previousTasks == null ? [] : previousTasks.getDoList,
              previousTasks == null ? [] : previousTasks.getDoneList,
              auth.userId),
          create: (ctx) => Tasks(null, [], [], null),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          home: auth.isAuth
              ? const TasksOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          routes: {
            TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
            AddTaskScreen.routeName: (ctx) => const AddTaskScreen(),
            TasksCompletedScreen.routeName: (ctx) =>
                const TasksCompletedScreen(),
          },
        ),
      ),
    );
  }
}
