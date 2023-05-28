import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste_time/models/company_info.dart';

final schedulerManager = Get.put(ScheduleController());

class ScheduleController extends GetxController {
  final wasteCompanyController = TextEditingController();
  final wasteTypeController = TextEditingController();

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
}
