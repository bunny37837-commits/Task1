# PLANS.md — Project Roadmap

## Status
- [ ] Not Started
- [x] In Progress — Current: V1
- [ ] Complete

## V1 — Core Working Feature

### Goal
Deliver an offline Android Flutter app that supports creating reminder tasks, scheduling notifications, and surfacing full-screen overlay actions.

### Acceptance Criteria
- [x] Android-only Flutter app scaffolded with package `com.taskremind.pro`.
- [x] Task create/list interactions implemented.
- [x] Notification scheduling wired for one-time and daily reminders.
- [x] Overlay UI with Done / Snooze / Dismiss + 12-second auto-dismiss.
- [x] Settings screen for global toggle, overlay permission, battery optimization guide, theme mode, and version info.

### Tasks
- [x] Create Flutter project structure and dependency manifest.
- [x] Implement domain model + repository abstraction.
- [x] Implement task UI flow and controller logic.
- [x] Implement notification, overlay, and workmanager services.
- [x] Configure Android manifest permissions without INTERNET permission.
- [x] Add CI workflow.
- [x] Update project docs and status files.

### Estimated Scope
Single V1 delivery in one commit with runnable structure and Android configuration.

## V2 — Complete Feature Set

### Goal
Replace in-memory repository with persistent Isar-backed storage and complete permission onboarding UX.

### Acceptance Criteria
- [ ] Isar persistence and migrations active.
- [ ] First-launch permission flow is fully guided and stateful.
- [ ] Background workers execute task fetch and overlay action handling from storage.

### Tasks
- [ ] Integrate generated Isar schemas and adapters.
- [ ] Build onboarding flow screens.
- [ ] Add integration tests for reminder lifecycle.

## V3 — Production Ready

### Goal
Harden reliability and release-readiness.

### Acceptance Criteria
- [ ] Build passes all checks
- [ ] No known critical issues
- [ ] Docs complete

### Tasks
- [ ] Final QA pass on physical Android devices.
- [ ] Final verification loop.
- [ ] STATUS.md marked complete.

## Risks & Blockers
| Risk | Impact | Mitigation |
|------|--------|------------|
| Flutter SDK unavailable in execution environment | High | Provide complete source + CI workflow; document local commands for verification |

## Milestone History
| Milestone | Completed On | Verified By |
|-----------|-------------|-------------|
| V1 implementation commit | 2026-03-03 | Static validation + file review |
