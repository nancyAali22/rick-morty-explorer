# Rick & Morty Explorer

A production-ready Flutter application that explores the Rick and Morty universe — built with Clean Architecture, Cubit state management, and Excel export, as a technical assessment for the Flutter Developer Internship at **EASY WORLD ESTABLISHMENT DIGITAL MARKETING**.

## Project Description

_TODO — 2/3 paragraphs once the feature set is complete: what the app does, why the architecture choices were made, what makes it stand out._

## Architecture

This project follows **Clean Architecture** with three strict layers per feature:

- **Presentation** — Cubits, pages, widgets. No business logic, no API calls.
- **Domain** — Entities, repository interfaces, use cases. Pure Dart, no Flutter/Dio imports.
- **Data** — Models, remote datasources, repository implementations.

State management: **flutter_bloc (Cubit)**.
Dependency Injection: **get_it**.
Error handling: **dartz `Either<Failure, Success>`**.

## Folder Structure

```
lib/
├── core/        # shared: theme, router, DI, network, error, widgets
└── features/
    ├── splash/
    ├── characters/   # data / domain / presentation
    └── export/       # Excel export feature
```

## Features

- [ ] Fetch all characters (paginated)
- [ ] Search characters by name
- [ ] Filter by status / species / gender
- [ ] Character details with Hero animation
- [ ] Export displayed characters to `.xlsx`
- [ ] Skeleton loading, pull-to-refresh, retry & empty states
- [ ] Dark mode (follows system)
- [ ] Fully responsive (phones & tablets)
- [ ] Remembers last search/filter while navigating

## Screenshots

_TODO — add screenshots here before submission._

## Packages & Why

| Package | Why |
|---|---|
| flutter_bloc / equatable | Cubit-based state management |
| dio | HTTP client with interceptors & timeouts |
| get_it | Dependency Injection |
| go_router | Declarative routing |
| flutter_screenutil | Responsive UI (.w .h .sp .r) |
| cached_network_image | Efficient avatar loading & caching |
| shimmer | Skeleton loading states |
| excel | Export to `.xlsx` |
| path_provider / open_file | Save & open the exported file |
| connectivity_plus | Detect network state for accurate error states |
| dartz | `Either<Failure, Success>` functional error handling |
| flutter_native_splash | Native splash screen |

## Setup

```bash
flutter pub get
flutter pub run flutter_native_splash:create
```

## How to Run

```bash
flutter run
```

## Video Demo

_TODO — add video link before submission._

---

Built by [Your Name] for the EASY WORLD Flutter Internship assessment.
