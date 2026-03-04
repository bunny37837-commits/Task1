import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task.dart';

final globalRemindersProvider = StateProvider<bool>((ref) => true);
final darkModeProvider = StateProvider<bool>((ref) => false);

final taskListProvider = StateNotifierProvider<TaskController, List<Task>>(
  (ref) => TaskController(),
);

class TaskController extends StateNotifier<List<Task>> {
  TaskController() : super(const []);

  void addTask(String title, int hour, int minute) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    state = [...state, Task(id: id, title: title, hour: hour, minute: minute)];
  }

  void updateTask(Task updated) {
    state = [
      for (final task in state)
        if (task.id == updated.id) updated else task,
    ];
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}
