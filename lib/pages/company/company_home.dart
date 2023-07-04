import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_time/widgets/resuable_card.dart';
import 'package:waste_time/widgets/reusable_card_content.dart';

import 'company_account.dart';
import 'company_recents.dart';

class MainCompany extends StatefulWidget {
  const MainCompany({super.key});

  @override
  State<MainCompany> createState() => _MainCompanyState();
}

class _MainCompanyState extends State<MainCompany> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))),
        title: Text(
          '${_auth.currentUser!.displayName}, Welcome to Waste Time',
          style: const TextStyle(
              fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ReusableCard(
                          cardChild: const ReusableCardContent(
                            imageLink: "assets/images/recents.png",
                            label: 'Recent Schedules',
                          ),
                          action: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CompanyRecents()),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ReusableCard(
                          cardChild: const ReusableCardContent(
                            imageLink: "assets/images/account.png",
                            label: 'Account',
                          ),
                          action: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CompanyAccount()),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            // Text('COMPANIES'),
            // IconButton(
            //     onPressed: () async {
            //       await _auth.signOut();
            //       Navigator.of(context).pushNamedAndRemoveUntil(
            //           '/', (Route<dynamic> route) => false);
            //     },
            //     icon: Icon(Icons.lock_clock)),
          ],
        ),
      ),
    );
  }
}
