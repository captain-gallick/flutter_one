class AppUrl {
  static const String baseDomain = 'https://maljal.org/';
  static const String baseURL = "https://maljal.org/api/authentication";
  static const String sendOtp = "https://maljal.org/api/authentication/login";
  static const String verifyOtp =
      "https://maljal.org/api/authentication/verify";
  static const String register = baseURL + "/registration";

  static const String baseServices = 'https://maljal.org/api';

  static const String departments = baseServices + "/departments";
  static const String services = baseServices + "/services";
  static const String servicesByDepartment = services + "/bydepartmentid/";

  static const String insertbooking = "https://maljal.org/api/booking";

  static const String imageUrl = 'https://maljal.org/';
  static const String citiesUrl = 'https://maljal.org/api/departments/cities';
  static const String areasUrl = 'https://maljal.org/api/departments/area/';

  static const String updateUser = 'https://maljal.org/api/user';
  static const String search = 'https://maljal.org/api/services/search/';
  static const String getLatestLocation =
      'https://maljal.org/api/booking/livetrack/';
}
