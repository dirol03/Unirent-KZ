# UniRent KZ

UniRent KZ is a Flutter MVP for a student rental marketplace in Kazakhstan. Students can sign up, publish rental items, browse listings, and manage their own posts with Firebase Authentication, Cloud Firestore, and Firebase Storage.

## Project Structure

```text
lib/
  main.dart
  app.dart
  core/
    constants/
      app_constants.dart
    theme/
      app_theme.dart
    utils/
      form_validators.dart
  features/
    auth/
      presentation/
        providers/
          auth_controller.dart
        screens/
          auth_gate.dart
          auth_screen.dart
    home/
      presentation/
        providers/
          marketplace_provider.dart
        screens/
          home_screen.dart
    item_details/
      presentation/
        screens/
          item_details_screen.dart
    add_item/
      presentation/
        screens/
          add_edit_item_screen.dart
    profile/
      presentation/
        screens/
          profile_screen.dart
  models/
    rental_item.dart
  services/
    auth_service.dart
    item_service.dart
    storage_service.dart
  widgets/
    empty_state_card.dart
    firebase_setup_screen.dart
    item_card.dart
    main_shell.dart
```

## pubspec.yaml

```yaml
name: unirent_kz
description: "UniRent KZ student rental marketplace MVP built with Flutter and Firebase."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.5
  firebase_core: ^4.1.1
  firebase_auth: ^6.0.2
  cloud_firestore: ^6.0.1
  firebase_storage: ^13.0.1
  image_picker: ^1.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
```

## Firebase Setup

### 1. Create Firebase project

Create a Firebase project in the Firebase Console, then add an Android app with:

- Package name: `com.unirentkz.app`

### 2. Enable services

Enable these Firebase products:

- Authentication
  - Sign-in method: Email/Password
- Cloud Firestore
- Firebase Storage

### 3. Place Firebase config files

Android:

- Put `google-services.json` here:
  - `android/app/google-services.json`

iOS later if needed:

- Put `GoogleService-Info.plist` here:
  - `ios/Runner/GoogleService-Info.plist`

### 4. Firestore collection structure

Main collection:

- `items`

Document example:

```json
{
  "id": "autoDocId",
  "title": "TI Calculator",
  "description": "Good condition, perfect for exams.",
  "category": "Study Tools",
  "pricePerDay": 1200,
  "imageUrl": "https://...",
  "ownerId": "firebaseUserUid",
  "ownerName": "Aruzhan S.",
  "ownerEmail": "student@example.com",
  "location": "Almaty",
  "createdAt": "Firestore Timestamp"
}
```

Note:

- `ownerEmail` was added for the MVP contact button so users can copy the owner email.

### 5. Suggested Firestore rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /items/{itemId} {
      allow read: if true;
      allow create: if request.auth != null
        && request.resource.data.ownerId == request.auth.uid;
      allow update, delete: if request.auth != null
        && resource.data.ownerId == request.auth.uid;
    }
  }
}
```

### 6. Suggested Storage rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /item_images/{userId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Placeholder Note

No Firebase secret keys are stored in this repository. The app intentionally expects your own Firebase project files:

- Add `android/app/google-services.json`
- Optionally add `ios/Runner/GoogleService-Info.plist`

If those files are missing, the app shows a friendly Firebase setup screen instead of crashing immediately.

## Run Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Step-by-Step Run Guide

1. Install Flutter and Android Studio.
2. Open an Android emulator or connect an Android device.
3. Add your Firebase project files in the correct folders.
4. In Firebase Console, enable Email/Password authentication.
5. Create Firestore Database and Firebase Storage.
6. Run:

```bash
flutter pub get
flutter run
```

## Testing Checklist

- Sign up with a new email and password
- Close and reopen the app, confirm user stays logged in
- Sign out and sign back in
- Add an item with image, title, category, price, location, and description
- Confirm item appears on the home screen in real time
- Search by title
- Filter by category
- Open item details and copy owner email
- Edit your own item from the Profile tab
- Delete your own item from the Profile tab
- Confirm deleted item disappears from Firestore and from the UI

## MVP Scope Covered

- Firebase Authentication
- Cloud Firestore as the main database
- Full CRUD for rental items
- Firebase Storage image upload
- Material 3 professional UI
- Small, clear, beginner-friendly architecture
