class AppUrl {
  static const String baseDomain = 'https://svtindia.in/maljalorg/';
  static const String baseURL =
      "https://svtindia.in/maljalorg/api/authentication";
  static const String sendOtp = baseURL + "/login";
  static const String verifyOtp = baseURL + "/verify";
  static const String register = baseURL + "/registration";

  static const String baseServices = 'https://svtindia.in/maljalorg/api';

  static const String departments = baseServices + "/departments";
  static const String services = baseServices + "/services";
  static const String servicesByDepartment = services + "/bydepartmentid/";

  static const String insertbooking = baseServices + "/booking";

  static const String imageUrl =
      'https://svtindia.in/maljalorg/assets/uploads/';

  static const String updateUser = 'https://svtindia.in/maljalorg/api/user';
}
