import 'package:flutter/material.dart';

import '../providers/task.dart';
import '../screens/task_detail_screen.dart';

class TaskView extends StatelessWidget {
  final Task task;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  TaskView(this.task);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(4),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(TaskDetailScreen.routeName);
        },
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.name,
                // ignore: prefer_const_constructors
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                calculateTimeLeft(task.dueDate),
                // ignore: prefer_const_constructors
              )
            ],
          ),
        ),
        trailing: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Container(
            padding: EdgeInsets.all(4),
            // ignore: prefer_const_constructors
            decoration:
                // ignore: prefer_const_constructors
                BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red.shade100),

            child: Text(
              '${task.points}',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }

  String calculateTimeLeft(DateTime due) {
    final difference = due.difference(DateTime.now());
    return difference.inDays <= 1
        ? difference.inHours <= 2
            ? '${difference.inMinutes} minutes left'
            : '${difference.inHours} hours left'
        : '${difference.inDays} days left';
  }
}
