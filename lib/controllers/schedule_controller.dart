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
        .map((e) => CompanyInfor.fromDocumentSnapshot(e))
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
  // schdule waste pickup
  scheduleWastePickup(String userId, String companyId, String domestic, plastic,
      medical, industrial, double wasteWeight, String status) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference pickups =
        FirebaseFirestore.instance.collection('schdules');
    pickups.add({
      'userId': userId,
      'companyId': companyId,
      'wasteType': {
        'domestic': domestic,
        'plastic': plastic,
        'medical': medical,
        'industrial': industrial
      },
      'wasteWeight': wasteWeight,
      'scheduleStatus': status
    }).then((value) {
      debugPrint("Response from adding a schedule: $value");
      isComplete = true;
      update();
    }).catchError((error) {
      debugPrint("Failed to add schedule: $error");
    });
  }
}
