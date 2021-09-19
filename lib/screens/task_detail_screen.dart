import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = '/task-detail-screen';
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task name') //to change
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
              },
              child: Text(
                'Submit',
              ))
        ],
      ),
    );
  }
}
