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
    prefs.setString("address", user.address);
    prefs.setString("addedOn", user.addedOn);
    prefs.setString("status", user.status);

    return true;
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

  getAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String address = prefs.getString('address') as String;
      return address;
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
      String address = prefs.getString('address') as String;
      String addedOn = prefs.getString('addedOn') as String;
      String status = prefs.getString('status') as String;
      return User(
          userId: id,
          name: name,
          email: email,
          phone: phone,
          token: token,
          address: address,
          status: status,
          addedOn: addedOn);
    } else {
      return User(
          userId: '',
          name: '',
          email: '',
          phone: '',
          token: '',
          address: '',
          status: '',
          addedOn: '');
    }
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("type");
    prefs.remove("token");
    prefs.remove("status");
    prefs.remove("address");
    prefs.remove("addedOn");
  }
}
