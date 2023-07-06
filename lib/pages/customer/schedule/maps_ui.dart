import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waste_time/controllers/schedule_controller.dart';
import 'package:waste_time/pages/customer/schedule/company_selection.dart';
import 'package:waste_time/pages/customer/schedule/waste_estimation_screen.dart';
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
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: Column(
                  children: [
                    const Text(
                      "Select type of waste Company",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
                    ),

                    // choose the waste type
                    scheduler.wasteCompanyController.text.isNotEmpty
                        ? SizedBox(
                            height: size.height * 0.18,
                            width: size.width * 0.9,
                            child: Column(
                              children: [
                                const Text(
                                  "Select type of waste",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          scheduler.isDomesticSelected =
                                              !scheduler.isDomesticSelected;
                                        });
                                      },
                                      icon: scheduler.isDomesticSelected
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.whatshot_rounded),
                                      label: const Text(
                                        "Domestic",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              scheduler.isDomesticSelected
                                                  ? Colors.red
                                                  : const Color.fromARGB(
                                                      255, 0, 140, 255)),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          scheduler.isPlasticSelected =
                                              !scheduler.isPlasticSelected;
                                        });
                                      },
                                      icon: scheduler.isPlasticSelected
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.radar),
                                      label: const Text(
                                        "Plastic",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              scheduler.isPlasticSelected
                                                  ? Colors.red
                                                  : const Color.fromARGB(
                                                      255, 0, 140, 255)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          scheduler.isMedicalSelected =
                                              !scheduler.isMedicalSelected;
                                        });
                                      },
                                      icon: scheduler.isMedicalSelected
                                          ? const Icon(Icons.check)
                                          : const Icon(
                                              Icons.medication_liquid_rounded),
                                      label: const Text(
                                        "Medical Waste",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              scheduler.isMedicalSelected
                                                  ? Colors.red
                                                  : const Color.fromARGB(
                                                      255, 0, 140, 255)),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          scheduler.isIndustrialSelected =
                                              !scheduler.isIndustrialSelected;
                                        });
                                      },
                                      icon: scheduler.isIndustrialSelected
                                          ? const Icon(Icons.check)
                                          : const Icon(
                                              Icons.dirty_lens_outlined),
                                      label: const Text(
                                        "Industrial Waste",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              scheduler.isIndustrialSelected
                                                  ? Colors.red
                                                  : const Color.fromARGB(
                                                      255, 0, 140, 255)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),

                    // submit button
                    scheduler.wasteCompanyController.text.isNotEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                elevation: 3,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 15)),
                            onPressed: () {
                              if (scheduler.isDomesticSelected == true ||
                                  scheduler.isPlasticSelected == true ||
                                  scheduler.isMedicalSelected == true ||
                                  scheduler.isIndustrialSelected == true) {
                                // move to screen for calculating the watse weight
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          WasteEstimationScreen(
                                              latitude:
                                                  currentLocation.latitude,
                                              longitude:
                                                  currentLocation.longitude,
                                              isDomesticSelected:
                                                  scheduler.isDomesticSelected,
                                              isPlasticSelected:
                                                  scheduler.isPlasticSelected,
                                              isMedicalSelected:
                                                  scheduler.isMedicalSelected,
                                              isIndustrialSelected: scheduler
                                                  .isIndustrialSelected),
                                    ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Please Select waste Type",
                                          style: TextStyle(color: Colors.black),
                                        )));
                              }
                            },
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ))
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
