import 'package:flutter/material.dart';
import 'package:house_project/screens/scoreboard_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './task.dart';

class Tasks extends ChangeNotifier {
  final String? _authToken;
  String _houseId = '';
  final String? _userId;

  String get houseId {
    return _houseId;
  }

  Map<String, int> _scoreboard = {};

  List<Task> _toDoList = [
    // Task(
    //     id: 'id1',
    //     name: 'name1',
    //     description:
    //         'please clean you bitch,I will fuck ur face up. dont forget under the bed1',
    //     houseId: 'houseId1',
    //     dueDate: DateTime.now().add(const Duration(days: 4))),
    // Task(
    //     id: 'id2',
    //     name: 'name2',
    //     description:
    //         'please clean you bitch,I will fuck ur face up. dont forget under the bed2',
    //     houseId: 'houseId2',
    //     dueDate: DateTime.now().add(const Duration(days: 1))),
    // Task(
    //     id: 'id3',
    //     name: 'name3',
    //     description:
    //         'please clean you bitch,I will fuck ur face up. dont forget under the bed3',
    //     houseId: 'houseId3',
    //     dueDate: DateTime.now().add(const Duration(hours: 3))),
    // Task(
    //     id: 'id4',
    //     name: 'name4',
    //     description:
    //         'please clean you bitch,I will fuck ur face up. dont forget under the bed4',
    //     houseId: 'houseId4',
    //     dueDate: DateTime.now().add(const Duration(hours: 1))),
  ];
  void setHouseId(String houseId) {
    _houseId = houseId;
  }

  List<Task> _doneList = [];

  Tasks(this._authToken, this._toDoList, this._doneList, this._userId) {
    sortTasks();
  }

  List<Task> get getDoList {
    return [..._toDoList];
  }

  List<Task> get getDoneList {
    return [..._doneList];
  }

  String? get userId {
    return _userId;
  }

  Map<String, int> get scoreboard {
    return _scoreboard;
  }

  Future<void> setScoreBoard() async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$_houseId/tasks/done-list.json?auth=$_authToken');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      final Map<String, int> score = {};
      if (extractedData != null) {
        extractedData.forEach((taskId, taskData) {
          score.update(taskData['doneBy'],
              (currPoints) => currPoints + int.parse(taskData['points']),
              ifAbsent: () => int.parse(taskData['points']));
        });
      }
      _scoreboard = score;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetToDoList() async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$_houseId/tasks/to-do-list.json?auth=$_authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      final List<Task> loadedTasks = [];
      if (extractedData != null) {
        extractedData.forEach((taskId, taskData) {
          final task = Task(
              name: taskData['name'],
              houseId: taskData['houseId'],
              dueDate: DateTime.parse(taskData['dueDate']),
              id: taskId,
              points: int.parse(taskData['points']),
              description: taskData['description']);
          //add the task in the current position
          int i = 0;
          while (i < loadedTasks.length) {
            if (loadedTasks[i].compareTo(task) == 1) {
              break;
            }
            i++;
          }
          loadedTasks.insert(i, task);
        });
        _toDoList = loadedTasks;
        notifyListeners();
      }
    } catch (error) {
      //need to handle error
      rethrow;
    }
  }

  Future<void> fetchAndSetDoneList() async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$_houseId/tasks/done-list.json?auth=$_authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      final List<Task> loadedTasks = [];
      if (extractedData != null) {
        extractedData.forEach((taskId, taskData) {
          final task = Task(
              name: taskData['name'],
              houseId: taskData['houseId'],
              dueDate: DateTime.parse(taskData['dueDate']),
              id: taskData['id'],
              points: int.parse(taskData['points']),
              description: taskData['description'],
              completedDate: DateTime.parse(taskData['completedDate']),
              doneBy: taskData['doneBy'],
              notes: taskData['notes']);

          loadedTasks.add(task);
        });
        _doneList = loadedTasks;
        notifyListeners();
      }
    } catch (error) {
      //need to handle error
      rethrow;
    }
  }

  Future<void> addTask(Task task) async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$_houseId/tasks/to-do-list.json?auth=$_authToken');
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
      // ignore: avoid_print
      print(error);
      rethrow;
    }
  }

  void sortTasks() {
    _toDoList.sort();
    notifyListeners();
  }

  Future<void> markAsDone(String taskId, String notes, String doneBy) async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$_houseId/tasks/to-do-list/$taskId.json?auth=$_authToken');
    try {
      //getting the currnet task from to do list in firebase
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData != null) {
        final task = Task(
            name: extractedData['name'],
            houseId: extractedData['houseId'],
            dueDate: DateTime.parse(extractedData['dueDate']),
            id: taskId,
            points: int.parse(extractedData['points']),
            description: extractedData['description'],
            doneBy: doneBy, //need to get from user in the future
            notes: notes,
            completedDate: DateTime.now());

        final urlDoneList = Uri.parse(
            'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$_houseId/tasks/done-list.json?auth=$_authToken');
        try {
          //putting the done list in firebase
          await http.post(urlDoneList,
              body: json.encode({
                'id': task.id,
                'name': task.name,
                'description': task.description,
                'houseId': task.houseId,
                'dueDate': task.dueDate!.toIso8601String(),
                'points': task.points.toString(),
                'doneBy': task.doneBy,
                'notes': notes,
                'completedDate': task.completedDate!.toIso8601String()
              }));
        } catch (error) {
          rethrow;
        }
        _doneList.insert(0, task);
        try {
          //deleting current task from to do list in firebase
          await http.delete(url);
          _toDoList.removeWhere((taskToFind) => taskToFind.id == taskId);
          notifyListeners();
        } catch (error) {
          rethrow;
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  int getTotalScore(
      // ignore: avoid_init_to_null
      String email,
      // ignore: avoid_init_to_null
      [DateTime? date = null]) {
    var sum = 0;
    sum = _doneList.fold(
        0,
        (previousValue, task) =>
            previousValue + (task.doneBy == email ? task.points : 0));
    return sum;
  }
}
