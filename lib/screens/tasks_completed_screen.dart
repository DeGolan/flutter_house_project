import 'package:flutter/material.dart';
import 'package:house_project/widgets/completed_task_view.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/tasks.dart';

class TasksCompletedScreen extends StatefulWidget {
  static const routeName = '/tasks-completed-screen';

  const TasksCompletedScreen({Key? key}) : super(key: key);

  @override
  State<TasksCompletedScreen> createState() => _TasksCompletedScreenState();
}

class _TasksCompletedScreenState extends State<TasksCompletedScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Tasks>(context).fetchAndSetDoneList().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<Tasks>(context);
    final completedList = tasks.getDoneList;
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Tasks Completed'),
      ),

      // ignore: sized_box_for_whitespace
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: 500,
              child: ListView.builder(
                  itemCount: completedList.length,
                  itemBuilder: (ctx, i) => CompletedTaskView(completedList[i])),
            ),
    );
  }
}
