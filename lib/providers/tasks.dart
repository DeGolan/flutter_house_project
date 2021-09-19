import 'package:intl/intl.dart';

import './task.dart';

class Tasks {
  List<Task> toDoList = [
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

  List<Task> doneList = [];
  Tasks();

  List<Task> get getDoList {
    return toDoList;
  }

  List<Task> get getDoneList {
    return doneList;
  }

  void markAsDone(String taskId, String notes, String doneBy) {
    Task task =
        toDoList.where((taskToFind) => taskToFind.id == taskId).elementAt(0);
    task.notes = notes;
    task.doneBy = doneBy;
    doneList.add(task);
    toDoList.removeWhere((taskToFind) => taskToFind.id == taskId);
  }

  int getTotalScore(
      // ignore: avoid_init_to_null
      String email,
      [DateTime? date = null]) {
    var sum = 0;
    sum = doneList.fold(
        0,
        (previousValue, task) =>
            previousValue + (task.doneBy == email ? task.points : 0));
    return sum;
  }
}
