import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task.dart';
import '../providers/tasks.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = '/task-detail-screen';
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<Tasks>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final task = tasks.getDoList.firstWhere(
        (task) => task.id == id); //add what happends when task not found.
    return Scaffold(
      appBar: AppBar(title: Text(task.name) //to change
          ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Notes'),
                controller: notesController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              )),
          ElevatedButton(
              onPressed: () {
                print(notesController.text);
                tasks.markAsDone(
                    id, notesController.text, 'aviv'); // change to logged user
                Navigator.of(context).pop();
              },
              child: Text(
                'Submit',
              ))
        ],
      ),
    );
  }
}
