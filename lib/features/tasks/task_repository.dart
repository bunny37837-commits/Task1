import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:taskremind_pro/domain/models/task.dart';
import 'package:taskremind_pro/main.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final isar = ref.read(isarProvider);
  return TaskRepository(isar);
});

class TaskRepository {
  TaskRepository(this._isar);

  final Isar _isar;

  Future<List<Task>> list() async {
    final tasks = await _isar.collection<Task>().where().sortByRemindAt().findAll();
    return List<Task>.unmodifiable(tasks);
  }

  Future<Task> save({
    required String title,
    String? description,
    required DateTime remindAt,
    required RepeatType repeatType,
  }) async {
    final task = Task()
      ..title = title
      ..description = description
      ..remindAt = remindAt
      ..repeatType = repeatType
      ..isEnabled = true
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.collection<Task>().put(task);
    });
    return task;
  }

  Future<void> markDone(int id) async {
    await _isar.writeTxn(() async {
      await _isar.collection<Task>().delete(id);
    });
  }

  Future<Task?> getById(int id) => _isar.collection<Task>().get(id);

  Future<Task?> snooze10Min(int id) async {
    final task = await _isar.collection<Task>().get(id);
    if (task == null) {
      return null;
    }

    task
      ..remindAt = DateTime.now().add(const Duration(minutes: 10))
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.collection<Task>().put(task);
    });

    return task;
  }
}
