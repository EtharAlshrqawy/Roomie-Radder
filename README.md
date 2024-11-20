
# RoomieRadar

RoomieRadar is a mobile application designed to help users find compatible roommates based on a detailed compatibility questionnaire. The app connects individuals seeking shared living arrangements, ensuring they find the best fit for their lifestyle and preferences.

## Features

- **User Authentication**: Secure sign-up, sign-in, and password recovery using Firebase Authentication.
- **Room Listings**: Browse and view available rooms with detailed descriptions, pricing, and features.
- **Compatibility Questionnaire**: Answer a series of questions to determine compatibility percentages with potential roommates.
- **User Profiles**: Create and manage user profiles, including personal information, reviews, and ratings.
- **Room Reviews**: Users can review and rate rooms, providing insights for others.

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore Database)
- **Architecture**: MVVM (Model-View-ViewModel)
- **Version Control**: Git, GitHub

## Getting Started

To get a local copy of the repository up and running, follow these steps:

### Prerequisites

1. **Install Flutter SDK**: [Download Flutter](https://flutter.dev/docs/get-started/install)
2. **Install Dart SDK**: (Comes bundled with Flutter)
3. **Set up a Firebase Account**: [Firebase Console](https://console.firebase.google.com)

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/EtharAlshrqawy/Roomie-Radder.git
   ```

2. **Navigate into the Project Directory**:
   ```bash
   cd RoomieRadar
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Set up Firebase**:
   - Follow the Firebase setup guide to add your app to Firebase.
   - Replace the following files in the project:
     - `google-services.json` (for Android)
     - `GoogleService-Info.plist` (for iOS)

5. **Run the App**:
   ```bash
   flutter run
   ```

## Usage

- Users can sign up or log in to access the app.
- After authentication, users can browse available rooms, fill out the compatibility questionnaire, and view profiles of potential roommates.

## Contributing

Contributions are welcome! Feel free to open issues and submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the Firebase team for providing excellent tools for authentication and database management.
- Special thanks to the Flutter community for their amazing resources and support.
