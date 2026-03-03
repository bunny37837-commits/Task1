# Project Skill — TaskRemind Pro

## Build commands
- `JAVA_HOME=/root/.local/share/mise/installs/java/21.0.2 gradle :app:assembleDebug`
- `JAVA_HOME=/root/.local/share/mise/installs/java/21.0.2 gradle :app:testDebugUnitTest`

## Repo workflow
1. Read `SPEC.md`, `PLANS.md`, and `DECISIONS.md` before implementing.
2. Implement one milestone at a time.
3. Update `STATUS.md` after each milestone.
4. Commit one logical change at a time using milestone prefix.

## Verification steps
1. Build debug APK (`:app:assembleDebug`).
2. Run unit tests (`:app:testDebugUnitTest`).
3. Manually validate app flow on Android device/emulator:
   - create/edit/delete task
   - reminder alarm trigger
   - overlay actions (Done/Snooze/Dismiss)

## Project conventions
- Kotlin + AndroidX + Room.
- Offline-only architecture.
- AlarmManager for exact reminders.
- Store settings in SharedPreferences.
