import 'package:flutter/material.dart';
import 'package:waste_time/pages/service_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: Color.fromARGB(255, 205, 211, 216),
        body: Padding(
      padding: EdgeInsets.fromLTRB(10, 80, 10, 0),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(110.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text('welcome to Waste_time')),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    Text('Notifications',
                        style: TextStyle(fontSize: 20.0, color: Colors.white))
                  ],
                ),
              )),
              Container(
                  child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                    Text('Chat with US',
                        style: TextStyle(fontSize: 20.0, color: Colors.white))
                  ],
                ),
              )),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceProviders(),
                      ));
                },
                child: Container(
                    child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 177, 172, 175),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.room_service,
                        color: Colors.yellow,
                      ),
                      Text('Service Providers',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Color.fromARGB(218, 8, 96, 155)))
                    ],
                  ),
                )),
              ),
              Container(
                  child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_box,
                      color: Colors.yellow,
                    ),
                    Text('Account',
                        style: TextStyle(fontSize: 20.0, color: Colors.white))
                  ],
                ),
              )),
              Container(
                  child: Column(
                children: [
                  Text('patient'),
                  IconButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
                      },
                      icon: Icon(Icons.lock_clock)),
                ],
              )),
            ],
          ),
        ],
      ),
    ));
  }
}
