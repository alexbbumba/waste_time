import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waste_time/models/scheduleModel.dart';
import 'package:waste_time/widgets/resuable_card.dart';
import 'package:waste_time/widgets/reusable_card_content.dart';

import '../../widgets/graphwidget.dart';
import 'company_account.dart';
import 'company_recents.dart';
import 'graphdetail.dart';

class MainCompany extends StatefulWidget {
  const MainCompany({Key? key}) : super(key: key);

  @override
  State<MainCompany> createState() => _MainCompanyState();
}

class _MainCompanyState extends State<MainCompany> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ScheduleCount> _data = [];

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() async {
    int incompleteCount = 0;
    int canceledCount = 0;
    int finishedCount = 0;

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('customerSchedules').get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> schedule = doc.data() as Map<String, dynamic>;
      String status = schedule['scheduleStatus'];

      if (status == 'incomplete') {
        incompleteCount++;
      } else if (status == 'canceled') {
        canceledCount++;
      } else if (status == 'finished') {
        finishedCount++;
      }
    }

    setState(() {
      _data = [
        ScheduleCount('Incomplete', incompleteCount),
        ScheduleCount('Canceled', canceledCount),
        ScheduleCount('Finished', finishedCount),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        child: SingleChildScrollView(
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
                                      const CompanyRecents(),
                                ),
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
                                      const CompanyAccount(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Graphs to represent the number of pickups i.e incomplete, canceled, finished",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.5 * 3,
                child: Column(
                  children: [
                    const Text(
                      'Incomplete Pickups linegraph',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: _firestore
                              .collection('customerSchedules')
                              .where('scheduleStatus', isEqualTo: 'incomplete')
                              .where('companyId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<ScheduleModel> content = [];
                            if (snapshot.hasData) {
                              // print(snapshot.data!.docs[0].data());
                              content.addAll(snapshot.data!.docs.map((e) {
                                return ScheduleModel.fromFireBase(e.data());
                              }).toList());
                              return Sample(
                                data: content,
                              );
                            }
                            return const SizedBox();
                          }),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Canceled Pickups linegraph',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: _firestore
                              .collection('customerSchedules')
                              .where('scheduleStatus', isEqualTo: 'canceled')
                              .where('companyId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<ScheduleModel> content = [];
                            if (snapshot.hasData) {
                              // print(snapshot.data!.docs[0].data());
                              content.addAll(snapshot.data!.docs.map((e) {
                                return ScheduleModel.fromFireBase(e.data());
                              }).toList());

                              if (content.isNotEmpty) {
                                return Sample(
                                  data: content,
                                );
                              }
                            }
                            return const SizedBox();
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Finished Pickups linegraph',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: _firestore
                              .collection('customerSchedules')
                              .where('scheduleStatus', isEqualTo: 'finished')
                              .where('companyId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<ScheduleModel> content = [];
                            if (snapshot.hasData) {
                              // print(snapshot.data!.docs[0].data());

                              content = snapshot.data!.docs.map((e) {
                                return ScheduleModel.fromFireBase(e.data());
                              }).toList();
                              return Sample(
                                data: content,
                              );
                            }
                            return const SizedBox();
                          }),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleCount {
  final String status;
  final int count;

  ScheduleCount(this.status, this.count);
}
