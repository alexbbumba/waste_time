import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste_time/models/company_info.dart';

final schedulerManager = Get.put(ScheduleController());

class ScheduleController extends GetxController {
  final wasteCompanyController = TextEditingController();
  final wasteTypeController = TextEditingController();
  String selectedCompanyId = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<CompanyInfor> companies = [];

  Future<List<CompanyInfor>> fetchCompanies() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('company').get();
    return snapshot.docs
        .map((e) => CompanyInfor.fromDocumentSnapshot(e.data()))
        .toList();
  }

  showCompanies() {
    fetchCompanies().then((value) {
      companies.addAll(value);
      update();
    });
  }

  updateSelectedWasteCompany(String value) {
    wasteCompanyController.text = value;
    update();
  }

  updateCompanyId(String value) {
    selectedCompanyId = value;
    update();
  }

  String getCompanyId() {
    return selectedCompanyId;
  }

  // type of waste selection
  bool isDomesticSelected = false;
  bool isPlasticSelected = false;
  bool isMedicalSelected = false;
  bool isIndustrialSelected = false;

  bool isComplete = false;

  changeBoloean(bool value) {
    isComplete = value;
    update();
  }

  bool getBoolean() {
    return isComplete;
  }

  // schdule waste pickup
  scheduleWastePickup(
      BuildContext context,
      String userId,
      String companyId,
      double latitude,
      double longitude,
      String domestic,
      plastic,
      medical,
      industrial,
      String wasteWeight,
      String status) async {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference pickups =
        FirebaseFirestore.instance.collection('customerSchedules');

    try {
      var value = await pickups.add({
        'userId': userId,
        'companyId': companyId,
        'creationDate': DateTime.now().toString(),
        'customerLatitude': latitude,
        'customerLongitude': longitude,
        'wasteType': {
          'domestic': domestic,
          'plastic': plastic,
          'medical': medical,
          'industrial': industrial
        },
        'wasteWeight': wasteWeight,
        'scheduleStatus': status
      });

      debugPrint("Response from adding a schedule: $value");
      changeBoloean(false);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Schedule uploaded")));
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      Navigator.pop(context);
      update();
    } catch (e) {
      debugPrint("Failed to add schedule: $e");
    }
  }
}
