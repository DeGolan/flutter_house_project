import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> addTask(Task task) async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/tasks');
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': task.name,
            'description': task.description,
            'houseId': task.houseId,
            'dueDate': task.dueDate!.toIso8601String(),
            'points': task.points.toString(),
          }));
      task.id = json.decode(response.body)['name'];
      int i = 0;
      while (i < _toDoList.length) {
        if (_toDoList[i].compareTo(task) == 1) {
          break;
        }
        i++;
      }
      _toDoList.insert(i, task);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
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
    task.completedDate = DateTime.now();
    task.notes = notes;
    task.doneBy = doneBy;
    _doneList.insert(0, task);
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
