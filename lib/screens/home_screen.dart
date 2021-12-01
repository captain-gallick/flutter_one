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
import 'package:flutter_app_one/screens/slider_screen.dart';
import 'package:http/http.dart';

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
  late AnimationController animationController;
  int showDeps = -1;

  late double width;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getDepartments());
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  final double maxSlide = 400.0;
  final CarouselController controller = CarouselController();

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  //bool _canBeDragged = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (showDeps == 2) {
            setState(() {
              showDeps = -1;
              getDepartments();
            });
          } else {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          return false;
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Scaffold(
                key: _scaffoldKey,
                drawer: const SlliderScreen(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const <Widget>[
                        Text(
                          'Book A Service',
                          style: TextStyle(fontSize: 30.0),
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
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Text(
                    departments[position].name,
                    style: const TextStyle(fontSize: 22.0),
                  ),
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.chevron_right_rounded))
                ],
              ),
            ),
          ),
        );
      },
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
    return Column(
      children: [
        Builder(
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
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookServiceScreen(
                                      depId: depId,
                                      serviceName: item.title,
                                      vibhag: item.vibhag)));
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
                                      borderRadius: BorderRadius.circular(20.0),
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
                                    style: const TextStyle(fontSize: 25.0),
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
        const SizedBox(
          height: 60.0,
        ),
        Align(
            alignment: Alignment.bottomCenter,
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
                        color: (Theme.of(context).brightness == Brightness.light
                                ? Colors.green
                                : Colors.white)
                            .withOpacity(_current == entry.key ? 1.0 : 0.4)),
                  );
                }).toList()))
      ],
    );
  }
}
