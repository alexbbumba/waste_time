import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:waste_time/controllers/schedule_controller.dart';

class WasteEstimationScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isDomesticSelected;
  final bool isPlasticSelected;
  final bool isMedicalSelected;
  final bool isIndustrialSelected;
  const WasteEstimationScreen(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.isDomesticSelected,
      required this.isPlasticSelected,
      required this.isMedicalSelected,
      required this.isIndustrialSelected});

  @override
  State<WasteEstimationScreen> createState() => _WasteEstimationScreenState();
}

class _WasteEstimationScreenState extends State<WasteEstimationScreen> {
  double baselineWeight = 0.0;
  bool isBaseLineCaptured = false;
  double estimatedWeight = 0.0;
  bool isCaptured = false;
  AccelerometerEvent accelerometerEvent = AccelerometerEvent(0.0, 0.0, 0.0);
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  void startSensorDataCollection() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      // Store the latest accelerometer event
      setState(() {
        accelerometerEvent = event;
      });

      // Process accelerometer data and estimate waste weight
      estimateWasteWeight(event.x, event.y, event.z);
    });
  }

  void stopSensorDataCollection() {
    // Cancel the accelerometer subscription to stop collecting data
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  void estimateWasteWeight(double x, double y, double z) {
    // Filter and analyze the sensor data if needed

    // Calculate the magnitude of the acceleration vector
    double magnitude = sqrt(x * x + y * y + z * z);

    // Estimate the waste weight based on the magnitude and baseline weight
    estimatedWeight = magnitude - baselineWeight;

    // boolean to confirm that the weight has been captured
    isCaptured = true;

    // Update the UI with the estimated weight
    setState(() {});

    // Stop data collection if estimated weight is obtained
    if (estimatedWeight > 0) {
      stopSensorDataCollection();
    }
  }

  void calibrateBaselineWeight() {
    // Trigger the calibration process and set the baseline weight
    setState(() {
      baselineWeight = estimatedWeight;
      isBaseLineCaptured = true;
    });
  }

  String domestic = "";
  String plastic = "";
  String medical = "";
  String industrial = "";

  @override
  void initState() {
    super.initState();
    confirmWateTypes();
    // get User latitude and longitude
  }

  confirmWateTypes() {
    setState(() {
      widget.isDomesticSelected ? domestic = "domestic" : domestic = " ";
      widget.isPlasticSelected ? plastic = "plastic" : plastic = " ";
      widget.isMedicalSelected ? medical = "medical" : medical = " ";
      widget.isIndustrialSelected
          ? industrial = "industrial"
          : industrial = " ";
    });
  }

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<ScheduleController>(
        init: ScheduleController(),
        builder: (submitSchdule) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Waste Estimation'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.5,
                    width: size.width * 0.8,
                    child: InkWell(
                      onTap: () {
                        startSensorDataCollection();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: const Center(
                            child: Text(
                          "Press to start waste estimation",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  Text(
                    'Estimated Weight: $estimatedWeight',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 16.0),
                  isCaptured
                      ? ElevatedButton(
                          onPressed: calibrateBaselineWeight,
                          child: const Text('Calibrate Baseline Weight'),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 15,
                  ),
                  isBaseLineCaptured
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 17)),
                          onPressed: () async {
                            // submit button
                            await submitSchdule.scheduleWastePickup(
                                context,
                                user!.uid,
                                submitSchdule.getCompanyId().toString(),
                                widget.latitude,
                                widget.longitude,
                                domestic,
                                plastic,
                                medical,
                                industrial,
                                baselineWeight,
                                "incomplete");
                          },
                          child: const Text(
                            "Schedule",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))
                      : const SizedBox()
                ],
              ),
            ),
          );
        });
  }
}
