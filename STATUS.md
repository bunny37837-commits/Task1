# STATUS.md — Project Progress Tracker

## Current State

Milestone: V1

Phase: Review fixes completed

Last Updated: 2026-03-04

## Overall Progress

- V1: ✅ Complete

- V2: ⬜ Not Started

- V3: ⬜ Not Started

## Latest Update

### What Was Done

- Fixed repository persistence bug by moving task reads/writes from in-memory list to Isar transactions.
- Added WorkManager reminder registration/cancellation from task create/done/snooze flows.
- Implemented functional overlay Snooze action that updates task time by +10 minutes and reschedules notification + worker.
- Initialized notifications in overlay isolate so overlay actions can schedule/cancel reminders safely.

### Verification Result

- Build: ⚠️ Not executed locally (`flutter` SDK unavailable in environment)
- Tests: ⚠️ Not executed locally (`flutter` SDK unavailable in environment)
- Output: Code updated and ready for CI/device validation

### Next Step

Run CI + on-device reminder flow validation for create → fire overlay → snooze/done actions.

## History Log

| # | Milestone | What Done | Build | Date |

|---|-----------|-----------|-------|------|

| 1 | V1 | Complete Flutter implementation | ⏳ CI | 2026-03-03 |
| 2 | V1 | Codex review fixes for persistence/worker/snooze | ⚠️ Local SDK Missing | 2026-03-04 |

## Active Assumptions

ASSUMPTION: Isar default instance name is shared between main isolate and overlay isolate.
Reason:     Overlay actions need access to the same task records to update/snooze reminders.
Impact:     Overlay Done/Snooze operations target the same persisted task IDs created in-app.
Reversible: yes

ASSUMPTION: Scheduling WorkManager one-off task per reminder time is sufficient for runtime overlay triggering.
Reason:     Existing callback dispatcher only executes when explicit jobs are registered.
Impact:     Overlay path is activated for created/snoozed reminders.
Reversible: yes

## Known Issues

| # | Issue | Severity |

|---|-------|----------|

| 1 | Flutter SDK unavailable in Codex env | High — CI handles it |
