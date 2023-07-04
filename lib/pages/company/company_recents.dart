import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyRecents extends StatefulWidget {
  const CompanyRecents({super.key});

  @override
  State<CompanyRecents> createState() => _CompanyRecentsState();
}

class _CompanyRecentsState extends State<CompanyRecents> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // data['vehicleUserId'] ==
  //                     FirebaseAuth.instance.currentUser!.uid
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
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('schdules')
          .where('scheduleStatus', isEqualTo: status)
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
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Waste Type:  "),
                      Text(schedule['wasteType']['domestic'])
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Waste Weight:  "),
                      Text("${schedule['wasteWeight']}")
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Status:  "),
                      Text(schedule['scheduleStatus'])
                    ],
                  ),
                  ElevatedButton(onPressed: () {
                      CollectionReference pickups =
        FirebaseFirestore.instance.collection('schdules');
    pickups.add({
      'userId': userId,
      'companyId': companyId,
      'wasteType': {
        'domestic': domestic,
        'plastic': plastic,
        'medical': medical,
        'industrial': industrial
      },
      'wasteWeight': wasteWeight,
      'scheduleStatus': status
    }).then((value) {
      debugPrint("Response from adding a schedule: $value");
      isComplete = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Schedule uploaded")));
      update();
    }).catchError((error) {
      debugPrint("Failed to add schedule: $error");
    });
                  }, child: const Text("Accept"))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
