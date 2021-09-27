import 'package:flutter/material.dart';

class Task extends ChangeNotifier implements Comparable {
  final String? id;
  final String name;
  final String description;
  final String houseId;
  final DateTime? dueDate;
  final int points;
  String doneBy;
  String notes;

  Task(
      {required this.id,
      required this.name,
      this.description = '',
      required this.houseId,
      required this.dueDate,
      this.doneBy = '',
      this.points = 10,
      this.notes = ''});

  @override
  int compareTo(other) {
    if (other == null) {
      return 0;
    }
    if (dueDate!.difference(other.dueDate!).isNegative) {
      return 0;
    }
    return 1;
  }
}
