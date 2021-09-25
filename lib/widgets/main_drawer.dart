import 'package:flutter/material.dart';

import '../screens/add_task_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
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
                Navigator.pushNamed(context, AddTaskScreen.routeName);
              }),
          const ListTile(
            leading: Icon(
              Icons.filter,
              size: 26,
            ),
            title: Text(
              'Filters',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // onTap: () {
            //   Navigator.of(context).pushReplacementNamed('/filters');
            // },
          ),
        ],
      ),
    );
  }
}
