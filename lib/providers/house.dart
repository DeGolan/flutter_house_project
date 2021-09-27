import 'package:house_project/providers/tasks.dart';

import './user.dart';

class House {
  final String id;
  final String name;
  final Tasks taskList;
  final List<User> residentList;

  House(this.id, this.name, this.taskList, this.residentList);
}
