import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../providers/task.dart';
import '../screens/task_detail_screen.dart';
import '../providers/tasks.dart';

class TaskView extends StatelessWidget {
  final Task task;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  TaskView(this.task);

  @override
  Widget build(BuildContext context) {
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
        // shape: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10),
        //     borderSide: const BorderSide(color: Colors.white)),
        elevation: 0,
        // margin: const EdgeInsets.all(4),
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(TaskDetailScreen.routeName, arguments: task.id);
          },
          leading: Container(
            width: 280,
            height: 80,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          task.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          calculateTimeLeft(task.dueDate!),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Divider(),
                      Text(
                        '${task.points} Points',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          trailing: SizedBox(
            height: 80,
            width: 80,
            child: PieChart(
              initialAngleInDegree: 270,
              dataMap: dataMap(task.dueDate!),
              colorList: colorList(task.dueDate!),
              legendOptions: const LegendOptions(showLegends: false),
              chartValuesOptions:
                  const ChartValuesOptions(showChartValues: false),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, double> dataMap(DateTime due) {
    final difference = due.difference(DateTime.now());
    return difference.inDays < 1
        ? difference.inHours < 1
            ? difference.isNegative
                ? {'timeLeft': 1} //overDue
                : {
                    'rest': 60 - difference.inMinutes.toDouble(),
                    'timeLeft': difference.inMinutes.toDouble()
                  } //min
            : {
                'rest': 24 - difference.inHours.toDouble(),
                'timeLeft': difference.inHours.toDouble()
              } //hours
        : difference.inDays.toDouble() < 7
            ? {
                'rest': 7 - difference.inDays.toDouble(),
                'timeleft': difference.inDays.toDouble()
              }
            : {'timeLeft': 1}; //days
  }

  List<Color> colorList(DateTime due) {
    final difference = due.difference(DateTime.now());
    return difference.inDays < 1
        ? difference.inHours < 1
            ? difference.isNegative
                ? [Colors.red] //overDue
                : [Colors.red.shade100, Colors.red] //min
            : [Colors.yellow.shade100, Colors.yellow] //hours
        : difference.inDays.toDouble() < 7
            ? [Colors.green.shade100, Colors.green]
            : [Colors.green]; //days
  }

  String calculateTimeLeft(DateTime due) {
    final difference = due.difference(DateTime.now());
    return difference.inDays < 1
        ? difference.inHours < 1
            ? difference.isNegative
                ? 'overdue'
                : '${difference.inMinutes} minutes left'
            : '${difference.inHours} hours left'
        : '${difference.inDays} days left';
  }
}
