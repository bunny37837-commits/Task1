
# PLANS.md — Project Roadmap

## Status
- [x] In Progress — Current: V1

## V1 — Core Working Feature

### Goal
Offline Android Flutter app with task reminders and floating overlay.

### Acceptance Criteria
- [x] Android-only Flutter app with package com.taskremind.pro
- [x] Task create/edit/delete
- [x] Daily notification scheduling
- [x] Overlay UI with Done/Snooze/Dismiss + 12s auto-dismiss
- [x] Settings screen with global toggle, permissions, theme

### Tasks
- [x] Flutter project structure and dependencies
- [x] Domain model + repository
- [x] Task UI flow and controllers
- [x] Notification, overlay, workmanager services
- [x] Android manifest without INTERNET permission
- [x] CI workflow

## V2 — Complete Feature Set

### Goal
Persistent Isar storage and permission onboarding UX.

### Acceptance Criteria
- [ ] Isar persistence active
- [ ] First-launch permission flow guided
- [ ] Background workers functional

## V3 — Production Ready

### Goal
Harden reliability and release-readiness.

### Acceptance Criteria
- [ ] Build passes all checks
- [ ] No critical issues
- [ ] Docs complete

## Risks
| Risk | Mitigation |
|------|------------|
| Overlay behavior differs by OEM | Permissions guide + fallback checks |
| Exact alarm Android 12+ restrictions | Request exact alarm + reschedule after boot |

## Milestone History
| Milestone | Completed On |
|-----------|-------------|
| V1 commit | 2026-03-03 |
