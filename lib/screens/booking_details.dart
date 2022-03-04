import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/my_bookings.dart';
import 'package:flutter_app_one/screens/booking_history.dart';
import 'package:flutter_app_one/screens/tracker_screen.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/network_connecttion.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class BookingDetailsScreen extends StatefulWidget {
  final MyBooking history;

  const BookingDetailsScreen({Key? key, required this.history})
      : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late BuildContext buildContext;

  late BuildContext dialogContext;
  bool showTrack = false;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const BookingHistoryScreen()),
                (route) => false,
              );
              return false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Align(
                    alignment: Alignment(-0.25, 0.0),
                    child: Text(
                      "Details",
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
                                const BookingHistoryScreen()),
                        (route) => false,
                      );
                    }),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Card(
                          color: Colors.blue.shade50,
                          margin: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 5.0),
                          elevation: 10.0,
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: SizedBox(
                            height: 450,
                            width: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: getImage(),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(
                                      'Service Details:',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                  Text(
                                    widget.history.serviceName,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  const Text(
                                    'Description: ',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    widget.history.sdescr,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  getVideo(widget.history.meadia1.isNotEmpty
                                      ? 1
                                      : 2),
                                  const Text(
                                    'Person Details: ',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    widget.history.name,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    widget.history.email,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    widget.history.phone,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  Text(widget.history.addedOn.substring(0,
                                          widget.history.addedOn.indexOf(" ")) +
                                      " | " +
                                      widget.history.addedOn.substring(
                                          widget.history.addedOn.indexOf(" ")) +
                                      " | " +
                                      (getStatus(widget.history.status)))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 60.0,
                      // ),
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Visibility(
                            visible: ((widget.history.status == '1' ||
                                    widget.history.status == '3')
                                ? false
                                : true),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  TrackerScreen(
                                                    id: widget.history.id,
                                                  )),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        'TRACK',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0),
                                      )),
                                  /* OutlinedButton(
                                      onPressed: () {
                                        NetworkCheckUp()
                                            .checkConnection()
                                            .then((value) {
                                          if (value) {
                                            /* Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ContactScreen(
                                                              widget.history)),
                                              (route) => false,
                                            ); */
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please connect to internet."),
                                            ));
                                          }
                                        });
                                      },
                                      child: const Text(
                                        'CONTACT',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0),
                                      )), */
                                ]),
                          ),
                        ),
                      )
                    ]),
              ),
            )));
  }

  getVideo(int i) {
    if (i == 1) {
      return GestureDetector(
        onTap: () {
          NetworkCheckUp().checkConnection().then((value) {
            if (value) {
              url_launcher.launch(AppUrl.imageUrl + widget.history.meadia1);
              log(AppUrl.imageUrl + widget.history.meadia1);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Please connect to internet."),
              ));
            }
          });
        },
        child: Text(
          'open video',
          style: TextStyle(
              color: Colors.blue.shade800,
              decoration: TextDecoration.underline),
        ),
      );
    } else {
      return const Text('');
    }
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

  getImage() {
    if (widget.history.media != '') {
      return GestureDetector(
        onTap: () {
          showImage(widget.history.media);
        },
        child: Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  AppUrl.imageUrl + widget.history.media,
                  fit: BoxFit.cover,
                ))),
      );
    } else {
      return const Center(child: Text('No Image Available'));
    }
  }

  void showImage(image) {
    showDialog(
        barrierDismissible: true,
        context: buildContext,
        builder: (BuildContext context) {
          dialogContext = context;
          return WillPopScope(
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.network(
                    AppUrl.imageUrl + widget.history.media,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onWillPop: () async => true);
        });
  }
}
