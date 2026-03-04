import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskremind_pro/domain/models/task.dart';
import 'package:taskremind_pro/services/notifications_service.dart';
import 'package:taskremind_pro/services/workmanager_service.dart';

class OverlayService {
  static Future<bool> isGranted() => FlutterOverlayWindow.isPermissionGranted();

  static Future<void> openSettings() async {
    await FlutterOverlayWindow.requestPermission();
  }

  static Future<void> showOverlay({required int taskId}) async {
    await FlutterOverlayWindow.showOverlay(
      enableDrag: false,
      overlayTitle: 'Task reminder',
      overlayContent: 'Task ID: $taskId',
      flag: OverlayFlag.focusPointer,
      visibility: NotificationVisibility.visibilityPublic,
      height: 380,
      width: WindowSize.matchParent,
    );
    await FlutterOverlayWindow.shareData(taskId.toString());
  }
}

class _OverlayTaskActions {
  static Future<Isar> _openIsar() async {
    final existing = Isar.getInstance();
    if (existing != null) {
      return existing;
    }

    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([TaskSchema], directory: dir.path);
  }

  static Future<void> done(int taskId) async {
    await NotificationsService.instance.cancelTask(taskId);
    await WorkmanagerService.cancelReminder(taskId);

    final isar = await _openIsar();
    await isar.writeTxn(() async {
      await isar.collection<Task>().delete(taskId);
    });
  }

  static Future<void> snooze10Minutes(int taskId) async {
    final isar = await _openIsar();
    final task = await isar.collection<Task>().get(taskId);
    if (task == null) {
      return;
    }

    task
      ..remindAt = DateTime.now().add(const Duration(minutes: 10))
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.collection<Task>().put(task);
    });

    await NotificationsService.instance.scheduleTask(task);
    await WorkmanagerService.scheduleReminder(task);
  }
}

class OverlayApp extends StatefulWidget {
  const OverlayApp({super.key});

  @override
  State<OverlayApp> createState() => _OverlayAppState();
}

class _OverlayAppState extends State<OverlayApp> {
  static const _ttl = Duration(seconds: 12);
  late final Stopwatch _stopwatch = Stopwatch()..start();
  Timer? _timer;
  StreamSubscription<dynamic>? _dataSub;
  int? _taskId;

  @override
  void initState() {
    super.initState();
    _dataSub = FlutterOverlayWindow.overlayListener.listen((dynamic data) {
      final parsed = int.tryParse(data?.toString() ?? '');
      if (parsed != null && mounted) {
        setState(() => _taskId = parsed);
      }
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted) return;
      if (_stopwatch.elapsed >= _ttl) {
        FlutterOverlayWindow.closeOverlay();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _dataSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onDonePressed() async {
    final taskId = _taskId;
    if (taskId != null) {
      await _OverlayTaskActions.done(taskId);
    }
    await FlutterOverlayWindow.closeOverlay();
  }

  Future<void> _onSnoozePressed() async {
    final taskId = _taskId;
    if (taskId != null) {
      await _OverlayTaskActions.snooze10Minutes(taskId);
    }
    await FlutterOverlayWindow.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - (_stopwatch.elapsedMilliseconds / _ttl.inMilliseconds);
    return Material(
      color: Colors.black.withOpacity(0.82),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Reminder', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress.clamp(0, 1)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: _onDonePressed,
                        child: const Text('Done'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                        onPressed: _onSnoozePressed,
                        child: const Text('Snooze 10m'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.grey),
                        onPressed: FlutterOverlayWindow.closeOverlay,
                        child: const Text('Dismiss'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
