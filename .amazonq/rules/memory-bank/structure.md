# Project Structure

## Directory Organization

### Core Application (`lib/`)
- **main.dart**: App entry point with routing configuration and onboarding flow
- **home.dart**: Main dashboard with family, places, and friends sections
- **Authentication Flow**: login.dart, signup.dart, email_verification.dart, otp_verification.dart, forgot_password.dart, reset_password.dart
- **Utilities**: config.dart, network_helper.dart, server_test.dart, debug_page.dart
- **services/**: Backend service integrations (currently empty, prepared for expansion)

### Platform-Specific Implementations
- **android/**: Native Android configuration with Kotlin MainActivity and Gradle build system
- **ios/**: Native iOS setup with Swift AppDelegate and Xcode project files
- **windows/**: Windows desktop support with C++ runner and CMake configuration
- **macos/**: macOS desktop implementation with Swift MainFlutterWindow
- **linux/**: Linux desktop support with C++ application framework
- **web/**: Progressive Web App configuration with manifest and service worker support

### Assets and Resources
- **assets/**: Image resources (homebg.jpg.jpg, main bg.jpg.jpg)
- **test/**: Widget testing framework setup
- **Backend Integration**: PHP scripts for server-side authentication and database operations

## Core Components

### Authentication System
Multi-layered security with email verification, OTP validation, and password recovery flows integrated with backend PHP services and MySQL database.

### Navigation Architecture
Route-based navigation system with named routes for all major screens, supporting deep linking and state management.

### UI Components
Material Design-based interface with custom styling, gradient backgrounds, and responsive layouts optimized for mobile-first experience.

## Architectural Patterns
- **Single Activity Architecture**: Flutter's widget-based approach with StatelessWidget and StatefulWidget patterns
- **Route Management**: Centralized routing in main.dart with named route definitions
- **State Management**: Built-in Flutter state management with setState pattern
- **Network Layer**: HTTP-based API communication with dedicated network helper utilities