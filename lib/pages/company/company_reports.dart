import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/scheduleModel.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreen createState() => _ReportsScreen();
}

class _ReportsScreen extends State<ReportsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, Map<String, int>> oldScheds = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  organise(List records) {
    for (var record in records) {
      ScheduleModel sched = ScheduleModel.fromFireBase(record.data());
      String dateKey =
          DateFormat.yMMMMEEEEd().format(DateTime.parse(sched.dateCreated));
      if (oldScheds.containsKey(dateKey)) {
        Map<String, int> subMap = oldScheds[dateKey]!;

        if (subMap.containsKey(sched.status)) {
          int count = subMap[sched.status]!;
          count = count + 1;
          subMap[sched.status] = count;
        } else {
          subMap[sched.status] = 1;
        }
      } else {
        oldScheds[dateKey] = {sched.status: 1};
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double ovWidth = MediaQuery.of(context).size.width;
    double ovHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: SizedBox(
        height: ovHeight,
        width: ovWidth,
        child: StreamBuilder(
            stream: _firestore
                .collection('customerSchedules')
                .where('companyId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error} ');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                organise(snapshot.data!.docs);

                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (oldScheds.keys.toList())
                        .map((key) => buildReportContent(key))
                        .toList(),
                  ),
                ));
              }

              return const SizedBox();
            }),
      ),
    );
  }

  Widget buildReportContent(String key) {
    Map<String, int> detailMap = oldScheds[key]!;

    int totalOrders = (detailMap['incomplete'] ?? 0) +
        (detailMap['canceled'] ?? 0) +
        (detailMap['transition'] ?? 0) +
        (detailMap['declined'] ?? 0) +
        (detailMap['finished'] ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        titleWidget(key),
        const SizedBox(height: 10),
        contentWidget('Total orders: $totalOrders'),
        contentWidget('Incomplete orders: ${detailMap['incomplete'] ?? 0}'),
        contentWidget('Canceled orders: ${detailMap['canceled'] ?? 0}'),
        contentWidget('In Transition: ${detailMap['transition'] ?? 0}'),
        contentWidget('Declined orders: ${detailMap['declined'] ?? 0}'),
        contentWidget('Successful orders: ${detailMap['finished'] ?? 0}'),
      ],
    );
  }

  titleWidget(String title) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.6)),
      ),
    );
  }

  contentWidget(String content) {
    return Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 17),
        ));
  }
}
