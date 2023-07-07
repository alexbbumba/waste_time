import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:waste_time/widgets/resuable_card.dart';
import 'package:waste_time/widgets/reusable_card_content.dart';

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
                height: size.height * 0.04,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Graphs to represent the number of pickups i.e incomplete, transition, finished",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 2,
                child: Column(
                  children: [
                    const Text('Incomplete'),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _data.map((schedule) {
                                if (schedule.status == 'Incomplete') {
                                  return FlSpot(
                                    _data.indexOf(schedule).toDouble(),
                                    schedule.count.toDouble(),
                                  );
                                } else {
                                  return FlSpot(
                                    _data.indexOf(schedule).toDouble(),
                                    0,
                                  );
                                }
                              }).toList(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                          minX: 0,
                          maxX: _data.length.toDouble() - 1,
                          minY: 0,
                          maxY: _data
                              .map((schedule) => schedule.count)
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble(),
                          // titlesData: FlTitlesData(
                          //   show: true,
                          //   bottomTitles: SideTitles(
                          //     showTitles: true,
                          //     getTitles: (value) {
                          //       int index = value.toInt();
                          //       if (index >= 0 && index < _data.length) {
                          //         return _data[index].status;
                          //       }
                          //       return '';
                          //     },
                          //   ),
                          //   leftTitles: SideTitles(
                          //     showTitles: true,
                          //     getTitles: (value) {
                          //       if (value % 10 == 0) {
                          //         return value.toInt().toString();
                          //       }
                          //       return '';
                          //     },
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    const Text('Transition'),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _data.map((schedule) {
                                if (schedule.status == 'Transition') {
                                  return FlSpot(
                                    _data.indexOf(schedule).toDouble(),
                                    schedule.count.toDouble(),
                                  );
                                } else {
                                  return FlSpot(
                                    _data.indexOf(schedule).toDouble(),
                                    0,
                                  );
                                }
                              }).toList(),
                              isCurved: true,
                              color: Colors.red,
                              barWidth: 2,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                          minX: 0,
                          maxX: _data.length.toDouble() - 1,
                          minY: 0,
                          maxY: _data
                              .map((schedule) => schedule.count)
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble(),
                          // titlesData: FlTitlesData(
                          //   show: true,
                          //   bottomTitles: SideTitles(
                          //     showTitles: true,
                          //     getTitles: (value) {
                          //       int index = value.toInt();
                          //       if (index >= 0 && index < _data.length) {
                          //         return _data[index].status;
                          //       }
                          //       return '';
                          //     },
                          //   ),
                          //   leftTitles: SideTitles(
                          //     showTitles: true,
                          //     getTitles: (value) {
                          //       if (value % 10 == 0) {
                          //         return value.toInt().toString();
                          //       }
                          //       return '';
                          //     },
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    const Text('Finished'),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: _data.map((schedule) {
                                if (schedule.status == 'Finished') {
                                  return FlSpot(
                                    _data.indexOf(schedule).toDouble(),
                                    schedule.count.toDouble(),
                                  );
                                } else {
                                  return FlSpot(
                                    _data.indexOf(schedule).toDouble(),
                                    0,
                                  );
                                }
                              }).toList(),
                              isCurved: true,
                              color: Colors.green,
                              barWidth: 2,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                          minX: 0,
                          maxX: _data.length.toDouble() - 1,
                          minY: 0,
                          maxY: _data
                              .map((schedule) => schedule.count)
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble(),
                          // titlesData: FlTitlesData(
                          //   show: true,
                          //   bottomTitles: SideTitles(
                          //     showTitles: true,
                          //     getTitles: (value) {
                          //       int index = value.toInt();
                          //       if (index >= 0 && index < _data.length) {
                          //         return _data[index].status;
                          //       }
                          //       return '';
                          //     },
                          //   ),
                          //   leftTitles: SideTitles(
                          //     showTitles: true,
                          //     getTitles: (value) {
                          //       if (value % 10 == 0) {
                          //         return value.toInt().toString();
                          //       }
                          //       return '';
                          //     },
                          //   ),
                          // ),
                        ),
                      ),
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
