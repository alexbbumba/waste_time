import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waste_time/controllers/schedule_controller.dart';
import 'package:waste_time/pages/customer/schedule/company_selection.dart';
import 'package:waste_time/widgets/input_field_withouticon.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  Position currentLocation = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.timestamp(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services are Disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission == await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission Denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied permanently');
    }
    Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  void initState() {
    super.initState();
    determinePosition().then((userlocation) {
      setState(() {
        currentLocation = userlocation;
      });
      moveCamera(currentLocation);
    });

    // fetch available companies
    getCompanies();
  }

  getCompanies() async {
    await schedulerManager.showCompanies();
  }

  moveCamera(Position position) async {
    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<ScheduleController>(
        init: ScheduleController(),
        builder: (scheduler) {
          return Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: SizedBox(
                height: 20,
                width: 10,
                child: Stack(
                  children: [
                    const Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)))
                  ],
                ),
              ),
            ),
            body: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 14.0,
              ),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController.complete(controller);
              },
            ),
            bottomNavigationBar: Container(
              height: size.height * 0.45,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 213, 233, 243),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: [
                    InputFieldWithoutIcon(
                      controller: scheduler.wasteCompanyController,
                      labelText: "Select Waste Company",
                      x: true,
                      tap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanySelection(
                                  companies: scheduler.companies),
                            ));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
