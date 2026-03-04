import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskremind_pro/domain/models/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

class TaskRepository {
  final List<Task> _tasks = <Task>[];

  Future<List<Task>> list() async {
    _tasks.sort((a, b) => a.remindAt.compareTo(b.remindAt));
    return List<Task>.unmodifiable(_tasks);
  }

  Future<Task> save({
    required String title,
    String? description,
    required DateTime remindAt,
    required RepeatType repeatType,
  }) async {
    final task = Task()
      ..id = Random().nextInt(1 << 31)
      ..title = title
      ..description = description
      ..remindAt = remindAt
      ..repeatType = repeatType
      ..isEnabled = true
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    _tasks.add(task);
    return task;
  }

  Future<void> markDone(int id) async {
    _tasks.removeWhere((t) => t.id == id);
  }

  Future<void> snooze10Min(int id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.remindAt = task.remindAt.add(const Duration(minutes: 10));
    task.updatedAt = DateTime.now();
  }
}
