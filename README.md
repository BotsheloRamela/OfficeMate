# OfficeMate

## Overview
OfficeMate is a mobile application designed to help users manage office spaces, including creating and managing offices, viewing office details and occupants, and managing office workers. The app is built using the Flutter framework and Firebase as the backend database service.

## Architecture
The OfficeMate app follows the Model-View-ViewModel (MVVM) architectural pattern. MVVM separates the user interface from the business logic and data access layer, promoting modularity and testability.

1. **Model (Data Layer):**
   - Represents the data structure of the application.
   - Interacts with the Firebase Firestore database to perform CRUD operations.
   - Includes entities such as Office, OfficeWorker, etc.
2. **View (Presentation Layer):**
   - Represents the user interface of the application.
   - Includes Flutter widgets for displaying data and receiving user input.
   - Observes ViewModel changes and updates UI accordingly.
3. **ViewModel (Business Logic Layer):**
   - Acts as an intermediary between the View and Model.
   - Contains business logic and application state.
   - Fetches data from the Model, processes it, and exposes it to the View.
   - Utilizes streams or state management solutions for reactive programming.

### Folder Structure
```
office_mate/
│
├── lib/
│   ├── data/
│   │   ├── models/
│   │   │   ├── office.dart
│   │   │   ├── office_worker.dart
│   │   │   └── ... (other data models)
│   │   ├── repositories/
│   │   │   ├── office_repository.dart
│   │   │   ├── office_worker_repository.dart
│   │   │   └── ... (other repositories)
│   │   └── firebase_service.dart
│   │
│   ├── ui/
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── office_details_screen.dart
│   │   │   └── ... (other UI screens)
│   │   ├── viewmodels/
│   │   │   ├── home_viewmodel.dart
│   │   │   ├── office_details_viewmodel.dart
│   │   │   └── ... (other viewmodels)
│   │   └── widgets/
│   │       ├── office_card.dart
│   │       ├── office_details_widget.dart
│   │       └── ... (other reusable widgets)
│   │
│   ├── utils/
│   │   ├── constants.dart
│   │   └── ... (other utility classes)
│   │
│   └── main.dart
│
├── pubspec.yaml
│
└── README.md
```

## Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/BotsheloRamela/OfficeMate.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
    ```bash
   flutter run
   ```

## Dependencies
- **Flutter SDK**: https://flutter.dev/docs/get-started/install
- **Firebase SDK**: https://firebase.google.com/docs/flutter/setup?platform=android

## Credits
- Avatar Images by <a href="https://www.freepik.com/free-psd/3d-illustration-person-with-sunglasses_27470360.htm">Freepik</a>