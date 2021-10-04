import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/tasks.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = '/task-detail-screen';
  final notesController = TextEditingController();

  TaskDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<Auth>(context, listen: false).userName;
    final tasks = Provider.of<Tasks>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final task = tasks.getDoList.firstWhere(
        (task) => task.id == id); //add what happends when task not found.
    return Scaffold(
      appBar: AppBar(title: Text(task.name) //to change
          ),
      body: Column(
        children: [
          Text('description:\n${task.description}'),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Notes'),
                controller: notesController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              )),
          ElevatedButton(
              onPressed: () {
                // ignore: avoid_print
                print(notesController.text);
                tasks.markAsDone(id, notesController.text, userName!);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Submit',
              ))
        ],
      ),
    );
  }
}
