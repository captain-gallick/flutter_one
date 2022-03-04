import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_app_one/utils/globals.dart' as globals;

class MarkLocationScreen extends StatefulWidget {
  const MarkLocationScreen({Key? key}) : super(key: key);

  @override
  _MarkLocationScreenState createState() => _MarkLocationScreenState();
}

class _MarkLocationScreenState extends State<MarkLocationScreen> {
  late CameraPosition initialLoaction =
      const CameraPosition(target: LatLng(27, 78), zoom: 14.47);
  late Marker locationMarker = const Marker(markerId: MarkerId('position'));
  late GoogleMapController _mapController;
  late BuildContext waitDialogContext, buildContext;
  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          onTap: _addMarker,
          initialCameraPosition: initialLoaction,
          mapType: MapType.normal,
          markers: {locationMarker},
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'MARK LOCATION',
          label: const Text('DONE'),
          icon: const Icon(Icons.thumb_up),
          onPressed: () {
            try {
              Navigator.pop(context);
            } catch (e) {
              log(e.toString());
            }
          },
        ),
      ),
    );
  }

  getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    double? lat = _locationData.latitude;
    double? lng = _locationData.longitude;
    LatLng latLng = LatLng(lat ?? 0, lng ?? 0);

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18.0)));
    _addMarker(latLng);

    //await UserPreferences().setLocation(lat.toString(), lng.toString());
  }

  _addMarker(LatLng pos) async {
    //showWaitLoader();
    await UserPreferences()
        .setLocation(pos.latitude.toString(), pos.longitude.toString());
    globals.locationUpdated = true;
    try {
      setState(() {
        locationMarker = Marker(
          markerId: const MarkerId('position'),
          infoWindow: const InfoWindow(title: 'Marked location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
      });
    } catch (e) {
      log(e.toString());
    }

    //Navigator.pop(waitDialogContext);
  }

  void showWaitLoader() {
    showDialog(
        barrierDismissible: false,
        context: buildContext,
        builder: (BuildContext context) {
          waitDialogContext = context;
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
                          child: Text('Please wait...')),
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }
}
