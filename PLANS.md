# PLANS.md — Project Roadmap

## Status
[x] In Progress — Current: V1

## V1 — Core Working Feature

### Goal
Deliver a functional offline Android reminder app with task CRUD, daily reminders, and full-screen floating reminder UI.

### Acceptance Criteria
- [x] Add/edit/delete task entries locally.
- [x] User can pick daily time for each task.
- [x] Reminder broadcast launches overlay UI with task title and actions.
- [x] Done / Snooze 10m / Dismiss actions are wired.
- [x] Global reminder toggle and settings screen exist.

### Tasks
- [x] Create Android app module and baseline resources.
- [x] Implement Room storage for tasks.
- [x] Implement reminder scheduling via AlarmManager.
- [x] Implement overlay reminder activity.
- [x] Implement settings (global toggle, dark mode, permissions guide).

### Estimated Scope
Single-module Android app, Kotlin + XML UI, offline persistence and local alarms.

## V2 — Complete Feature Set

### Goal
Improve UX and resilience for production-like usage.

### Acceptance Criteria
- [ ] Better task filtering/sorting and status indicators.
- [ ] Robust background/boot behavior across OEM devices.
- [ ] Validation and edge-case handling polish.

### Tasks
- [ ] Add stronger validation and UX refinements.
- [ ] Add instrumentation/unit tests for key flows.
- [ ] Expand permission guidance with deep links.

## V3 — Production Ready

### Goal
Stabilize for release and documentation completeness.

### Acceptance Criteria
- [ ] Build passes all checks.
- [ ] No known critical issues.
- [ ] Docs complete.

### Tasks
- [ ] Hardening and bug fixes.
- [ ] Final verification loop.
- [ ] STATUS.md marked complete.

## Risks & Blockers
| Risk | Impact | Mitigation |
|------|--------|------------|
| Overlay behavior differs by OEM/Android version | High | Provide permissions guide and fallback checks for overlay permission |
| Exact alarm restrictions on newer Android builds | High | Request exact alarm capability and re-schedule after boot/package replace |

## Milestone History
| Milestone | Completed On | Verified By |
|-----------|-------------|-------------|
| V1 | 2026-03-03 | Static code review + attempted Gradle build |
