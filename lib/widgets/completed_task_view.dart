import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/task_details.dart';
import '../providers/task.dart';

class CompletedTaskView extends StatelessWidget {
  final Task task;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  CompletedTaskView(this.task);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      child: ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => TaskDetails(task),
            );
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
                Text(DateFormat.yMd().add_jm().format(task.completedDate!))
              ],
            ),
          ),
          trailing: Text('done by: ${task.doneBy}')),
    );
  }
}
