import 'package:flutter/material.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/my_bookings.dart';
import 'package:flutter_app_one/screens/booking_history.dart';
import 'package:flutter_app_one/screens/contact_screen.dart';
import 'package:flutter_app_one/utils/app_colors.dart';

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
                                      ((widget.history.status == '1')
                                          ? 'Status: OPEN'
                                          : 'Status: CLOSED'))
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'TRACK',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.0),
                                    )),
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ContactScreen(widget.history)),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      'CONTACT',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.0),
                                    )),
                              ]),
                        ),
                      )
                    ]),
              ),
            )));
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
