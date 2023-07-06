import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waste_time/pages/company/map_page.dart';

class CompanyRecents extends StatefulWidget {
  const CompanyRecents({Key? key}) : super(key: key);

  @override
  State<CompanyRecents> createState() => _CompanyRecentsState();
}

class _CompanyRecentsState extends State<CompanyRecents> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getCustomerName(String id) async {
    String customerName = '';

    try {
      final documentSnapshot =
          await _firestore.collection('users').doc(id).get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        String name = data![
            'name']; // Assuming 'name' is the field name where the name is stored
        customerName = name;
        debugPrint('Name: $name');
      }
    } catch (e) {
      debugPrint('Error getting customer name: $e');
    }

    return customerName;
  }

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
          .collection('customerSchedules')
          .where('scheduleStatus', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error} ');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
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
            final id = documents[index].id;

            return FutureBuilder<String>(
              future: getCustomerName(schedule['userId']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final customerName = snapshot.data ?? '';

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Customer Name:  "),
                          Text(customerName),
                        ],
                      ),
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
                          const Text("Waste Weight:  "),
                          Text("${schedule['wasteWeight']}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Status:  "),
                          Text(schedule['scheduleStatus']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // show pop up menu with accept and delcine
                              showMenu(
                                context: context,
                                position:
                                    const RelativeRect.fromLTRB(0, 0, 0, 0),
                                items: [
                                  const PopupMenuItem(
                                    value: 'accept',
                                    child: Text('Accept'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'decline',
                                    child: Text('Decline'),
                                  ),
                                ],
                              ).then((value) {
                                if (value == 'accept') {
                                  // Update the schedule status to "transition"
                                  _firestore
                                      .collection('customerSchedules')
                                      .doc(id)
                                      .update({'scheduleStatus': 'transition'});
                                } else if (value == 'decline') {
                                  // Handle decline action
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: const Text("Actions"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // move to screen with map
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (context) => MapPage(
                                          customerLatitude:
                                              schedule['customerLatitude'],
                                          customerLongitude:
                                              schedule['customerLongitude'],
                                        )),
                              );
                            },
                            child: const Text("View on map"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
