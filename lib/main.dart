import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/add_task_screen.dart';
import './providers/tasks.dart';
import '../screens/tasks_overview_screen.dart';
import '../screens/task_detail_screen.dart';
import '../screens/tasks_completed_screen.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Tasks(),
      child: MaterialApp(
        home: const TasksOverviewScreen(),
        routes: {
          TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
          AddTaskScreen.routeName: (ctx) => const AddTaskScreen(),
          TasksCompletedScreen.routeName: (ctx) => const TasksCompletedScreen(),
        },
      ),
    );
  }
}
