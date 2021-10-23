import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task.dart';
import '../screens/task_detail_screen.dart';
import '../providers/tasks.dart';

class TaskView extends StatelessWidget {
  final Task task;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  TaskView(this.task);

  @override
  Widget build(BuildContext context) {
    final timeLeft = calculateTimeLeft(task.dueDate!);
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.all(4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await Provider.of<Tasks>(context, listen: false)
            .removeToDoTask(task.id!);
      },
      child: Card(
        // color:
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white)),
        elevation: 2,
        margin: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors:
                  // const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  // const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  timeLeft.contains('days')
                      ? [Colors.green, Colors.green.shade100]
                      : timeLeft.contains('hours')
                          ? [Colors.yellow, Colors.yellow.shade100]
                          : timeLeft.contains('minutes')
                              ? [Colors.orange, Colors.orange.shade100]
                              : [Colors.red, Colors.red.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, 1],
            ),
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(TaskDetailScreen.routeName, arguments: task.id);
            },
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    calculateTimeLeft(task.dueDate!),
                  )
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey.shade100),
                child: Text(
                  '${task.points}',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
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
            ? difference.isNegative
                ? 'overdue'
                : '${difference.inMinutes} minutes left'
            : '${difference.inHours} hours left'
        : '${difference.inDays} days left';
  }
}
