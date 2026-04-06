# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Level Up** — a Flutter app that gamifies daily task completion with XP-based leveling, plant growth visualization, and reward unlocking. Version 2.1.0 includes Supabase auth and cloud profile syncing.

## Commands

```bash
# Run the app
flutter run

# Analyze / lint
flutter analyze

# Get dependencies
flutter pub get

# Clean and reset
flutter clean && flutter pub get

# Build
flutter build apk          # Android
flutter build ipa          # iOS
flutter build web          # Web

# Run with custom Supabase credentials
flutter run --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<key>
```

No test suite is currently configured.

## Architecture

MVP pattern using `ChangeNotifier` presenters — no Provider, Bloc, or Riverpod.

```
Screens (StatefulWidget)
  └─ Presenters (ChangeNotifier — state + business logic)
       └─ Services (StorageService, SupabaseService, AffirmationNotificationService)
            └─ SharedPreferences (local) + Supabase (remote auth/profiles)
```

Screens hold presenter instances, attach listeners in `initState()`, and call presenter methods on user interaction. Presenters call `notifyListeners()` to trigger rebuilds.

## Key Subsystems

### Data Persistence (StorageService)
All SharedPreferences keys are **user-scoped** as `{baseKey}_{userId}`. On first login, legacy non-scoped data is automatically migrated and a `_legacyDataClaimedByUserKey` flag prevents re-claiming by other accounts.

### Task & XP Logic (HomePresenter)
- Daily tasks reset `isCompleted → false` every new day in `loadData()`
- Completing ≥1 task in each of the 3 categories (Survival, Wellness, Growth) on the same day awards a +15 bonus XP — tracked via a date key to prevent duplicates
- Streak increments if the previous day had ≥1 completed task; resets to 0 if the gap is >1 day
- Task celebration feedback lasts ~1.4s, controlled by `_feedbackToken` to prevent stale updates

### XP & Leveling (XpUtils)
Levels 1–10 with hardcoded XP thresholds (0 → 1850 XP). GrowthStage (plant) advances at 0 / 30 / 80 / 150 / 300 XP.

### Rewards (RewardsPresenter)
10 hardcoded `RewardItem` constants with XP thresholds. `updateTotalXp()` detects newly unlocked rewards and persists them to SharedPreferences; "newly unlocked" state drives unlock animations.

### Authentication (SupabaseService + AuthPresenter)
- Supabase credentials are baked in as `String.fromEnvironment` compile-time constants with hardcoded defaults — no `.env` file needed
- Signup flow requires email confirmation **disabled** in the Supabase Auth dashboard
- A PostgreSQL trigger (`handle_new_user`) auto-creates a row in `public.profiles` on signup (see `supabase/migrations/20260330_create_profiles_auth_sync.sql`)
- Only `display_name` and `email` are stored remotely; all task/XP/streak data is local

### Notifications (AffirmationNotificationService)
Local notifications only (not cloud push). Scheduled daily at a user-configurable time (default 9:00 AM) via `flutter_local_notifications`.

## Models

- `Task` / `TaskCategory` — tasks have a `category` field; legacy tasks without it infer category from their ID (e.g. `eat_meal → survival`)
- Custom task IDs use format `custom_{millisecondsSinceEpoch}`
- Default tasks and rewards are **hardcoded constants** — only custom tasks are persisted

## Theme

Material 3 theme defined in `lib/theme/level_up_theme.dart`. Palette: cream `#FAF7F0`, sage `#7B9B8F`, peach `#E8AE9A`, gold `#D4A574`. Font: Nunito.
