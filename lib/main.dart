import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waste_time/firebase_options.dart';
import 'package:waste_time/pages/company/company.dart';
import 'package:waste_time/pages/customer/customer.dart';
import 'package:waste_time/pages/customer_company.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_time/pages/wrapper.dart';
import 'package:waste_time/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Home(),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            user == null ? const Wrapper() : const CustomerOrCompany(),
        '/decision': (context) =>
            isCompany ? const MainCompany() : const MainCustomer(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
