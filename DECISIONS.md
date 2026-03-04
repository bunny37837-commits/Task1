## [DEC-001] Architecture Pattern

Date: 2026-03-03

Status: Decided

Decision: Flutter + Riverpod state management with feature-first folders and service layer separation.

Reason: Keeps UI declarative while isolating scheduling/overlay behavior from widgets.

Impact: Controllers own state transitions, widgets remain presentation focused.

## [DEC-002] Database / Storage

Date: 2026-03-03

Status: Decided

Decision: Isar local database for persistent task storage.

Reason: Offline storage, fast, Flutter-native.

Impact: Task model structured for Isar annotations.

## [DEC-003] Key Libraries

Date: 2026-03-03

Status: Decided

Decision: Riverpod, Isar, flutter_local_notifications, flutter_overlay_window, workmanager, permission_handler.

Reason: Aligns with SPEC requirements and Android reminder feature set.

## [DEC-004] Network Access

Date: 2026-03-03

Status: Not Required

Decision: Network OFF.

Reason: App is 100% offline, no backend, no cloud sync.

## [DEC-005] Security

Date: 2026-03-03

Status: Decided

Decision: No INTERNET permission. Local storage only.

Reason: Offline requirement, reduced attack surface.

Impact: AndroidManifest requests only notification/alarm/overlay permissions.
## [DEC-006] Reminder Trigger Reliability

Date: 2026-03-04

Status: Decided

Decision: Persist tasks in Isar and register a dedicated WorkManager one-off job per reminder task ID.

Reason: PR review identified that in-memory tasks and missing worker registration caused reminder data loss and dead overlay execution path.

Impact: Reminder creation/snooze/done now keeps storage and background execution in sync.
