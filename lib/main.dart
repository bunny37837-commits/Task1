import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskremind_pro/app/task_remind_app.dart';
import 'package:taskremind_pro/domain/models/task.dart';
import 'package:taskremind_pro/services/notifications_service.dart';
import 'package:taskremind_pro/services/overlay_service.dart';
import 'package:taskremind_pro/services/workmanager_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([TaskSchema], directory: dir.path);

  await NotificationsService.instance.initialize();
  await WorkmanagerService.initialize();

  runApp(ProviderScope(
    overrides: [isarProvider.overrideWithValue(isar)],
    child: const TaskRemindApp(),
  ));
}

final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayApp());
}
