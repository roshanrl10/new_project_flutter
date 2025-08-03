Here's a `TREK_APP_FEATURES.md` file listing all the key features of your Trek App based on the components and architecture we've developed:

---

# 🏞️ Trek App Features (`TREK_APP_FEATURES.md`)

## 📱 App Overview

The **Trek App** is a Flutter-based trekking companion that helps users explore, book, and navigate trekking experiences. The application follows **Clean Architecture** principles and uses **BLoC** for state management with **Hive** for local storage.

---

## 🧩 Core Features

### 1. 🚀 Splash Screen

- Initial launch screen.
- Loads and prepares required resources (e.g., Hive box initialization).

---

### 2. 🔐 Authentication

- **Login and Signup** pages.
- Form validation and user credential handling.
- User session handling (Hive).

---

### 3. 🗺️ Map Feature

- Displays a list of trekking places.
- **Search Bar** with live filtering.
- On selecting a place:

  - Shows **Google Map** with a marker on the selected location.
  - Uses **Google Maps API**.

- Built with `google_maps_flutter` and BLoC state management.

---

### 4. 🌦️ Weather Feature

- Displays a list of places with available weather data.
- **Search and Filter** support.
- On selecting a place:

  - Shows detailed weather info using custom entity.

- Data fetched from remote or mock repository.
- Offline caching supported via Hive.

---

### 5. 🧭 Itinerary Feature

- Users can plan trekking itineraries.
- Add, update, and delete itinerary items.
- Itinerary list stored and fetched using **Hive** (local database).
- Separated into:

  - Data (Hive Model, Repository)
  - Domain (Entities, Abstract Repository)
  - Presentation (Bloc, UI)

---

### 6. 🏕️ Trekking Place Management

- Shows a list of available trekking spots.
- On click, shows detailed information (in map or weather module).
- Used in multiple modules (weather, map, itinerary).

---

## 🗃️ Architecture Overview

- **Clean Architecture**

  - Domain: Pure business logic (Entities, Repository abstraction)
  - Data: Hive & API implementations of repositories
  - Presentation: Widgets + BLoC

- **BLoC Pattern**

  - Organized into Event, State, and Bloc files for each feature.

- **Hive**

  - Used for local storage of entities like itinerary, cached weather data.
  - Box names are modular per feature.

---

## 🔑 Integration & APIs

- **Google Maps API**

  - Required for `google_maps_flutter`.
  - Key placed in `AndroidManifest.xml` and `AppDelegate.swift`.

---

## ⚙️ Technologies Used

- Flutter SDK
- Dart
- Hive (NoSQL)
- BLoC (flutter_bloc)
- Google Maps Flutter
- Clean Architecture
