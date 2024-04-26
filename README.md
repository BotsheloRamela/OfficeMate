# OfficeMate

## Overview
OfficeMate is a mobile application designed to help users manage office spaces, including creating and managing offices, viewing office details and occupants, and managing office workers. The app is built using the Flutter framework and Firebase as the backend database service.

## Cross-Platform Compatibility
OfficeMate is designed to be accessible across a wide range of devices and platforms. Whether you prefer to use your phone, tablet, or computer, you can access the application seamlessly.

Here's a breakdown of supported platforms:

- **Mobile:** The application is available for both iOS and Android devices.
- **Web:** A web-based version is also accessible at https://officemate-9237b.web.app/, hosted on Firebase Hosting. This makes it convenient to use on any device with a web browser, regardless of operating system.

## Setup Instructions
OfficeMate is built Flutter version **3.19.4** on channel stable and Dart version **3.3.2**, so those are the minimum requirements to ensure the project runs without any issues.

To set up the OfficeMate project on your local machine, follow these steps:

1. Install the Flutter SDK by following the instructions [here](https://flutter-ko.dev/get-started/install).
2. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/BotsheloRamela/OfficeMate.git
   ```
3. Navigate to the project directory:
    ```bash
    cd office_mate
    ```
4. Install the necessary project dependencies by running:
    ```bash
    flutter pub get
    ```
5. Open the project in Android Studio, Visual Studio or Xcode.
6. Set up your local environment variables for the required services (Firebase). Ensure you have the environment variables defined in `.env.dev`. You'll find a template `.env.template` file in the codebase to guide you on the variable names needed.
7. Run/start the app with the desired environment using the following command:
    ```bash
    flutter run --dart-define-from-file=.env.dev
    ```

### Additional Development Steps
During development, you may need to generate code using `build_runner`. To do this, run the following command in the project directory:
```bash
flutter pub run build_runner build
```
This command generates code for various purposes such as JSON serialization. Make sure to run it whenever you make changes to relevant files.

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
│   │   └── services/
│   │       └── firebase_service.dart
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

## Dependencies
- **Flutter SDK**: https://flutter.dev/docs/get-started/install
- **Firebase SDK**: https://firebase.google.com/docs/flutter/setup?platform=android

## Credits
- Avatar Images by <a href="https://www.freepik.com/free-psd/3d-illustration-person-with-sunglasses_27470360.htm">Freepik</a>
