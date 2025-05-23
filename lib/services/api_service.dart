class ApiEndpoints {
  // static const String baseUrl = "http://localhost:5062/api";
  // static const String baseUrl = "http://localhost:5062/api"; //iphone
  static const String baseUrl = "http://27.69.254.37:5062/api"; //iphone
  // static const String baseUrl = "http://171.251.5.68:5062/api"; //iphone
  // static const String baseUrl = "http://137.59.106.46:5000/api"; //iphone
  // static const String baseUrl =
  //     "http://10.0.2.2:5062/api"; // Nếu chạy trên Android Emulator
  // static const String baseUrl =
  //     "http://116.105.31.119:5062/api"; // Nếu chạy trên Android Emulator
  static const String chatbot =
      "https://ronmanhwa.app.n8n.cloud/webhook/c06e7c6d-be67-4e4b-ac71-3781fdaea258/chat"; //iphone
  //https://strockerai.app.n8n.cloud/webhook/9f8e4a1a-3c19-48e1-ad90-f1efed1d7dce/chat

  // Auth
  static const String login = "$baseUrl/User/login";
  static const String register = "$baseUrl/User/register";
  static const String verifyOtp = "$baseUrl/User/verifyOtp";
  static const String profile = "$baseUrl/User/users";
  static const String forgot = "$baseUrl/User/forgot-password";
  static const String commit = "$baseUrl/User/reset-password";
  static const String change = "$baseUrl/User/change-password";
  static const String update_basic_info = "$baseUrl/User/update-basic-info";
  static const String user_gps = "$baseUrl/User/user-gps";
  // User
  static const String getUserProfile = "$baseUrl/User/profile";
  static const String updateUserProfile = "$baseUrl/User/update";

  static const String averageAll14Day =
      "$baseUrl/UserMedicalDatas/average-daily-night-last-14-days/";
  static const String fetchDailyDay = "$baseUrl/UserMedicalDatas/daily/";
  static const String fetchResults =
      "$baseUrl/UserMedicalDatas/average-daily-night-last-14-days/";

  //Indicator
  static const String indicator =
      "$baseUrl/Indicators/get-percent-indicator-is-true";
  static const String symptom = "$baseUrl/Indicators/add-clinical-indicator";
  static const String get_symptom = "$baseUrl/Indicators/get-indicator";
  static const String create_invitation =
      "$baseUrl/Invitation/create-invitation";
  static const String get_indicator = "$baseUrl/Indicators/get-indicator";

  // Invitation
  static const String use_invitation = "$baseUrl/Invitation/use-invitation";
  static const String get_elationship = "$baseUrl/Invitation/get-relationship";
  static const String delete_relationship =
      "$baseUrl/Invition/delete-relationship";
  //device
  static const String get_devices = "$baseUrl/Devices/get-devices";
  static const String add_devices = "$baseUrl/Devices/add-device";
  static const String delete_devices = "$baseUrl/Devices/delete-devices";

  // Example thêm endpoint khác
  static const String getPosts = "$baseUrl/Posts";

  // notification mobilenotification
  static const String getNotification = "$baseUrl/MobileNotification/user";
  static const String pushNotification = "$baseUrl/MobileNotification/";
  static String get notificationHub {
    final domainBase = baseUrl.substring(0, baseUrl.lastIndexOf('/api'));
    return "$domainBase/notificationHub";
  }

  // Thông báo Endpoints
  static const String mobileNotifications = "$baseUrl/MobileNotifications";
  static String mobileNotificationsForUser(int userId) =>
      "$mobileNotifications/user/$userId";
  static String markAsRead(String notificationId) =>
      "$mobileNotifications/$notificationId/read";
  // Data medical
  static const String postMedicalData = "$baseUrl/UserMedicalDatas/medicaldata";
  //EmergencyButton
  static const String emergencyButton = "$baseUrl/EmergencyButton/activate";
  //warning
  static const String postWarning =
      "$baseUrl/Warning/device-reading"; //http://171.251.5.68:5062/api/Warning/device-reading
  static const String send_warning = "$baseUrl/EmergencyButton/activate";
}
