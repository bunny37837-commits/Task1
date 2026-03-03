import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

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

  @override
  void initState() {
    super.initState();
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
    _timer?.cancel();
    super.dispose();
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
                        onPressed: FlutterOverlayWindow.closeOverlay,
                        child: const Text('Done'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                        onPressed: FlutterOverlayWindow.closeOverlay,
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
