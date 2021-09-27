import 'package:flutter/material.dart';
import 'package:house_project/widgets/completed_task_view.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/tasks.dart';

class TasksCompletedScreen extends StatelessWidget {
  static const routeName = '/tasks-completed-screen';
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<Tasks>(context);
    final completedList = tasks.getDoneList;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Tasks Completed'),
      ),

      // ignore: sized_box_for_whitespace
      body: Container(
        height: 500,
        child: ListView.builder(
            itemCount: completedList.length,
            itemBuilder: (ctx, i) => CompletedTaskView(completedList[i])),
      ),
    );
  }
}
