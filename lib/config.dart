class AppConfig {
  // Server configuration - UPDATE THIS IP FOR PHYSICAL DEVICE
  // For emulator: use 10.0.2.2
  // For physical device: use your computer's IP address (e.g., 192.168.1.100)
  // static const String baseUrl = 'http://localhost/foodle/';   
  static const String baseUrl = 'http://192.168.29.159/foodle';  
  
  // API endpoints
  static const String loginEndpoint = '$baseUrl/login.php';
  static const String signupEndpoint = '$baseUrl/test_signup.php';
  static const String verifyOtpEndpoint = '$baseUrl/test_verify_otp.php';
  static const String testEndpoint = '$baseUrl/test.php';
  static const String addFoodEndpoint = '$baseUrl/add_food.php';
  static const String getFoodsEndpoint = '$baseUrl/get_foods.php';
  static const String updateFoodEndpoint = '$baseUrl/add_food.php';
  static const String deleteFoodEndpoint = '$baseUrl/add_food.php';
  static const String addMemberEndpoint = '$baseUrl/add_member.php';
  static const String getMembersEndpoint = '$baseUrl/get_members.php';
  static const String updateMemberEndpoint = '$baseUrl/update_member.php';
  static const String deleteMemberEndpoint = '$baseUrl/delete_member.php';
  static const String addAllergyEndpoint = '$baseUrl/add_allergy.php';
  static const String getAllergiesEndpoint = '$baseUrl/get_allergies.php';
  static const String getNotificationsEndpoint = '$baseUrl/get_notifications.php';
  static const String markNotificationReadEndpoint = '$baseUrl/mark_notification_read.php';
  static const String linkMemberEndpoint = '$baseUrl/link_member.php';
  static const String updateMemberSettingsEndpoint = '$baseUrl/update_member_settings.php';
  static const String getMemberSettingsEndpoint = '$baseUrl/get_member_settings.php';
  
  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 15);
  
  // Common headers
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };
}