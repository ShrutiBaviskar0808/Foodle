# Technology Stack

## Programming Languages
- **Dart**: Primary language for Flutter application logic (SDK ^3.10.8)
- **Kotlin**: Android native implementation (MainActivity.kt)
- **Swift**: iOS and macOS native implementations
- **C++**: Windows and Linux desktop runners
- **PHP**: Backend server scripts for authentication and database operations
- **SQL**: Database schema and operations (MySQL)

## Framework and Dependencies
- **Flutter SDK**: Cross-platform UI framework
- **Core Dependencies**:
  - cupertino_icons: ^1.0.8 (iOS-style icons)
  - font_awesome_flutter: ^10.7.0 (Icon library)
  - http: ^1.1.0 (Network requests)
  - shared_preferences: ^2.2.2 (Local storage)
- **Development Dependencies**:
  - flutter_test (Testing framework)
  - flutter_lints: ^6.0.0 (Code quality and style enforcement)

## Build Systems
- **Android**: Gradle with Kotlin DSL (build.gradle.kts)
- **iOS/macOS**: Xcode with Swift Package Manager
- **Windows/Linux**: CMake build system
- **Web**: Flutter web compiler with PWA support

## Database and Backend
- **Database**: MySQL with structured tables for users, OTP verification, and preferences
- **Backend**: PHP-based REST API with authentication endpoints
- **Local Storage**: SharedPreferences for client-side data persistence

## Development Commands
```bash
# Install dependencies
flutter pub get

# Run on different platforms
flutter run                    # Default platform
flutter run -d chrome         # Web browser
flutter run -d windows        # Windows desktop
flutter run -d macos          # macOS desktop

# Build for production
flutter build apk             # Android APK
flutter build ios             # iOS app
flutter build web             # Web deployment
flutter build windows         # Windows executable

# Testing
flutter test                   # Run unit tests
flutter analyze               # Static code analysis
```

## Configuration Files
- **pubspec.yaml**: Dependency management and asset configuration
- **analysis_options.yaml**: Linting rules and code quality standards
- **Platform configs**: AndroidManifest.xml, Info.plist, CMakeLists.txt for respective platforms