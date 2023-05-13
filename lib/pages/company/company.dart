import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainCompany extends StatefulWidget {
  const MainCompany({super.key});

  @override
  State<MainCompany> createState() => _MainCompanyState();
}

class _MainCompanyState extends State<MainCompany> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: Column(
          children: [
            Text('COMPANIES'),
            IconButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                },
                icon: Icon(Icons.lock_clock)),
          ],
        )),
      ),
    );
  }
}
