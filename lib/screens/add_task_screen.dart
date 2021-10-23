import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../providers/task.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = '/add-task-screen';

  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _descriptionFocusNode = FocusNode();

  final _pointsFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var validDate = true;

  var _isLoading = false;

  DateTime? _selectedDate;

  final _initValues = {
    'name': '',
    'description': '',
    'points': '',
    'dueDate': '',
  };

  var taskToAdd = Task(
    houseId: '1', //change to logged houseID
    name: '',
    dueDate: null,
    points: 0,
    description: '',
  );

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _pointsFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (_selectedDate == null) {
      setState(() {
        validDate = false;
      });
      return;
    }
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Tasks>(context, listen: false).addTask(taskToAdd);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/');
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An error occurred!'),
                content: const Text('Something went wrong.'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: const Text('OK'))
                ],
              ));
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ).then((pickedTime) {
        pickedDate = DateTime(
          pickedDate!.year,
          pickedDate!.month,
          pickedDate!.day,
          pickedTime!.hour,
          pickedTime.minute,
        );
        if (pickedDate!.difference(DateTime.now()) < Duration.zero) {
          setState(() {
            validDate = false;
            _selectedDate = null;
          });
          return;
        }

        taskToAdd = Task(
          houseId: taskToAdd.houseId, //change to logged houseID
          id: taskToAdd.id,
          name: taskToAdd.name,
          dueDate: pickedDate,
          points: taskToAdd.points,
          description: taskToAdd.description,
        );
        setState(() {
          _selectedDate = pickedDate;
          validDate = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _initValues['name'],
                    decoration: const InputDecoration(labelText: 'name'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      taskToAdd = Task(
                        houseId: taskToAdd.houseId, //change to logged houseID
                        id: taskToAdd.id,
                        name: value!,
                        dueDate: taskToAdd.dueDate,
                        points: taskToAdd.points,
                        description: taskToAdd.description,
                      );
                    },
                  ),
                  TextFormField(
                    focusNode: _descriptionFocusNode,
                    initialValue: _initValues['description (optional)'],
                    decoration: const InputDecoration(
                        labelText: 'description (optional)'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_pointsFocusNode);
                    },
                    onSaved: (value) {
                      if (value == null) return;
                      taskToAdd = Task(
                        houseId: taskToAdd.houseId, //change to logged houseID
                        id: taskToAdd.id,
                        name: taskToAdd.name,
                        dueDate: taskToAdd.dueDate,
                        points: taskToAdd.points,
                        description: value,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['points'],
                    decoration: const InputDecoration(labelText: 'Points'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _pointsFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter points.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.parse(value) <= 0 ||
                          double.parse(value) > 100) {
                        return 'Please enter a number between 1-100.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      taskToAdd = Task(
                        houseId: taskToAdd.houseId, //change to logged houseID
                        id: taskToAdd.id,
                        name: taskToAdd.name,
                        dueDate: taskToAdd.dueDate,
                        points: int.parse(value!),
                        description: taskToAdd.description,
                      );
                    },
                  ),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? validDate
                                    ? 'Choose date'
                                    : 'Please choose a valid date'
                                : 'Picked Date: ${DateFormat.yMd().add_jm().format(_selectedDate!)}',
                            style: TextStyle(
                                color: validDate ? Colors.black : Colors.red),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            shadowColor: Colors.black,
                          ),
                          child: const Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _presentDatePicker,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
    );
  }
}
