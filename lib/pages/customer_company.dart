import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_time/globals.dart';
import 'package:waste_time/pages/company/company.dart';
import 'package:waste_time/pages/customer/customer.dart';

class CustomerOrCompany extends StatefulWidget {
  const CustomerOrCompany({Key? key}) : super(key: key);

  @override
  State<CustomerOrCompany> createState() => _CustomerOrCompanyState();
}

class _CustomerOrCompanyState extends State<CustomerOrCompany> {
  bool _isLoading = true;
  void _setUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    var basicInfo = snap.data() as Map<String, dynamic>;

    isCompany = basicInfo['type'] == 'company' ? true : false;
    print('isCompany : $isCompany');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : isCompany
            ? const MainCompany()
            : const MainCustomer();
  }
}
