import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/my_bookings.dart';
import 'package:flutter_app_one/screens/booking_details.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/network_connecttion.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';

import 'home_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

List<MyBooking> history = [];

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late BuildContext dialogContext;
  bool showHistory = false;
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => getBookingHistory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen()),
              (route) => false,
            );
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      NetworkCheckUp().checkConnection().then((value) {
                        showHistory = true;
                        if (value) {
                          setState(() {
                            getBookingHistory();
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please connect to internet."),
                          ));
                        }
                      });
                    },
                    icon: const Icon(Icons.replay_rounded, color: Colors.black))
              ],
              title: const Align(
                  alignment: Alignment(-0.25, 0.0),
                  child: Text(
                    "Booking History",
                    style: TextStyle(color: AppColors.appGrey),
                  )),
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: IconButton(
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.appGrey,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const HomeScreen()),
                      (route) => false,
                    );
                  }),
            ),
            body: Column(
              children: <Widget>[
                Expanded(child: (showHistory) ? getList() : Container())
              ],
            ),
          )),
    );
  }

  getList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: history.length,
      itemBuilder: (context, position) {
        return GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BookingDetailsScreen(
                          history: history[position],
                        )),
                (route) => false,
              );
            },
            child: Column(
              children: [
                Container(
                  height: 5.0,
                  color: Colors.grey.shade200,
                ),
                ListTile(
                  title: Text(
                    history[position].serviceName,
                    style: const TextStyle(fontSize: 22.0),
                  ),
                  subtitle: Text(history[position].addedOn.substring(
                          0, history[position].addedOn.indexOf(" ")) +
                      " | " +
                      history[position]
                          .addedOn
                          .substring(history[position].addedOn.indexOf(" ")) +
                      " | " +
                      (getStatus(history[position].status))),
                  trailing: ClipRRect(
                    child: SizedBox(
                      height: 70.0,
                      width: 70.0,
                      child: getImage(position),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  getStatus(status) {
    if (status == '1') {
      return 'OPEN';
    } else if (status == '2') {
      return 'PROCESSING';
    } else {
      return 'COMPLETE';
    }
  }

  getImage(int position) {
    log(AppUrl.imageUrl + history[position].media);
    if (history[position].media != '') {
      return Align(
          alignment: Alignment.centerRight,
          child: Image.network(
            AppUrl.imageUrl + history[position].media,
            width: 70.0,
            fit: BoxFit.fill,
          ));
    } else {
      return Container();
    }
  }

  getBookingHistory() async {
    NetworkCheckUp().checkConnection().then((value) async {
      if (value) {
        showLoader();
        try {
          history = [];
          String token = '';
          await UserPreferences().getToken().then((value) => token = value);

          final Response response = await get(
              Uri.parse(AppUrl.insertbooking + '/1'),
              headers: <String, String>{'token': token});

          if (!(jsonDecode(response.body).toString().toLowerCase())
              .contains('data')) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(jsonDecode(response.body).toString().toUpperCase()),
            ));
          } else {
            log(response.body);
            List<dynamic> list = jsonDecode(response.body)['data'];
            for (int i = 0; i < list.length; i++) {
              history.add(MyBooking.fromJson(list[i]));
            }
            setState(() {
              showHistory = !showHistory;
              Navigator.pop(dialogContext);
            });
          }
          return history;
        } catch (e) {
          //print(e.toString());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please connect to internet."),
        ));
      }
    });
  }

  void showLoader() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return WillPopScope(
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text('Please wait...'),
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }
}
