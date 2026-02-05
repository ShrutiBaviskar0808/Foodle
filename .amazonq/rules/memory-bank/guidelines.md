# Development Guidelines

## Code Quality Standards

### Header Guards and Include Protection
- **C/C++ Files**: Use `#ifndef`/`#define`/`#endif` pattern for header protection
- **Pattern**: `#ifndef FLUTTER_FILENAME_H_` followed by `#define FLUTTER_FILENAME_H_`
- **Consistency**: All header files follow this protection mechanism

### Documentation Standards
- **C/C++ Functions**: Use block comments with parameter descriptions
- **Format**: `/** function_name: * Description * Returns: description */`
- **Python Functions**: Use docstrings for complex functions with clear parameter explanations

### Naming Conventions
- **C/C++**: snake_case for functions (`my_application_new`)
- **Kotlin**: PascalCase for classes (`MainActivity`)
- **Swift**: PascalCase for classes (`MainFlutterWindow`)
- **Constants**: ALL_CAPS with underscores (`IDI_APP_ICON`)

## Structural Conventions

### Class Inheritance Patterns
- **Android**: Extend framework classes directly (`FlutterActivity`)
- **iOS/macOS**: Override framework methods (`awakeFromNib`, `NSWindow`)
- **Minimal Implementation**: Keep platform-specific code minimal and focused

### Import Organization
- **Platform-specific imports first**: Framework imports at the top
- **Kotlin**: `io.flutter.embedding.android.FlutterActivity`
- **Swift**: `import Cocoa`, `import FlutterMacOS`
- **C++**: System includes (`<gtk/gtk.h>`)

### File Structure Standards
- **Single Responsibility**: One main class per file
- **Platform Separation**: Dedicated directories for each platform
- **Generated Code**: Clear marking of auto-generated files with comments

## Semantic Patterns

### Flutter Integration Architecture
- **Native Wrapper Pattern**: Platform-specific classes wrap Flutter functionality
- **Plugin Registration**: Consistent plugin registration across platforms
- **Minimal Native Code**: Keep platform-specific logic to essential framework integration

### Memory Management
- **LLDB Integration**: Custom memory handling for debugging (iOS)
- **Error Handling**: Explicit error checking with detailed logging
- **Resource Management**: Proper cleanup and resource allocation patterns

### Cross-Platform Consistency
- **Unified Interface**: Same Flutter app runs across all platforms
- **Platform Adaptation**: Native platform conventions respected in implementation
- **Framework Integration**: Proper use of platform-specific Flutter embeddings

## Development Practices

### Code Organization
- **Platform Isolation**: Each platform maintains its own runner implementation
- **Framework Compliance**: Follow platform-specific architectural patterns
- **Debugging Support**: Include debugging utilities and helpers where needed

### Build System Integration
- **Native Build Tools**: Use platform-appropriate build systems (Gradle, Xcode, CMake)
- **Dependency Management**: Platform-specific dependency resolution
- **Configuration Management**: Separate configuration files for each platform

### Testing and Debugging
- **Debug Helpers**: Include platform-specific debugging utilities
- **Error Reporting**: Comprehensive error handling with meaningful messages
- **Development Tools**: Integration with platform-specific development environments