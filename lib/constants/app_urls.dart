class AppUrl {
  static const String baseDomain = 'http://maljal.org/';
  static const String baseURL = "http://maljal.org/api/authentication";
  static const String sendOtp = baseURL + "/login";
  static const String verifyOtp = baseURL + "/verify";
  static const String register = baseURL + "/registration";

  static const String baseServices = 'http://maljal.org/api';

  static const String departments = baseServices + "/departments";
  static const String services = baseServices + "/services";
  static const String servicesByDepartment = services + "/bydepartmentid/";

  static const String insertbooking = baseServices + "/booking";

  static const String imageUrl = 'http://maljal.org/assets/uploads/';

  static const String updateUser = 'http://maljal.org/api/user';
  static const String search = 'http://maljal.org/api/services/search/';
}
