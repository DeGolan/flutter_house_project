import 'package:house_project/providers/tasks.dart';

import './user.dart';

class House {
  final String id;
  final String name;
  final String manager;
  final Tasks taskList;
  final List<User> residentList;

  House(this.id, this.name, this.manager, this.taskList, this.residentList);
}
