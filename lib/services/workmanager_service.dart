import 'package:flutter/widgets.dart';
import 'package:taskremind_pro/domain/models/task.dart';
import 'package:workmanager/workmanager.dart';

import 'overlay_service.dart';

class WorkmanagerService {
  static const _taskName = 'show_reminder_overlay';

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static String _uniqueName(int taskId) => 'overlay_task_$taskId';

  static Future<void> scheduleReminder(Task task) async {
    await cancelReminder(task.id);

    final now = DateTime.now();
    final initialDelay = task.remindAt.isAfter(now)
        ? task.remindAt.difference(now)
        : const Duration(seconds: 1);

    await Workmanager().registerOneOffTask(
      _uniqueName(task.id),
      _taskName,
      inputData: <String, dynamic>{'taskId': task.id},
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<void> cancelReminder(int taskId) async {
    await Workmanager().cancelByUniqueName(_uniqueName(taskId));
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final taskId = inputData?['taskId'] as int?;
    if (taskId != null) {
      await OverlayService.showOverlay(taskId: taskId);
    }
    return true;
  });
}
