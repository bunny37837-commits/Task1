# TaskRemind Pro

Offline Android task reminder app with floating full-screen reminder overlay.

## Implemented features
- Create, edit, delete tasks
- Set daily reminder time per task
- Global reminders on/off toggle
- Overlay popup with **Done / Snooze 10m / Dismiss**
- Settings: dark mode toggle + permissions guide
- Boot/package-replaced re-scheduling support

## Tech stack
- Kotlin
- AndroidX + Material
- Room (local DB)
- AlarmManager (exact reminder scheduling)

## Build
```bash
JAVA_HOME=/root/.local/share/mise/installs/java/21.0.2 gradle :app:assembleDebug
```

## Notes
This repository is fully offline-focused: no backend, no Firebase, no internet APIs.
