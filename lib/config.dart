class AppConfig {
  // Server configuration - UPDATE THIS IP FOR PHYSICAL DEVICE
  // For emulator: use 10.0.2.2
  // For physical device: use your computer's IP address (e.g., 192.168.1.100)
  static const String baseUrl = 'http://localhost:80'; // XAMPP default port
  
  // API endpoints
  static const String loginEndpoint = '$baseUrl/login.php';
  static const String signupEndpoint = '$baseUrl/test_signup.php';
  static const String verifyOtpEndpoint = '$baseUrl/test_verify_otp.php';
  static const String testEndpoint = '$baseUrl/test.php';
  
  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 15);
  
  // Common headers
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };
}