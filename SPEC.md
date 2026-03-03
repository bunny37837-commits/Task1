SPEC.md — Project Specification
✍️ Human fills this. Codex reads this as source of truth.
App Name
TaskRemind Pro

Tagline
Truecaller-style floating reminder app for Android

Platform
Android (Flutter 3.24+, Kotlin backend)

Goal
Production-ready Flutter Android app — daily task reminders with Truecaller-style floating overlay popup over any screen, even when app is closed. Full Clean Architecture.

Tech Stack (EXACT — do not change versions)
Concern	Package + Version
State management	flutter_riverpod: ^2.5.1 + riverpod_annotation: ^2.3.5
Database	isar: ^3.1.8 + isar_flutter_libs: ^3.1.8
Notifications	flutter_local_notifications: ^17.2.3 + timezone: ^0.9.4
Floating overlay	flutter_overlay_window: ^3.0.0
Background work	workmanager: ^0.5.2
Permissions	permission_handler: ^11.3.1
Theming	Material 3, seed color 0xFF6750A4
Architecture
lib/ ├── main.dart ├── bootstrap.dart ├── core/ │ ├── notifications/ │ │ ├── notification_service.dart │ │ └── overlay_service.dart │ ├── background/ │ │ └── workmanager_service.dart │ └── theme/app_theme.dart ├── domain/ │ └── models/task.dart ├── data/ │ └── repositories/task_repository_impl.dart └── presentation/ ├── app.dart ├── home/ │ ├── home_screen.dart │ ├── home_provider.dart │ └── widgets/task_tile.dart ├── add_edit_task/ │ ├── add_edit_task_screen.dart │ └── add_edit_task_provider.dart ├── settings/ │ ├── settings_screen.dart │ └── settings_provider.dart └── overlay/ └── overlay_entry_point.dart
Data Models
Task (Isar Collection)
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
Settings (Isar Collection)
globalEnabled: bool
isDarkMode: bool
Features
Home Screen
AppBar: global ON/OFF Switch + Settings icon
AnimatedList of task tiles
Each tile: title, time, per-task switch, tap=edit, long-press=delete
FAB to add task
Empty state widget when no tasks
Add/Edit Task Screen
Title field (required, max 60 chars)
Description field (optional)
Material 3 time picker
Save → schedules notification + saves to Isar
Floating Overlay (Truecaller Style)
Separate vm:entry-point overlayMain()
Rounded card widget
Shows: task title + time + bell emoji
3 buttons:
Done (green) — dismiss overlay
Snooze 10min (orange) — reschedule +10 minutes
Dismiss (grey) — close
LinearProgressIndicator countdown
Auto-dismiss after 12 seconds
Draggable, top position, full width, 220px height
Notification Service
Channel: reminder_channel
Importance: max
Vibration: [0, 500, 200, 500]
fullScreenIntent: true
scheduleDaily(Task) via zonedSchedule
DateTimeComponents.time for daily repeat
cancel(int id)
cancelAll()
rescheduleAll(List)
Background (WorkManager)
Triggered from onDidReceiveNotificationResponse
callbackDispatcher opens Isar
Fetches task by ID
Calls OverlayService.showOverlay()
Both callbackDispatcher and overlayMain must have
@pragma('vm:entry-point')
Settings Screen
Global toggle
Overlay permission status + open settings button
Battery optimization exempt button
Dark/Light mode toggle
App version display
Permissions Flow (First Launch)
POST_NOTIFICATIONS (Android 13+) with rationale dialog
SCHEDULE_EXACT_ALARM (Android 12+)
Draw over other apps guide
Battery optimization disable guide
AndroidManifest Permissions (ALL REQUIRED)
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
Also register:
FlutterOverlayWindowPlugin service
WorkManager provider (manual init)
Boot receiver
FullScreenIntentActivity
UI Requirements
Material 3, useMaterial3: true
Seed color: Color(0xFF6750A4)
System dark/light + manual override in settings
Task tiles: Card + InkWell
Colored left border per tile (from title hashCode)
Smooth page transitions
Code Quality Rules
All providers use @riverpod annotation + code gen
No business logic in widgets
AsyncValue for all async providers
const constructors everywhere possible
Full null safety
Files to Generate (IN THIS ORDER — no placeholders, no TODOs)
pubspec.yaml
android/app/src/main/AndroidManifest.xml
lib/domain/models/task.dart
lib/core/notifications/notification_service.dart
lib/core/notifications/overlay_service.dart
lib/core/background/workmanager_service.dart
lib/data/repositories/task_repository_impl.dart
lib/bootstrap.dart
lib/main.dart
lib/presentation/overlay/overlay_entry_point.dart
lib/presentation/home/home_provider.dart
lib/presentation/home/home_screen.dart
lib/presentation/home/widgets/task_tile.dart
lib/presentation/add_edit_task/add_edit_task_provider.dart
lib/presentation/add_edit_task/add_edit_task_screen.dart
lib/presentation/settings/settings_provider.dart
lib/presentation/settings/settings_screen.dart
lib/core/theme/app_theme.dart
lib/presentation/app.dart
Build Commands (After Code Generation)
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --release
Done Means
All 19 files generated, no TODOs
flutter pub get passes
build_runner generates Isar + Riverpod files
App installs on real Android device
Task creation works
Notification fires at scheduled time
Floating overlay appears over any screen
Snooze and Done buttons work
Out of Scope (V1)
iOS support
Cloud sync
Widget on home screen
Multiple snooze options
