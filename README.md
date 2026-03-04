# TaskRemind Pro

Offline Android reminder app built with Flutter.

## Features
- Create, edit, delete tasks
- Set daily reminder time per task
- Global reminders on/off toggle
- Floating overlay with Done / Snooze 10min / Dismiss
- 12-second auto-dismiss countdown
- Settings: dark mode, permissions guide, battery optimization

## Tech Stack
- Flutter + Riverpod
- Isar (local database)
- flutter_local_notifications
- flutter_overlay_window
- WorkManager

## Commands
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --release --no-tree-shake-icons
