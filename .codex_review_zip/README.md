# ⚔️ Level Up — Daily Life RPG

A cozy, pixel-game-inspired Flutter app that helps you track daily survival and productivity tasks. Built for people who sometimes struggle with motivation, depression, or forgetfulness. Every step counts.

---

## 📁 Project Structure

```
lib/
├── main.dart                        ← App entry point, theme, routes
├── models/
│   └── task_model.dart              ← Task data class + JSON conversion
├── services/
│   └── storage_service.dart         ← Local storage (shared_preferences)
├── utils/
│   └── xp_utils.dart                ← XP math, leveling, messages
├── screens/
│   ├── splash_screen.dart           ← Launch screen
│   ├── home_screen.dart             ← Daily checklist (main screen)
│   ├── rewards_screen.dart          ← Collectible rewards gallery
│   └── settings_screen.dart        ← App settings
└── widgets/
    ├── task_tile.dart               ← Individual task row
    ├── level_bar.dart               ← XP progress bar
    └── streak_badge_and_add_sheet.dart ← Streak badge + add task sheet
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x — install from [flutter.dev](https://flutter.dev/docs/get-started/install)
- Xcode (for iOS) or Android Studio (for Android)

### Setup

```bash
# 1. Clone or download this project
cd level_up

# 2. Install dependencies
flutter pub get

# 3. Run on a simulator or device
flutter run

# 4. Build for release (when ready)
flutter build ios      # for App Store
flutter build apk      # for Google Play
```

---

## 🎮 How It Works

| Feature | How It's Built |
|---|---|
| Tasks | `List<Task>` stored as JSON in `shared_preferences` |
| XP | Integer stored locally, earned by completing tasks |
| Level | Calculated on the fly from XP using `XpUtils.getLevel()` |
| Streak | Compared to yesterday's date on each app launch |
| Rewards | Unlocked automatically when XP reaches threshold |
| Custom tasks | Added via bottom sheet, stored alongside defaults |

---

## 📈 XP & Level System

| Level | XP Required | Name |
|---|---|---|
| 1 | 0 | Just Getting Started |
| 2 | 50 | Finding Your Footing |
| 3 | 120 | Building Habits |
| 4 | 220 | Gaining Momentum |
| 5 | 350 | On a Roll |
| 6 | 520 | Level Headed |
| 7 | 740 | Daily Champion |
| 8 | 1020 | Consistency King |
| 9 | 1380 | Habit Master |
| 10 | 1850 | Life Level Legend |

---

## 🎨 Customizing the App

### Change the color theme
Edit `main.dart` → `ThemeData` → `colorScheme`

### Add new default tasks
Edit `models/task_model.dart` → `defaultTasksData` list

### Adjust XP per task
Edit `models/task_model.dart` → each task's `xpValue`

### Add pixel art assets
1. Add PNG files to `assets/sprites/`
2. Uncomment the `assets:` section in `pubspec.yaml`
3. Replace emoji Text widgets with `Image.asset('assets/sprites/x.png')`

### Add Google Fonts
```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.1.0
```
```dart
// main.dart
import 'package:google_fonts/google_fonts.dart';
fontFamily: GoogleFonts.nunito().fontFamily,
```

---

## 💙 Design Principles

- **Never shame** the user. Use encouraging language only.
- **Every step counts** — completing 1 task is celebrated just as much as completing all of them.
- **Simple over complete** — don't overwhelm. The MVP does less, but does it warmly.
- **Local first** — no account, no cloud, no data leaving the device.

---

## 🗺️ Roadmap (Post-MVP)

- [ ] Actual pixel art sprites for rewards
- [ ] Daily notifications (gentle, opt-in)
- [ ] Weekly summary view
- [ ] Task categories / grouping
- [ ] Pastel theme selector
- [ ] iCloud / Google Drive backup (opt-in)
- [ ] Mood check-in feature

---

*"Progress, not perfection. Every small step you take matters."*
