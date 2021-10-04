import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/tasks_completed_screen.dart';
import '../screens/add_task_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: const Text(
              'House Project',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
              leading: const Icon(
                Icons.assignment,
                size: 26,
              ),
              title: const Text(
                'ToDo List',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              }),
          ListTile(
              leading: const Icon(
                Icons.add_task,
                size: 26,
              ),
              title: const Text(
                'Add Task',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                //Navigator.pop(context);
                Navigator.pushNamed(context, AddTaskScreen.routeName);
              }),
          ListTile(
            leading: const Icon(
              Icons.assignment_turned_in_outlined,
              size: 26,
            ),
            title: const Text(
              'Completed Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, TasksCompletedScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              size: 26,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
