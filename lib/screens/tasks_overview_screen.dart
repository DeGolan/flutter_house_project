import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:house_project/widgets/task_view.dart';

import '../providers/tasks.dart';

class TasksOverviewScreen extends StatefulWidget {
  static const routeName = '/tasks-overview-screen';
  const TasksOverviewScreen({Key? key}) : super(key: key);

  @override
  State<TasksOverviewScreen> createState() => _TasksOverviewScreenState();
}

class _TasksOverviewScreenState extends State<TasksOverviewScreen> {
  final tasks = Tasks();
  @override
  Widget build(BuildContext context) {
    final toDoList = tasks.getDoList;
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Tasks'), //need to replace the name
      ),
      body: Column(
        children: [
          Container(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total Score: ${tasks.getTotalScore('aviv')}'),
                  // ignore: prefer_const_constructors
                  Text('Hey Aviv'),
                ],
              )),
          // ignore: sized_box_for_whitespace
          Expanded(
            child: ListView.builder(
                itemCount: toDoList.length,
                itemBuilder: (ctx, i) => TaskView(toDoList[i])),
          )
        ],
      ),
    );
  }

  void markAsDone(String taskId, String notes, String doneBy) {
    setState(() {
      tasks.markAsDone(taskId, notes, doneBy);
    });
  }
}
