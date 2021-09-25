import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/tasks.dart';
import '../screens/tasks_overview_screen.dart';
import '../screens/task_detail_screen.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Tasks(),
      child: MaterialApp(
        home: TasksOverviewScreen(),
        routes: {
          TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
        },
      ),
    );
  }
}
