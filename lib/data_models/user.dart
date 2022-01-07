class User {
  String userId;
  String name;
  String phone;
  String email;
  String aadhar;
  String status;
  //String address;
  String token;
  String addedOn;
  String building;
  String area;
  String ward;
  String pincode;
  String city;
  String lat;
  String long;

  User(
      {required this.userId,
      required this.name,
      required this.email,
      required this.phone,
      required this.token,
      required this.aadhar,
      required this.status,
      //required this.address,
      required this.addedOn,
      required this.building,
      required this.area,
      required this.ward,
      required this.pincode,
      required this.city,
      required this.lat,
      required this.long});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      userId: responseData['id'],
      name: responseData['name'],
      email: responseData['email'],
      phone: responseData['phone'],
      aadhar: responseData['aadhar'],
      //address: responseData['address'],
      token: responseData['token'],
      addedOn: responseData['added_on'],
      status: responseData['status'],
      building: responseData['building'],
      area: responseData['area'],
      ward: responseData['ward'],
      pincode: responseData['pincode'],
      city: responseData['city'],
      lat: responseData['lat'],
      long: responseData['lng'],
    );
  }
}
