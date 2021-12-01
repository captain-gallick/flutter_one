class User {
  String userId;
  String name;
  String phone;
  String email;
  String address;
  String status;
  String token;
  String addedOn;

  User(
      {required this.userId,
      required this.name,
      required this.email,
      required this.phone,
      required this.token,
      required this.address,
      required this.status,
      required this.addedOn});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        phone: responseData['phone'],
        token: responseData['token'],
        addedOn: responseData['added_on'],
        address: responseData['address'],
        status: responseData['status']);
  }
}
