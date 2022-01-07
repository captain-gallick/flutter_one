import 'package:flutter_app_one/data_models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("userId", user.userId);
    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("token", user.token);
    prefs.setString("aadhar", user.aadhar);
    prefs.setString("addedOn", user.addedOn);
    prefs.setString("status", user.status);
    //prefs.setString("address", user.address);
    prefs.setString("building", user.building);
    prefs.setString("area", user.area);
    prefs.setString("ward", user.ward);
    prefs.setString("pincode", user.pincode);
    prefs.setString("city", user.city);
    prefs.setString("lat", user.lat);
    prefs.setString("long", user.long);

    return true;
  }

  setWelcomeScreenStatus(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("shown", value);
  }

  Future<bool> getWelcomeScreenStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('shown')) {
      bool shown = prefs.getBool("shown") as bool;
      return shown;
    } else {
      return false;
    }
  }

  Future<String> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String id = prefs.getString('userId') as String;
      return id;
    } else {
      return '';
    }
  }

  Future<String> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String name = prefs.getString('name') as String;
      return name;
    } else {
      return '';
    }
  }

  getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String email = prefs.getString('email') as String;
      return email;
    } else {
      return '';
    }
  }

  getPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String phone = prefs.getString('phone') as String;
      return phone;
    } else {
      return '';
    }
  }

  getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String token = prefs.getString('token') as String;
      return token;
    } else {
      return '';
    }
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('token')) {
      String id = prefs.getString('userId') as String;
      String name = prefs.getString('name') as String;
      String email = prefs.getString('email') as String;
      String phone = prefs.getString('phone') as String;
      String token = prefs.getString('token') as String;
      String addedOn = prefs.getString('addedOn') as String;
      String status = prefs.getString('status') as String;
      String aadhar = prefs.getString('aadhar') as String;
      //String address = prefs.getString('address') as String;
      String building = prefs.getString('building') as String;
      String area = prefs.getString('area') as String;
      String ward = prefs.getString('ward') as String;
      String pincode = prefs.getString('pincode') as String;
      String city = prefs.getString('city') as String;
      String lat = prefs.getString('lat') as String;
      String long = prefs.getString('long') as String;
      return User(
          userId: id,
          name: name,
          email: email,
          phone: phone,
          token: token,
          aadhar: aadhar,
          status: status,
          addedOn: addedOn,
          //address: address,
          building: building,
          area: area,
          ward: ward,
          city: city,
          pincode: pincode,
          long: long,
          lat: lat);
    } else {
      return User(
        userId: '',
        name: '',
        email: '',
        phone: '',
        token: '',
        aadhar: '',
        status: '',
        addedOn: '',
        //address: '',
        building: '',
        area: '',
        ward: '',
        city: '',
        pincode: '',
        long: '',
        lat: '',
      );
    }
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("token");
    prefs.remove("status");
    prefs.remove("addedOn");
    prefs.remove("aadhar");
    //prefs.remove("address");
    prefs.remove("building");
    prefs.remove("area");
    prefs.remove("ward");
    prefs.remove("pincode");
    prefs.remove("city");
    prefs.remove("lat");
    prefs.remove("long");
  }

  Future<bool> saveTempData(
      name, email, phone, building, area, ward, pincode, city) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("tname", name);
    prefs.setString("temail", email);
    prefs.setString("tphone", phone);
    prefs.setString("tbuilding", building);
    prefs.setString("tarea", area);
    prefs.setString("tward", ward);
    prefs.setString("tpincode", pincode);
    prefs.setString("tcity", city);

    return true;
  }

  getTempData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = [
      prefs.getString('tname') as String,
      prefs.getString('temail') as String,
      prefs.getString('tphone') as String,
      prefs.getString('tbuilding') as String,
      prefs.getString('tarea') as String,
      prefs.getString('tward') as String,
      prefs.getString('tpincode') as String,
      prefs.getString('tcity') as String
    ];
    return data;
  }

  void removeTempData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("tname");
    prefs.remove("temail");
    prefs.remove("tphone");
    prefs.remove("tbuilding");
    prefs.remove("tarea");
    prefs.remove("tward");
    prefs.remove("tpincode");
    prefs.remove("tcity");
  }
}
