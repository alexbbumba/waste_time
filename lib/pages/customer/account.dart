import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_time/authenticate/signin.dart';

class CustomerAccount extends StatefulWidget {
  const CustomerAccount({super.key});

  @override
  State<CustomerAccount> createState() => _CustomerAccountState();
}

class _CustomerAccountState extends State<CustomerAccount> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Account"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(
            height: size.height * 0.09,
          ),
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: Center(
                child: Icon(
              Icons.person,
              size: size.height * 0.08,
            )),
          ),
          ListTile(
            title: Text(
              "Name:  ${user!.displayName}",
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              "Email:  ${user!.email}",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;

                await auth.signOut();
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const SignIn()),
                  );
                }
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
