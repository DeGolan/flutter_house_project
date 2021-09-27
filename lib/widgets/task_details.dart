import 'package:flutter/material.dart';
import 'package:house_project/providers/task.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatelessWidget {
  final Task task;
  // ignore: use_key_in_widget_constructors
  const TaskDetails(this.task);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Text(task.name),
          Text(task.description),
          Text(task.doneBy),
          Text(DateFormat.yMd().add_jm().format(task.dueDate!)),
          Text(DateFormat.yMd().add_jm().format(task.completedDate!)),
          Text(task.notes),
          Text(task.points.toString()),
        ],
      ),
    );
  }
}
