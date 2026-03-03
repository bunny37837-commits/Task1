# SPEC.md — Project Specification

## App Name
TaskRemind Pro

## Platform
Android only — Flutter 3.24+

## Package Name
com.taskremind.pro

## Constraints
- Android only, no iOS
- 100% offline — no internet
- No cloud sync, no Firebase, no backend
- No INTERNET permission

## Verified Package Versions (pub.dev — March 2026)

dependencies:
  flutter_riverpod: ^3.2.1
  riverpod_annotation: ^4.0.2
  isar: 3.1.0+1
  isar_flutter_libs: 3.1.0+1
  flutter_local_notifications: ^20.1.0
  timezone: ^0.9.4
  flutter_overlay_window: ^0.5.0
  workmanager: ^0.9.0+3
  permission_handler: ^12.0.1
  package_info_plus: ^8.0.2

dev_dependencies:
  flutter_lints: ^4.0.0
  build_runner: ^2.4.6
  riverpod_generator: ^4.0.3
  isar_generator: 3.1.0+1

## Data Models

### Task (Isar Collection) — lib/domain/models/task.dart
@collection
class Task {
  Id id = Isar.autoIncrement;
  late String title;
  String? description;
  late int hour;
  late int minute;
  bool isEnabled = true;
  bool isDaily = true;
  DateTime? lastTriggered;
}

### AppSettings (Isar Collection) — lib/domain/models/app_settings.dart
@collection
class AppSettings {
  Id id = 1;
  bool globalEnabled = true;
  bool isDarkMode = false;
}

## Architecture (MVVM + Riverpod)

lib/
├── main.dart
├── bootstrap.dart
├── core/
│   ├── notifications/notification_service.dart
│   ├── notifications/overlay_service.dart
│   ├── background/workmanager_service.dart
│   └── theme/app_theme.dart
├── domain/
│   └── models/
│       ├── task.dart
│       └── app_settings.dart
├── data/
│   └── repositories/task_repository_impl.dart
└── presentation/
    ├── app.dart
    ├── home/home_screen.dart
    ├── home/home_provider.dart
    ├── home/widgets/task_tile.dart
    ├── add_edit_task/add_edit_task_screen.dart
    ├── add_edit_task/add_edit_task_provider.dart
    ├── settings/settings_screen.dart
    ├── settings/settings_provider.dart
    └── overlay/overlay_entry_point.dart

## Required Android Files

android/settings.gradle
android/build.gradle
android/gradle.properties
android/app/build.gradle
android/app/src/main/AndroidManifest.xml
android/app/src/main/kotlin/com/taskremind/pro/MainActivity.kt
android/app/src/main/kotlin/com/taskremind/pro/BootReceiver.kt
android/app/src/main/res/values/styles.xml
android/app/src/main/res/values-night/styles.xml

## Android Config
minSdk: 21
targetSdk: 34
compileSdk: 34
Flutter embedding: v2

## AndroidManifest Permissions
SYSTEM_ALERT_WINDOW
FOREGROUND_SERVICE
FOREGROUND_SERVICE_SPECIAL_USE
VIBRATE
WAKE_LOCK
RECEIVE_BOOT_COMPLETED
USE_EXACT_ALARM
SCHEDULE_EXACT_ALARM
POST_NOTIFICATIONS
USE_FULL_SCREEN_INTENT

## AndroidManifest Service Block (EXACT)
<service
    android:name="flutter.overlay.window.flutter_overlay_window.OverlayService"
    android:exported="false"
    android:foregroundServiceType="specialUse">
    <property
        android:name="android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE"
        android:value="overlayWindow"/>
</service>

## Features

### Home Screen
- AppBar: global ON/OFF Switch + Settings icon
- AnimatedList of task tiles
- Each tile: title, time, per-task switch
- Tap = edit, long-press = delete
- FAB to add task
- Empty state widget

### Add/Edit Task
- Title (required, max 60 chars)
- Description (optional)
- Material 3 time picker
- Save = schedule notification + save to Isar

### Floating Overlay (Truecaller Style)
- Triggered automatically via fullScreenIntent
  (NOT via notification tap — fires on its own)
- overlayMain() separate entry point
- @pragma('vm:entry-point') on both
  overlayMain() and callbackDispatcher()
- Overlay opens Isar manually (no Riverpod)
- Done (green) / Snooze 10min (orange) / Dismiss (grey)
- LinearProgressIndicator countdown
- Auto-dismiss after 12 seconds

### Notifications
- Channel: reminder_channel, Importance.max
- Vibration: [0, 500, 200, 500]
- fullScreenIntent: true
- scheduleDaily via zonedSchedule
- DateTimeComponents.time for daily repeat

### Background
- WorkManager callbackDispatcher
- Opens Isar directly (no shared state)
- Fetches task by ID
- Calls OverlayService.showOverlay()

### Settings Screen
- Global toggle
- Overlay permission status + open settings
- Battery optimization exempt button
- Dark/Light mode toggle
- App version

### Permissions Flow (First Launch)
- POST_NOTIFICATIONS (Android 13+)
- SCHEDULE_EXACT_ALARM (Android 12+)
- Draw over other apps guide
- Battery optimization guide

## UI
- Material 3, useMaterial3: true
- Seed color: Color(0xFF6750A4)
- Dark/light system + manual override
- Task tiles: Card + InkWell
- Colored left border per tile (title hashCode)

## Code Rules
- @riverpod annotation + codegen
- No business logic in widgets
- AsyncValue for async providers
- const constructors everywhere
- Full null safety

## GitHub Actions Workflow
Flutter: 3.24.0, channel: stable
Steps:
1. flutter pub get
2. flutter pub run build_runner build --delete-conflicting-outputs
3. flutter build apk --release --no-tree-shake-icons
Artifact: build/app/outputs/flutter-apk/app-release.apk

## Done Means
- flutter pub get — zero errors
- build_runner — succeeds
- APK builds successfully
- Installs on real Android device
- Task creation works
- Notification fires at scheduled time
- Overlay appears automatically (no tap needed)
- Snooze and Done work
- Zero internet calls

## Out of Scope
- iOS
- Cloud sync
- Internet access
- Firebase
- Multiple snooze options
- Home screen widget
