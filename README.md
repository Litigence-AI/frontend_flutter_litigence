# Litigence AI - Flutter Project Setup Guide

Hey there, welcome to the Litigence AI project! Let's get you set up with this legal assistant app that's all about making justice accessible to everyone. No cap! 🔍⚖️

## Project Overview

Litigence AI is an open-source legal information platform that includes:
- Flutter frontend (supports Android and Web)
- Flask backend hosted on Cloud Run
- AI integration for legal intelligence
- Authentication and chat interface

## Prerequisites

Before we dive in, make sure you have these tools installed:

- Git
- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter plugins
- Firebase CLI
- FlutterFire CLI

## Installation Guide

### 1. Clone the Repository

```bash
git clone https://github.com/YourOrganization/litigence-ai.git
cd litigence-ai
```

### 2. Set Up Flutter Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

First, install the FlutterFire CLI if you haven't already:

```bash
dart pub global activate flutterfire_cli
```

Then configure Firebase with your project:

```bash
flutterfire configure --project=
```

This will automatically generate:
- firebase.json in the root directory
- google-services.json in the android/app directory
- firebase_options.dart in the lib directory

### 4. Secret Key Setup

#### Android Release Signing

1. Create a directory for your keystore:
```bash
mkdir -p android/app/keystore
```

2. Create your keystore file:
```bash
keytool -genkey -v -keystore android/app/keystore/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

3. Create the key.properties file:
```bash
touch android/key.properties
```

4. Add your keystore information (replace placeholders with actual values):
```
storePassword=
keyPassword=
keyAlias=release
storeFile=keystore/my-release-key.jks
```

5. For debug builds, place your debug.keystore file in the project root:
```bash
cp ~/.android/debug.keystore ./debug.keystore
```

## Running the Application

### Development Mode

```bash
# For Android
flutter run

# For Web
flutter run -d chrome
```

### Running with Backend Connection

For development or production, use:
```bash
flutter run --dart-define=BACKEND_URL=
```

### Production Builds

#### Android Build

```bash
flutter build apk --release
# OR for app bundle
flutter build appbundle --release
```

#### Web Build

```bash
flutter build web --release --dart-define=BACKEND_URL=
```

## Project Structure

Based on the screenshot, the project has this structure:
```
├── android               # Android-specific code
│   ├── app
│   │   ├── src
│   │   ├── build.gradle
│   │   ├── google-services.json
│   │   └── my-release-key.jks
│   ├── key.properties
│   ├── local.properties
│   ├── gradle
│   └── build.gradle
├── lib                   # Flutter Dart code
│   ├── authentication    # Authentication logic
│   ├── chat_ui           # Chat interface components
│   ├── constants         # App constants
│   ├── dashboard         # Dashboard screens
│   ├── models            # Data models
│   ├── onboarding        # Onboarding screens
│   ├── otp_auth          # OTP authentication
│   ├── services          # Backend services
│   ├── theme             # App theming
│   ├── utils             # Utility functions
│   ├── widgets           # Reusable widgets
│   ├── firebase_options.dart
│   └── main.dart         # Entry point
├── web                   # Web-specific code
├── .env_template         # Template for environment variables
├── .firebaserc           # Firebase project config
└── debug.keystore        # Debug signing key
```

## Features

### Implemented
- Onboarding Flow (3 pages)
- Authentication (Google and Mobile OTP)
- Chat UI (Similar to ChatGPT)

### In Progress
- Chat History
- Law of the Day
- Enhanced UI Navigation for Indian Law resources
- Game elements to teach Law
- Language translation support

## Deployment

The app can be deployed to:
- Android: Google Play Store
- Web: Firebase Hosting
