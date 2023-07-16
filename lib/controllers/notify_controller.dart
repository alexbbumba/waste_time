import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final notifyManager = Get.put(NotifyController());

class NotifyController extends GetxController {
  notifyCustomer(BuildContext context, String customerId, String companyId,
      String message) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference notify =
        FirebaseFirestore.instance.collection('notifications');
    notify.add({
      'customerId': customerId,
      'companyId': companyId,
      'message': message,
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Customer notified")));
      update();
    }).catchError((error) {
      debugPrint("Failed to notify: $error");
    });
  }
}
