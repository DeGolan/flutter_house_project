import 'package:flutter/material.dart';
import 'package:house_project/providers/auth.dart';
import 'package:house_project/providers/auth_house.dart';
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
  var _isInit = 0;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit < 2) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Tasks>(context, listen: false).fetchAndSetToDoList();
      await Provider.of<Tasks>(context, listen: false).fetchAndSetDoneList();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit++;
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
    final authHouse = Provider.of<AuthHouse>(context);
    tasks.setHouseId(authHouse.houseName!);
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
                          Text.rich(TextSpan(
                              style: const TextStyle(fontSize: 20),
                              children: [
                                const TextSpan(text: 'Welcome home '),
                                TextSpan(
                                    text: '$userName!',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))
                              ])),
                          Text.rich(
                            TextSpan(
                                style: const TextStyle(fontSize: 16),
                                children: [
                                  const TextSpan(text: 'Your total score is\n'),
                                  TextSpan(
                                      text:
                                          '${tasks.getTotalScore(userName!)} points',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]),
                            textAlign: TextAlign.center,
                          ),
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
