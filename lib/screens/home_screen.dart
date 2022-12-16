import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/department.dart';
import 'package:flutter_app_one/data_models/my_services.dart';
import 'package:flutter_app_one/screens/book_service.dart';
import 'package:flutter_app_one/screens/contact_screen.dart';
import 'package:flutter_app_one/screens/jalprahari_registration.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/network_connecttion.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:html/parser.dart';

import 'booking_history.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'splash_screen.dart';

import 'package:flutter_app_one/utils/globals.dart' as globals;

int depId = -1;

List<Department> departments = [];
List<Department> mDepartments = [];
List<MyServices> services = [];
List<MyServices> mServices = [];

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
  int showThis = 1;
  String selectedDep = 'Name';

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
                showThis = 1;
                getDepartments();
              });
            } else {
              if (loggedIn) {
                SystemNavigator.pop();
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }
            }
          }
          return false;
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: AppColors.backgroundcolor,
              child: Scaffold(
                key: _scaffoldKey,
                drawer: Drawer(
                  backgroundColor: AppColors.backgroundcolor,
                  child: getDrawer(),
                ),
                body: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: 20,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                  // Navigator.of(context)
                                  //     .push(createRoute(const SlliderScreen()));
                                },
                                icon: Image.asset('assets/images/menu.png')),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 150,
                            ),
                          ),
                        ),
                        /* const SizedBox(
                          width: 20.0,
                        ), */
                        Positioned(
                            top: 20,
                            right: 10,
                            child: IconButton(
                              tooltip: 'Call Customer Care',
                              onPressed: () {
                                url_launcher.launch("tel://18003094747");
                              },
                              icon: Image.asset('assets/images/call_icon.png'),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          (showDeps == -1 || showDeps == 1)
                              ? const Text(
                                  'Select a Service',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: AppColors.appTextDarkBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const Flexible(
                                  child: Text(
                                    'Click the Service you want',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.appTextDarkBlue),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: !(showDeps == -1 || showDeps == 1),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    selectedDep,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.appTextDarkBlue),
                                  )),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Department',
                                    style: TextStyle(
                                        color: AppColors.appTextDarkBlue),
                                  )),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.appLightBlue,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            shape: BoxShape.rectangle),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: TextField(
                              onChanged: (value) {
                                searchList(value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle:
                                    TextStyle(color: AppColors.lightTextColor),
                                border: InputBorder.none,
                                isDense: true,
                                icon: Icon(
                                  Icons.search,
                                  color: AppColors.appTextDarkBlue,
                                ),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    (showDeps == -1)
                        ? getSkeleton(showThis)
                        : (showDeps == 1)
                            ? getDepartmentList()
                            : getServicesList(),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.keyboard_double_arrow_down,
                        color: AppColors.appGreen,
                      ),
                    ),
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
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.appTextDarkBlue)),
                onTap: () {
                  Navigator.of(context).pop();
                  if (loggedIn) {
                    Navigator.push(
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
            Container(
                height: 1, color: const Color.fromARGB(255, 224, 224, 224)),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: const Text("Profile",
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.appTextDarkBlue)),
                onTap: () {
                  Navigator.of(context).pop();
                  if (loggedIn) {
                    Navigator.push(
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
            Container(
                height: 1, color: const Color.fromARGB(255, 224, 224, 224)),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Jalprahari",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: AppColors.appTextDarkBlue)),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (loggedIn) {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const JalprahariRegScreen()));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("• Registration",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppColors.appTextDarkBlue)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (loggedIn) {
                          Navigator.pop(context);
                          downloadCertificate();
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("• Download Certificate",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppColors.appTextDarkBlue)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                height: 1, color: const Color.fromARGB(255, 224, 224, 224)),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: (loggedIn
                  ? ListTile(
                      title: const Text("Logout",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: AppColors.appTextDarkBlue)),
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
                      title: const Text("Login",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: AppColors.appTextDarkBlue)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                    )),
            ),
            Container(
                height: 1, color: const Color.fromARGB(255, 224, 224, 224)),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: const Text("Contact Us",
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.appTextDarkBlue)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactScreen()));
                },
              ),
            ),
          ]),
        )
      ],
    );
  }

  downloadCertificate() async {
    showLoader();
    String token = '';
    await UserPreferences().getUser().then((value) => {token = value.token});
    try {
      services.clear();
      final Response response =
          await get(Uri.parse(AppUrl.jalprahari), headers: {'token': token});

      if (jsonDecode(response.body).toString().contains('data')) {
        log(response.body);
        var url = jsonDecode(response.body)['data'];
        log(url);
        url_launcher.launch(Uri.parse(url).toString());
        Navigator.pop(context);
      } else {}
    } catch (e) {}
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
    NetworkCheckUp().checkConnection().then((value) async {
      if (value) {
        //showLoader();
        try {
          departments.clear();
          mDepartments.clear();
          final Response response = await get(Uri.parse(AppUrl.departments));
          log(response.body);
          if (jsonDecode(response.body).toString().contains('data')) {
            List<dynamic> list = jsonDecode(response.body)['data'];
            for (int i = 0; i < list.length; i++) {
              departments.add(Department.fromJson(list[i]));
              mDepartments.add(Department.fromJson(list[i]));
            }
            setState(() {
              showDeps = 1;
            });
            //getCarousal();
          } else {}
          //print('hello:' + departments.length.toString());
        } catch (e) {}
        //Navigator.pop(dialogContext);
        getLoginStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please connect to internet."),
        ));
      }
    });
  }

  getServicesByDepartment() async {
    //showLoader();
    try {
      services.clear();
      mServices.clear();
      final Response response =
          await get(Uri.parse(AppUrl.servicesByDepartment + depId.toString()));

      if (jsonDecode(response.body).toString().contains('data')) {
        log(response.body);
        List<dynamic> list = jsonDecode(response.body)['data'];
        for (int i = 0; i < list.length; i++) {
          services.add(MyServices.fromJson(list[i]));
          mServices.add(MyServices.fromJson(list[i]));
        }
        setState(() {
          showDeps = 2;
          //Navigator.pop(dialogContext);
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

  searchList(String value) {
    if (showDeps == 1) {
      setState(() {
        mDepartments.clear();
        for (int i = 0; i < departments.length; i++) {
          if (departments[i].name.toLowerCase().contains(value.toLowerCase())) {
            mDepartments.add(departments[i]);
          }
        }
      });
    } else {
      setState(() {
        mServices.clear();
        for (int i = 0; i < services.length; i++) {
          if (services[i].title.toLowerCase().contains(value.toLowerCase())) {
            log('matches: ' + (i + 1).toString());
            mServices.add(services[i]);
          }
        }
      });
    }
  }

  getDepartmentList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            showDeps = -1;
            getDepartments();
          });
        },
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: mDepartments.length,
            itemBuilder: (context, position) {
              return GestureDetector(
                onTap: () {
                  NetworkCheckUp().checkConnection().then((value) {
                    if (value) {
                      setState(() {
                        depId = int.parse(mDepartments[position].id);
                        showDeps = -1;
                        showThis = 2;
                        selectedDep = mDepartments[position].name;
                        getServicesByDepartment();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please connect to internet."),
                      ));
                    }
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: AppColors.appAvatarBG,
                          child: Image.network(
                            AppUrl.baseDomain + mDepartments[position].icon,
                            width: 55,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        mDepartments[position].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18.0, color: AppColors.appTextDarkBlue),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  getSkeleton(int num) {
    if (num == 1) {
      return getDepartmentSkeleton();
    } else {
      return getServiceSkeleton();
    }
  }

  getServicesSkeleton() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
      elevation: 10.0,
      shadowColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              const Expanded(
                child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(width: 200, height: 80)),
              ),
              const SizedBox(
                height: 40.0,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                    height: 16,
                    width: 100,
                    alignment: AlignmentDirectional.center,
                    borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(
                height: 20,
              ),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: 3,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width,
                    )),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  getDepartmentSkeleton() {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: 2,
          itemBuilder: (context, position) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Flexible(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 80, height: 80)),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: SkeletonLine(
                    style: SkeletonLineStyle(
                        height: 16,
                        width: 100,
                        alignment: AlignmentDirectional.center,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            );
          }),
    );
  }

  getServiceSkeleton() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, position) {
        return Column(
          children: [
            Container(
              height: 5.0,
              color: Colors.grey.shade200,
            ),
            ListTile(
              title: SkeletonLine(
                style: SkeletonLineStyle(
                    height: 16,
                    width: 100,
                    borderRadius: BorderRadius.circular(8)),
              ),
              subtitle: SkeletonLine(
                style: SkeletonLineStyle(
                    height: 16,
                    width: 70,
                    borderRadius: BorderRadius.circular(8)),
              ),
              trailing: const SkeletonAvatar(
                  style: SkeletonAvatarStyle(width: 20, height: 20)),
            ),
          ],
        );
      },
    );
  }

  getServicesList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            showDeps = -1;
            showThis = 2;
            getServicesByDepartment();
          });
        },
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: mServices.length,
          itemBuilder: (context, position) {
            return GestureDetector(
                onTap: () async {
                  checkLogin(mServices[position]);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 235, 235, 235), width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: AppColors.appLightBlue,
                    elevation: 5,
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.appAvatarBG,
                                  radius: 50,
                                  child: Image.network(
                                    AppUrl.baseDomain +
                                        mServices[position].image,
                                    width: 55,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mServices[position].title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: AppColors.appTextDarkBlue),
                                        ),
                                        const Text('Book Now',
                                            style: TextStyle(
                                                color: AppColors.appGreen)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /* subtitle: const Text('Book Now',
                                style: TextStyle(color: AppColors.appGreen)), */
                            /* leading: CircleAvatar(
                                backgroundColor: AppColors.appAvatarBG,
                                child: Image.network(
                                  AppUrl.baseDomain + services[position].image,
                                  width: 55,
                                ),
                              ) */

                            /* ClipRRect(
                              child: SizedBox(
                                height: 70.0,
                                width: 70.0,
                                child: getImage(position),
                              ),
                            ), */
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
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
      NetworkCheckUp().checkConnection().then((value) {
        if (value) {
          gotoBookService(item);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please connect to internet."),
          ));
        }
      });
    }
  }

  gotoBookService(item) {
    Navigator.push(
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
                                        /* Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  showDescr(item);
                                                },
                                                icon: const Icon(Icons
                                                    .info_outline_rounded))), */
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
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                parse(item.description)
                                                    .body!
                                                    .text,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: GestureDetector(
                                              onTap: () {
                                                showDescr(item);
                                              },
                                              child: const Text(
                                                'Read more',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blue,
                                                ),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 20,
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
      NetworkCheckUp().checkConnection().then((value) {
        if (value) {
          gotoBookService(item);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please connect to internet."),
          ));
        }
      });
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

  void showDescr(item) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: Dialog(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                          item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            AppUrl.baseDomain + item.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Html(data: item.description)
                        //Text(_parseHtmlString(item.description)),
                      ],
                    ),
                  ),
                ),
              ),
              onWillPop: () async => true);
        });
  }
}
