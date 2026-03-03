import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import 'overlay_service.dart';

class WorkmanagerService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
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
