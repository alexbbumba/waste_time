import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waste_time/models/scheduleModel.dart';

class GraphDetailScreen extends StatefulWidget {
  List<ScheduleModel> schedules;
  GraphDetailScreen({required this.schedules, Key? key}) : super(key: key);
  _GraphDetailScreen createState() => _GraphDetailScreen();
}

class _GraphDetailScreen extends State<GraphDetailScreen> {
  late List<ScheduleModel> scheds;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    scheds = widget.schedules;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(DateFormat.MMMMEEEEd()
              .format(DateTime.parse(widget.schedules[0].dateCreated)))),
      body: ListView.builder(
          itemCount: scheds.length,
          itemBuilder: (c, i) {
            return FutureBuilder<String>(
              future: getCustomerName(scheds[i].userId),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text("${scheds[i].wasteType['domestic']}  "),
                          Text("${scheds[i].wasteType['plastic']}  "),
                          Text("${scheds[i].wasteType['medical']}  "),
                          Text("${scheds[i].wasteType['industrial']} "),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Waste Weight Range:  "),
                          Text(scheds[i].wasteWight),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Status:  "),
                          Text(scheds[i].status),
                        ],
                      ),
                      Text(
                          'Ordered at: ${DateFormat.jm().format(DateTime.parse(scheds[i].dateCreated))}')
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

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
}
