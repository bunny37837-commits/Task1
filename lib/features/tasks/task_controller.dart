import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskremind_pro/domain/models/task.dart';
import 'package:taskremind_pro/features/tasks/task_repository.dart';
import 'package:taskremind_pro/services/notifications_service.dart';
import 'package:taskremind_pro/services/workmanager_service.dart';

final taskControllerProvider = AsyncNotifierProvider<TaskController, List<Task>>(
  TaskController.new,
);

class TaskController extends AsyncNotifier<List<Task>> {
  late final TaskRepository _repository = ref.read(taskRepositoryProvider);

  @override
  Future<List<Task>> build() => _repository.list();

  Future<void> createTask({
    required String title,
    String? description,
    required DateTime remindAt,
    required RepeatType repeatType,
  }) async {
    final task = await _repository.save(
      title: title,
      description: description,
      remindAt: remindAt,
      repeatType: repeatType,
    );
    await NotificationsService.instance.scheduleTask(task);
    await WorkmanagerService.scheduleReminder(task);
    state = AsyncData(await _repository.list());
  }

  Future<void> done(Task task) async {
    await _repository.markDone(task.id);
    await NotificationsService.instance.cancelTask(task.id);
    await WorkmanagerService.cancelReminder(task.id);
    state = AsyncData(await _repository.list());
  }

  Future<void> snooze(Task task) async {
    final updatedTask = await _repository.snooze10Min(task.id);
    if (updatedTask == null) {
      state = AsyncData(await _repository.list());
      return;
    }
    await NotificationsService.instance.scheduleTask(updatedTask);
    await WorkmanagerService.scheduleReminder(updatedTask);
    state = AsyncData(await _repository.list());
  }
}
