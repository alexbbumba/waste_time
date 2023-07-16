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
                child: Center(
                  child: Text(
                    "Graphs to represent the number of pickups i.e incomplete, transition, finished",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 3,
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
                      child: LineChart(
                        LineChartData(
                          lineTouchData: const LineTouchData(
                              enabled: false), // Disable touch interactions
                          gridData:
                              const FlGridData(show: false), // Hide grid lines
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
                              color: Colors.blue,
                              isStepLineChart: false,
                              barWidth: 3,
                            ),
                          ],

                          minY: 0,
                          maxY: _data.length.toDouble(),
                          titlesData: const FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              axisNameWidget: Text(
                                "Number of incomplete pickups",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 30, showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 30, showTitles: false)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      'Transition Pickups linegraph',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          gridData:
                              const FlGridData(show: false), // Hide grid lines
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
                              isStepLineChart: true,
                              color: Colors.red,
                              barWidth: 3,
                            ),
                          ],
                          minY: 0,
                          maxY: _data.length.toDouble(),
                          titlesData: const FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              axisNameWidget: Text(
                                "Number of in_transition pickups",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 30, showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 30, showTitles: false)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      'Finished Pickups linegraph',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          gridData:
                              const FlGridData(show: false), // Hide grid lines
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
                              isStepLineChart: true,
                              color: Colors.green,
                              barWidth: 2,
                            ),
                          ],
                          minY: 0,
                          maxY: _data.length.toDouble(),
                          titlesData: const FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              axisNameWidget: Text(
                                "Number of finished pickups",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 30, showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 30, showTitles: false)),
                          ),
                        ),
                      ),
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
