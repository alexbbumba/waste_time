import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste_time/controllers/mainController.dart';
import 'package:waste_time/pages/customer/payments_page.dart';

class RecentSchedules extends StatefulWidget {
  const RecentSchedules({super.key});

  @override
  State<RecentSchedules> createState() => _RecentSchedulesState();
}

class _RecentSchedulesState extends State<RecentSchedules> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final appCtr = Get.find<MainAppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        centerTitle: true,
        title: const Text('Recents'),
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
          children: [
            Expanded(
              child: TabBar(
                labelColor: Colors.blue[200],
                indicatorColor: const Color.fromARGB(255, 212, 178, 65),
                onTap: (index) {},
                tabs: const [
                  Tab(text: 'Incomplete'),
                  Tab(text: 'Transition'),
                  Tab(text: 'Finished'),
                ],
              ),
            ),
            Expanded(
              flex: 12,
              child: TabBarView(
                children: [
                  _buildScheduleList('incomplete'),
                  _buildScheduleList('transition'),
                  _buildScheduleList('finished'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(String status) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('customerSchedules')
          .where('scheduleStatus', isEqualTo: status)
          .where('userId', isEqualTo: currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return const Center(child: Text('No schedules found.'));
        }

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final schedule = documents[index].data() as Map<String, dynamic>;
            final bool isFinished = status == 'finished';
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Waste Type:  "),
                        Text("${schedule['wasteType']['domestic']}  "),
                        Text("${schedule['wasteType']['plastic']}  "),
                        Text("${schedule['wasteType']['medical']}  "),
                        Text("${schedule['wasteType']['industrial']} "),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Waste Weight Range:  "),
                        Text("${schedule['wasteWeight']}")
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Status:  "),
                        Text(schedule['scheduleStatus'])
                      ],
                    ),
                    !isFinished
                        ? Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    appCtr.updateRecordStatus(
                                        documents[index], 'canceled');
                                  },
                                  child: const Text('Cancel order')),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    if (isFinished) // Render button only if status is 'finished'
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button click
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebPage(
                                  url:
                                      'https://silicon-pay.com/payModal/S64b41dfe79a960.54919524',
                                ),
                              ),
                            );
                          },
                          child: const Text('Make Payment'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
