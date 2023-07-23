import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waste_time/controllers/schedule_controller.dart';
import 'package:waste_time/models/shortestModel.dart';
import 'package:waste_time/pages/customer/schedule/company_selection.dart';
import 'package:waste_time/pages/customer/schedule/waste_estimation_screen.dart';
import 'package:waste_time/widgets/input_field_withouticon.dart';

import '../../../controllers/mainController.dart';
import '../../../models/company_info.dart';
import '../../../util.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MapSample extends StatefulWidget {
  MapSample({required this.companies, Key? key}) : super(key: key);
  List<CompanyInfor> companies;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  Set<Marker> marks = {};
  final appCtr = Get.find<MainAppController>();
  final sheduleContrler = Get.put(ScheduleController());
  List<ShortestModel> companyDist = [];

  Future<Uint8List> getImages() async {
    String path = 'assets/images/bin.png';
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: 120);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  organiseCompanyLocations() async {
    Uint8List markIcons = await getImages();
    print('iiiiiiiiiiiiiiiiiiiiiiiiii');

    for (CompanyInfor company in widget.companies) {
      setState(() {
        marks.add(Marker(
          markerId: MarkerId(company.id),
          position:
              LatLng(company.location.latitude, company.location.longitude),
          icon: BitmapDescriptor.fromBytes(markIcons),
          infoWindow: InfoWindow(
            title: company.name,
          ),
        ));
      });
    }
    print('Done!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }

  double calculateDistance(
    LatLng one,
  ) {
    print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    print('Lat: ${one.latitude} Long: ${one.longitude} ');

    LatLng two =
        LatLng(appCtr.pos.value!.latitude, appCtr.pos.value!.longitude);
    var dd = Geolocator.distanceBetween(
        one.latitude, one.longitude, two.latitude, two.longitude);
    return dd;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  var lines;
  @override
  void initState() {
    super.initState();
    print('oooooooooooooooooooooooooooooooooo');
    print(widget.companies);

    if (appCtr.pos.value != null) {
      organiseCompanyLocations();
      calculateShortestDistance();
    }

    appCtr.pos.listen((position) {
      if (position != null) {
        print('oo333333333333333333333333333333333333333');
      }
    });

    // organiseUserLocation();

    // fetch available companies
    // getCompanies();
  }

  calculateShortestDistance() async {
    for (CompanyInfor company in widget.companies) {
      companyDist.add(ShortestModel(
          company: company,
          distance: calculateDistance(
              LatLng(company.location.latitude, company.location.latitude))));
    }

    print('ddddddddddddddddddddddddddd');
    print(companyDist);
    companyDist.sort((a, b) => (b.distance).compareTo(a.distance));
    print(companyDist);
    // print(distances.sort((a, b){});?
    // distances.last; -> the shortest
    ShortestModel shortestDist = companyDist.last;
    print(shortestDist);
    appCtr.setSelectedCompany = shortestDist.company;
    await sheduleContrler.updateSelectedWasteCompany(shortestDist.company.name);
    await sheduleContrler.updateCompanyId(shortestDist.company.id);
  }

  computePath() async {
    print('ooooooooooooooooooooooo');
    GoogleMapPolyline googleMapPolyline =
        GoogleMapPolyline(apiKey: "AIzaSyCN36hKY6ze8vC3QpCQWV8qpQ1zLHoAQs0");

    lines = await googleMapPolyline.getCoordinatesWithLocation(
        origin: const LatLng(0.3619747744049111, 32.64982994645834),
        destination: LatLng(
          appCtr.pos.value!.latitude,
          appCtr.pos.value!.longitude,
        ),
        mode: RouteMode.driving);
    print(lines);
    setState(() {});
  }

  // organiseUserLocation() async {
  //   currentLocation = await determinePosition();
  //   print('llllllllllllllllllllllllllllllll');
  //   setState(() {});
  //   moveCamera(currentLocation);
  // }

  getCompanies() async {
    await schedulerManager.showCompanies();
  }

  moveCamera(Position? position) async {
    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position!.latitude, position.longitude)));
  }

  Set<Marker> mrks = {};

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
              onTap: (a) {
                print(a);

                setState(() {
                  mrks.add(Marker(markerId: const MarkerId('er'), position: a));
                });
              },
              markers: marks,
              // polylines: Set.from(lines),
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
                      "Nearest waste Company",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Obx(() {
                      return appCtr.selectedCompany.value != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                height: 54,
                                width: size.width - 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    // color: Colors.red,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      appCtr.selectedCompany.value!.name,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox();
                    }),
                    // InputFieldWithoutIcon(
                    //   controller: scheduler.wasteCompanyController,
                    //   labelText: "Select Waste Company",
                    //   x: true,
                    //   tap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => CompanySelection(
                    //               companies: scheduler.companies),
                    //         ));
                    //   },
                    // ),

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
                                Navigator.push(context, MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                  return WasteEstimationScreen(
                                      latitude: appCtr.pos.value!.latitude,
                                      longitude: appCtr.pos.value!.longitude,
                                      isDomesticSelected:
                                          scheduler.isDomesticSelected,
                                      isPlasticSelected:
                                          scheduler.isPlasticSelected,
                                      isMedicalSelected:
                                          scheduler.isMedicalSelected,
                                      isIndustrialSelected:
                                          scheduler.isIndustrialSelected);
                                }));
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
