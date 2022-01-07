class MyBooking {
  String id;
  String userId;
  String name;
  String phone;
  String email;
  String address;
  String service;
  String department;
  String status;
  String sdescr;
  String addedOn;
  String media;
  String meadia1;
  String vendor;
  String serviceName;
  String building;
  String area;
  String ward;
  String pincode;
  String lat;
  String lng;
  String city;

  MyBooking(
      {required this.id,
      required this.userId,
      required this.name,
      required this.email,
      required this.phone,
      required this.service,
      required this.department,
      required this.sdescr,
      required this.media,
      required this.meadia1,
      required this.address,
      required this.vendor,
      required this.status,
      required this.addedOn,
      required this.area,
      required this.building,
      required this.pincode,
      required this.ward,
      required this.lat,
      required this.lng,
      required this.city,
      this.serviceName = 'Service Name'});

  factory MyBooking.fromJson(Map<String, dynamic> responseData) {
    return MyBooking(
        id: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        phone: responseData['phone'],
        addedOn: responseData['added_on'],
        address: responseData['address'],
        status: responseData['status'],
        department: responseData['department'],
        userId: responseData['user_id'],
        meadia1: responseData['media1'],
        media: responseData['media'],
        sdescr: responseData['sdescr'],
        service: responseData['service'],
        vendor: responseData['vendor'],
        area: responseData['vendor'],
        building: responseData['vendor'],
        lat: responseData['vendor'],
        lng: responseData['vendor'],
        pincode: responseData['vendor'],
        ward: responseData['vendor'],
        city: responseData['city'],
        serviceName: (responseData.containsKey('service_name')
            ? responseData['service_name']
            : 'Service Name'));
  }
}
