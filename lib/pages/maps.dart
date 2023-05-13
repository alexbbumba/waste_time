import 'dart:async';
import 'dart:ffi';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController googleMapController;
  void _currentLocation() async {}
  int type = -1;
  String wasteType = '';
  String placeOfResidence = 'Kikoni';
  String once = 'One time';
  String monthly = 'Monthly';
  String domestic = 'Domestic Waste';
  String medical = 'Medical Waste';
  String plastic = 'Plastics';
  String industrial = 'Indsutrial Waste';

  void _setMoreUserData() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width:
                MediaQuery.of(context).size.width, // or use fixed size like 200
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(0.3476, 32.5825),
                zoom: 14.0,
              ),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
            ),
          ),
          //text to do the selections.
          Text('Select the Service'),
          // a row that includes the selections
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // the elevated button for domestic waste.
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wasteType = 'Domestic Waste';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.grey,
                      shadowColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      side: BorderSide(
                        width: 5.0,
                        color: Colors.black38,
                        style: type == 0 ? BorderStyle.solid : BorderStyle.none,
                      )),
                  child: Text('DOMESTIC')),

              // the elevated button for medical waste.
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wasteType = 'Medical Waste';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.grey,
                      shadowColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      side: BorderSide(
                        width: 5.0,
                        color: Colors.black38,
                        style: type == 0 ? BorderStyle.solid : BorderStyle.none,
                      )),
                  child: Text('MEDICAL'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //the elevated button for Industrial Waste
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wasteType = 'Industrial Waste';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.grey,
                      shadowColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      side: BorderSide(
                        width: 5.0,
                        color: Colors.black38,
                        style: type == 0 ? BorderStyle.solid : BorderStyle.none,
                      )),
                  child: Text('INDUSTRIAL')),

              // the elevated button for plastic waste;
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wasteType = 'Plastcic Waste';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.grey,
                      shadowColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      side: BorderSide(
                        width: 5.0,
                        color: Colors.black38,
                        style: type == 0 ? BorderStyle.solid : BorderStyle.none,
                      )),
                  child: Text('PLASTIC'))
            ],
          ),
          //button to innitiate the trucks
          ElevatedButton(
              onPressed: () async {
                final User? user = FirebaseAuth.instance.currentUser;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .set({'wasteType': wasteType}, SetOptions(merge: true));
              },
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: Colors.grey,
                  shadowColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  side: BorderSide(
                    width: 5.0,
                    color: Colors.black38,
                    style: type == 0 ? BorderStyle.solid : BorderStyle.none,
                  )),
              child: Text('Tap to Initiate Truck')),
        ],
      )),
    ));
  }
  // floatingActionButton: FloatingActionButton.extended(
  //       onPressed: () async {
  //         Position position = await _determinePosition();
  //         googleMapController
  //             .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //           target: LatLng(position.latitude, position.longitude),
  //           zoom: 14.0,
  //         )));
  //         setState(() {});
  //       },
  //       label: const Text('Current Location'),
  //       icon: const Icon(Icons.location_history),
  //     ),

  Future<Position> _determinePosition() async {
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
}
