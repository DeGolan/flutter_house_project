import 'package:flutter/material.dart';

class Task extends ChangeNotifier implements Comparable {
  String? id;
  final String name;
  final String description;
  final String houseId;
  final DateTime? dueDate;
  DateTime? completedDate;
  final int points;
  String doneBy;
  String notes;

  Task(
      {this.id,
      required this.name,
      this.description = '',
      required this.houseId,
      required this.dueDate,
      this.completedDate,
      this.doneBy = '',
      required this.points,
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
