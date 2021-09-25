import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/task_view.dart';
import '../providers/tasks.dart';
import './add_task_screen.dart';

class TasksOverviewScreen extends StatefulWidget {
  static const routeName = '/tasks-overview-screen';
  const TasksOverviewScreen({Key? key}) : super(key: key);

  @override
  State<TasksOverviewScreen> createState() => _TasksOverviewScreenState();
}

class _TasksOverviewScreenState extends State<TasksOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final userName = 'aviv'; //todo get logged user name.
    final tasks = Provider.of<Tasks>(context);
    final toDoList = tasks.getDoList;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AddTaskScreen.routeName),
            icon: Icon(Icons.add_task),
          ),
        ],
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
                  Text('Total Score: ${tasks.getTotalScore(userName)}'),
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
}
