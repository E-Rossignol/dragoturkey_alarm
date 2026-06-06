# Dragoturkey Alarm

Dragoturkey Alarm is a Flutter prototype mobile app that manages various gauges (serenity, endurance, experience, etc.) and local timers. Built as a portfolio project, it demonstrates end-to-end mobile app skills: responsive UI, state management, local persistence, and native integrations such as scheduled notifications.

## Key Highlights

- Modern, responsive UI implemented with Flutter (adaptive layouts, SVG support, image assets).  
- Clear modular architecture: reusable widgets, view separation, and independent services (timers, notifications, persistence).  
- Local timers with persistence (SharedPreferences) and scheduled local notifications.  
- UX polish: numeric input handling (signed keyboard), centered inputs, accessible interactions and consistent visual language.  
- Code organized for maintainability and testability — suitable for extension and CI integration.

## Features

- Create and manage persistent local timers (title, creation timestamp, duration).  
- Real-time display of active timers with cancel/cleanup actions.  
- Scheduled local notifications and immediate in-app alerts when a timer expires.  
- Multiple thematic views (Caresseur, Baffeur, etc.) using shared components.  
- Assets support (SVG, JPEG/PNG) and custom fonts for branding.

## Screenshot / Demo

Replace with screenshots or a short demo video showcasing the app UI, timer creation, and notification behavior.

## Tech Stack

- Flutter & Dart  
- flutter_svg for vector assets  
- flutter_local_notifications for local notifications  
- SharedPreferences for simple local persistence  
- Provider / ChangeNotifier (or lightweight state approach) for UI <-> service sync

## Prerequisites

- Flutter (stable) — recommended: Flutter 3.x or newer  
- Android SDK (or iOS setup) and an emulator or physical device  
- Useful commands: `flutter doctor`, `flutter pub get`, `flutter run`

## Quick Start

1. Clone the repository:  
   git clone <your-repo-url>  
2. Install dependencies:  
   cd dragoturkey_alarm  
   flutter pub get  
3. Run the app:  
   flutter run  
4. Main routes: `/home`, `/timers`, `/caresseur`, `/baffeur`, `/mangeoire`, etc.

## Developer utilities

- Timers are persisted as JSON in SharedPreferences. Use logs or emulator file explorer for debugging.  
- Helpful commands:  
  - `flutter run --verbose` for detailed runtime logs  
  - `flutter analyze` for static analysis

## Project structure (important files)

- `lib/main.dart` — app entry point and named routes.  
- `lib/views/routes/home_view.dart` — main dashboard.  
- `lib/views/routes/timers_view.dart` — create and list local timers.  
- `lib/views/stats/*_view.dart` — domain-specific views (Caresseur, Baffeur, etc.).  
- `lib/services/timer_service.dart` — timer logic, persistence, orchestration.  
- `lib/services/notification_service.dart` — wrapper for flutter_local_notifications (init, schedule, cancel).  
- `lib/widgets/custom_app_bar.dart` — reusable AppBar component.  
- `assets/` — SVGs, images, fonts (declare fonts in `pubspec.yaml`).

## What this project demonstrates

This repository highlights practical skills valuable to employers:
- Proficient Flutter development for performant, polished mobile UI.  
- Modular design separating UI and business logic for maintainability.  
- Native integration experience (local notifications, Android intent nuances).  
- Robust state persistence and restoration (timers survive app restarts).  
- Problem solving: handling exact vs inexact alarms, foreground/background behavior, and platform exceptions.  
- Attention to UX details and accessibility.  
- Readiness for team workflows: routes, services, and components are structured for collaboration and testing.

## Next steps / Suggestions

- Add unit and widget tests around TimerService and NotificationService.  
- Integrate platform-specific permission flows and handle background execution constraints on Android/iOS.  
- Improve notification channels and custom sounds per timer type.  
- Add E2E tests and CI pipelines.

## Contact

Replace with your contact information before sharing publicly:  
Your Name — your.email@example.com  
Repository: <your-repo-url>
