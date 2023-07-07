import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_time/widgets/resuable_card.dart';
import 'package:waste_time/widgets/reusable_card_content.dart';
import 'package:fl_chart/fl_chart.dart';

import 'company_account.dart';
import 'company_recents.dart';

class MainCompany extends StatefulWidget {
  const MainCompany({Key? key}) : super(key: key);

  @override
  State<MainCompany> createState() => _MainCompanyState();
}

class _MainCompanyState extends State<MainCompany> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ScheduleCount> _data = [];

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() async {
    int incompleteCount = 0;
    int transitionCount = 0;
    int finishedCount = 0;

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('customerSchedules').get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> schedule = doc.data() as Map<String, dynamic>;
      String status = schedule['scheduleStatus'];

      if (status == 'incomplete') {
        incompleteCount++;
      } else if (status == 'transition') {
        transitionCount++;
      } else if (status == 'finished') {
        finishedCount++;
      }
    }

    setState(() {
      _data = [
        ScheduleCount('Incomplete', incompleteCount),
        ScheduleCount('Transition', transitionCount),
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
                height: size.height * 0.05,
              ),
              SizedBox(
                height: size.height * 0.2,
                child: _data.isNotEmpty
                    ? LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _data.map((schedule) {
                                return FlSpot(
                                  _data.indexOf(schedule).toDouble(),
                                  schedule.count.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          minX: 0,
                          maxX: _data.length.toDouble() - 1,
                          minY: 0,
                          maxY: _data
                              .map((schedule) => schedule.count)
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble(),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                // getTitles: (value) {
                                //   int index = value.toInt();
                                //   if (index >= 0 && index < _data.length) {
                                //     return _data[index].status;
                                //   }
                                //   return '';
                                // },
                              ),
                            ),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true)),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
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
