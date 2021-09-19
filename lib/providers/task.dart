class Task {
  final String id;
  final String name;
  final String description;
  final String houseId;
  final DateTime dueDate;
  final int points;
  String doneBy;
  String notes;

  Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.houseId,
      required this.dueDate,
      this.doneBy = '',
      this.points = 10,
      this.notes = ''});
}
