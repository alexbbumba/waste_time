import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waste_time/controllers/mainController.dart';
import 'package:waste_time/controllers/schedule_controller.dart';

import '../util.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterLocationView extends StatefulWidget {
  RegisterLocationView({this.location, Key? key}) : super(key: key);
  Position? location;

  @override
  State<RegisterLocationView> createState() => _RegisterLocationView();
}

class _RegisterLocationView extends State<RegisterLocationView> {
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  Position? currentLocation;

  // Set<Marker> marks = {};
  final appCtr = Get.find<MainAppController>();

  @override
  void initState() {
    super.initState();
    currentLocation = widget.location;
  }

  moveCamera(GoogleMapController ctr) async {
    Position? pos = appCtr.pos.value;
    if (pos == null) {
      return;
    }

    // GoogleMapController ctr = await googleMapController.future;
    ctr.animateCamera(
        CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)));

    setState(() {
      mrks.add(Marker(
          markerId: const MarkerId('companyLocation'),
          position: LatLng(pos.latitude, pos.longitude)));
    });
  }

  Set<Marker> mrks = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GetBuilder<ScheduleController>(
            init: ScheduleController(),
            builder: (scheduler) {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  extendBody: false,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                      elevation: 0,
                      leading: null,
                      title: const Text('Tap to select company location')),
                  body: GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0.0, 0.0),
                      zoom: 14.0,
                    ),
                    mapType: MapType.normal,
                    onMapCreated: moveCamera,
                    onTap: (a) {
                      setState(() {
                        mrks.add(Marker(
                            markerId: const MarkerId('companyLocation'),
                            position: a));
                      });
                    },
                    markers: mrks,
                  ),
                  floatingActionButton: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context, mrks.last);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        side: const BorderSide(
                          width: 5.0,
                          color: Colors.black38,
                          style: BorderStyle.solid,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Choose current location",
                        style: GoogleFonts.lato(
                          color: Colors.black38,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
        Obx(() {
          bool loading = appCtr.isLoading.value;
          return loading
              ? Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.grey.withOpacity(0.4),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox();
        })
      ],
    );
  }
}
