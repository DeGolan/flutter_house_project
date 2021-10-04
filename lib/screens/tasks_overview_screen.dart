import 'package:flutter/material.dart';
import 'package:house_project/providers/auth.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/task_view.dart';
import '../providers/tasks.dart';
import './add_task_screen.dart';

class TasksOverviewScreen extends StatefulWidget {
  static const routeName = '/tasks-overview-screen';
  const TasksOverviewScreen({Key? key}) : super(key: key);

  @override
  State<TasksOverviewScreen> createState() => _TasksOverviewScreenState();
}

class _TasksOverviewScreenState extends State<TasksOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Tasks>(context).fetchAndSetToDoList().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      //Refreshing done list alson to get score,
      //need to find a better way to get score
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

  Future<void> _refreshToDoList(BuildContext context) async {
    await Provider.of<Tasks>(context, listen: false).fetchAndSetToDoList();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final userName = Provider.of<Auth>(context, listen: false).userName;
    final tasks = Provider.of<Tasks>(context);
    final toDoList = tasks.getDoList;
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AddTaskScreen.routeName),
            icon: const Icon(Icons.add_task),
          ),
        ],
        title: const Text('Tasks'), //need to replace the name
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshToDoList(context),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              'Total Score: ${tasks.getTotalScore(userName!)}'),
                          // ignore: prefer_const_constructors
                          Text('Hey $userName'),
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: toDoList.length,
                        itemBuilder: (ctx, i) => TaskView(toDoList[i])),
                  ),
                ],
              ),
      ),
    );
  }
}
