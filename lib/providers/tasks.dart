import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './task.dart';

class Tasks extends ChangeNotifier {
  List<Task> _toDoList = [
    Task(
        id: 'id1',
        name: 'name1',
        description:
            'please clean you bitch,I will fuck ur face up. dont forget under the bed1',
        houseId: 'houseId1',
        dueDate: DateTime.now().add(Duration(days: 4))),
    Task(
        id: 'id2',
        name: 'name2',
        description:
            'please clean you bitch,I will fuck ur face up. dont forget under the bed2',
        houseId: 'houseId2',
        dueDate: DateTime.now().add(Duration(days: 1))),
    Task(
        id: 'id3',
        name: 'name3',
        description:
            'please clean you bitch,I will fuck ur face up. dont forget under the bed3',
        houseId: 'houseId3',
        dueDate: DateTime.now().add(Duration(hours: 3))),
    Task(
        id: 'id4',
        name: 'name4',
        description:
            'please clean you bitch,I will fuck ur face up. dont forget under the bed4',
        houseId: 'houseId4',
        dueDate: DateTime.now().add(Duration(hours: 1))),
  ];

  List<Task> _doneList = [];

  Tasks() {
    sortTasks();
  }

  void addTask(Task task) {
    int i = 0;
    while (i < _toDoList.length) {
      if (_toDoList[i].compareTo(task) == 1) {
        break;
      }
      i++;
    }
    _toDoList.insert(i, task);
    notifyListeners();
  }

  List<Task> get getDoList {
    return [..._toDoList];
  }

  void sortTasks() {
    _toDoList.sort();

    notifyListeners();
  }

  List<Task> get getDoneList {
    return [..._doneList];
  }

  void markAsDone(String taskId, String notes, String doneBy) {
    Task task =
        _toDoList.where((taskToFind) => taskToFind.id == taskId).elementAt(0);
    task.notes = notes;
    task.doneBy = doneBy;
    _doneList.add(task);
    _toDoList.removeWhere((taskToFind) => taskToFind.id == taskId);
    notifyListeners();
  }

  int getTotalScore(
      // ignore: avoid_init_to_null
      String email,
      [DateTime? date = null]) {
    var sum = 0;
    sum = _doneList.fold(
        0,
        (previousValue, task) =>
            previousValue + (task.doneBy == email ? task.points : 0));
    return sum;
  }
}
