# Dofalarm

Dragoturkey Alarm is a lightweight Flutter prototype mobile app for managing gauges (serenity, endurance, experience, etc.) and persistent local timers with scheduled notifications. Built as a portfolio project, it shows end-to-end mobile skills: responsive UI, service separation, persistence and native notification integration.

## Key highlights

- Modern, responsive Flutter UI with SVG and image assets.
- Clear modular architecture: reusable widgets, separated views and services.
- Local, persistent timers (saved to SharedPreferences) and scheduled local notifications.
- UX polish: numeric input handling, centered inputs and accessible interactions.
- Structured for maintainability and testability — ready for extension and CI.

## Features

- Create and manage persistent local timers with title, timestamp and duration.
- Real-time list of active timers with cancel and cleanup actions.
- Schedule device notifications and show immediate in-app alerts on expiry.
- Multiple themed views (Caresseur, Baffeur, etc.) using shared components.
- Asset support (SVG, PNG, JPEG) and custom fonts.

## Demo / Screenshots

Replace with screenshots or a short demo video showing timer creation, active timers list and notification behavior.

## Tech stack

- Flutter & Dart
- `flutter_svg` for vector assets
- `flutter_local_notifications` for scheduled notifications
- `shared_preferences` for simple local persistence
- Lightweight state approach / Provider or `ChangeNotifier` patterns

## Prerequisites

- Flutter (stable) — recommended recent stable (3.x or newer)
- Android SDK and an emulator or device (Windows development recommended)
- Useful commands: `flutter doctor`, `flutter pub get`, `flutter run`

## Quick start

1. Clone the repository:
   git clone <your-repo-url>

2. Install dependencies:
   cd dragoturkey_alarm
   flutter pub get

3. Run the app:
   flutter run

4. Main routes: `/home`, `/timers`, and themed views under `lib/views/stats/`.

## Developer utilities

- Timers are persisted as JSON in SharedPreferences. Use logs or emulator device file explorer for debugging stored JSON.
- Helpful commands:
    - `flutter run --verbose` for detailed runtime logs
    - `flutter analyze` for static checks

## Important files and structure

- `lib/main.dart` — app entry and route registration.
- `lib/services/timer_service.dart` — timer lifecycle, persistence, orchestration.
- `lib/services/notification_service.dart` — wrapper around `flutter_local_notifications` (init, schedule, cancel).
- `lib/services/helper.dart` and `lib/services/experience_table.dart` — helper utilities and domain data.
- `lib/views/routes/home_view.dart` and `lib/views/routes/timers_view.dart` — primary UI screens.
- `lib/widgets/custom_app_bar.dart` — reusable AppBar.
- `assets/` — fonts, icons and images declared in `pubspec.yaml`.
- `android/` — native Android project and configuration for notifications.

## What this project demonstrates

- Practical Flutter development for polished mobile UI and UX.
- Separation of UI and business logic for maintainability and testability.
- Native integration experience with scheduled notifications and platform intent handling.
- Persistent state restoration so timers survive app restarts.
- Attention to usability details and accessibility.

## Next steps / suggestions

- Add unit and widget tests around `TimerService` and `NotificationService`.
- Implement platform permission flows and background execution improvements (Android exact alarms handling).
- Improve notification channels and add custom sounds per timer type.
- Add CI pipelines and end-to-end tests.

## Contact

Erwan Rossignol — erwan@hotmail.ch  
Repository: <https://github.com/E-Rossignol/dragoturkey_alarm.git>