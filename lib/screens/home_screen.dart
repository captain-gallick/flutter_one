// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/department.dart';
import 'package:flutter_app_one/data_models/my_services.dart';
import 'package:flutter_app_one/screens/book_service.dart';
import 'package:flutter_app_one/screens/search_screen.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';

import 'book_track_screen.dart';
import 'booking_history.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'splash_screen.dart';

import 'package:flutter_app_one/utils/globals.dart' as globals;

int depId = -1;

List<Department> departments = [];
List<MyServices> services = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //late AnimationController animationController;
  int showDeps = -1;

  late double width;
  bool loggedIn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getDepartments());
    /* animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250)); */
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  final double maxSlide = 400.0;
  final CarouselController controller = CarouselController();

  /* void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse(); */

  //bool _canBeDragged = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.of(context).pop();
          } else {
            if (showDeps == 2) {
              setState(() {
                showDeps = -1;
                getDepartments();
              });
            } else {
              if (loggedIn) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookTrackScreen()));
              } else {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            }
          }
          return false;
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Scaffold(
                key: _scaffoldKey,
                drawer: Drawer(
                  child: getDrawer(),
                ),
                body: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                              // Navigator.of(context)
                              //     .push(createRoute(const SlliderScreen()));
                            },
                            icon: Image.asset('assets/images/menu.png')),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 150,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset('assets/images/bell.png')),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        (showDeps == -1 || showDeps == 1)
                            ? const Text(
                                'Select a Department',
                                style: TextStyle(fontSize: 30.0),
                              )
                            : const Text(
                                'Book a Service',
                                style: TextStyle(fontSize: 30.0),
                              ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchScreen()));
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.grey),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    'Search',
                                  ),
                                  Icon(Icons.search)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    (showDeps == -1)
                        ? Container()
                        : (showDeps == 1)
                            ? getDepartmentList()
                            // ignore: prefer_const_constructors
                            : CarouselWithIndicatorDemo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDrawer() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: const Text("Booking History",
                    style: TextStyle(fontSize: 20.0)),
                onTap: () {
                  if (loggedIn) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BookingHistoryScreen()));
                  } else {
                    globals.gotoBookingHistory = true;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: const Text("Profile", style: TextStyle(fontSize: 20.0)),
                onTap: () {
                  if (loggedIn) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()));
                  } else {
                    globals.gotoProfile = true;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: (loggedIn
                  ? ListTile(
                      title: const Text("Logout",
                          style: TextStyle(fontSize: 20.0)),
                      onTap: () {
                        UserPreferences prefs = UserPreferences();
                        prefs.removeUser();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MySplashScreen()));
                      },
                    )
                  : ListTile(
                      title:
                          const Text("Login", style: TextStyle(fontSize: 20.0)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                    )),
            ),
          ]),
        )
      ],
    );
  }

  getLoginStatus() async {
    String token = '';
    await UserPreferences().getUser().then((value) {
      token = value.token;
    });
    if (token == '') {
      loggedIn = false;
    } else {
      loggedIn = true;
    }
  }

  getDepartments() async {
    showLoader();
    try {
      departments.clear();
      final Response response = await get(Uri.parse(AppUrl.departments));

      if (jsonDecode(response.body).toString().contains('data')) {
        List<dynamic> list = jsonDecode(response.body)['data'];
        for (int i = 0; i < list.length; i++) {
          departments.add(Department.fromJson(list[i]));
        }
        setState(() {
          showDeps = 1;
        });
        //getCarousal();
      } else {}
      //print('hello:' + departments.length.toString());
    } catch (e) {}
    Navigator.pop(dialogContext);
    getLoginStatus();
  }

  getServicesByDepartment() async {
    showLoader();
    try {
      services.clear();
      final Response response =
          await get(Uri.parse(AppUrl.servicesByDepartment + depId.toString()));

      if (jsonDecode(response.body).toString().contains('data')) {
        List<dynamic> list = jsonDecode(response.body)['data'];
        for (int i = 0; i < list.length; i++) {
          services.add(MyServices.fromJson(list[i]));
        }
        setState(() {
          showDeps = 2;
          Navigator.pop(dialogContext);
        });
        //getCarousal();
      } else {}
      return services;
    } catch (e) {}
  }

  late BuildContext dialogContext;

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

  getDepartmentList() {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: departments.length,
          itemBuilder: (context, position) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  depId = int.parse(departments[position].id);
                  showDeps = -1;
                  getServicesByDepartment();
                });
              },
              child: Card(
                shadowColor: Colors.blueAccent,
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.network(
                            AppUrl.baseDomain + departments[position].icon),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        departments[position].name,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
  const CarouselWithIndicatorDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    if (services.isEmpty) {
      return const Center(
          child: Text('No services available for this department.'));
    } else {
      return Expanded(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Builder(
                builder: (context) {
                  return CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                        height: 450.0,
                        enlargeCenterPage: false,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: services
                        .map((item) => GestureDetector(
                              onTap: () async {
                                checkLogin(item);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 5.0),
                                elevation: 10.0,
                                shadowColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: SizedBox(
                                  height: 400,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              AppUrl.baseDomain + item.image,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40.0,
                                        ),
                                        Text(
                                          item.title,
                                          style:
                                              const TextStyle(fontSize: 25.0),
                                        ),
                                        const SizedBox(
                                          height: 40.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
            // const Flexible(
            //   flex: 1,
            //   child: SizedBox(
            //     height: 60.0,
            //   ),
            // ),
            Flexible(
              flex: 1,
              child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: services.asMap().entries.map((entry) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.green
                                    : Colors.white)
                                .withOpacity(
                                    _current == entry.key ? 1.0 : 0.4)),
                      );
                    }).toList()),
              ),
            )
          ],
        ),
      );
    }
  }

  checkLogin(item) async {
    String token = '';
    await UserPreferences().getUser().then((value) => {token = value.token});
    if (token == '') {
      globals.depId = depId;
      globals.item = item;
      globals.gotoBookService = true;
      gotoLogin();
    } else {
      gotoBookService(item);
    }
  }

  gotoBookService(item) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BookServiceScreen(
                  depId: depId,
                  serviceName: item.title,
                  vibhag: item.vibhag,
                  serviceId: item.id,
                )));
  }

  gotoLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
