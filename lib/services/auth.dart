// import 'dart:async';
// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? displayName;
  int type = -1;
  AuthService({this.displayName});

  //register with email and password
  Future registerWithEmailAndPassword(TextEditingController emailController,
      TextEditingController passwordController) async {
    User? user;
    UserCredential? credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //final user = credential.user;
      //   await FirebaseFirestore.instance.collection(user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      // ignore: unnecessary_brace_in_string_interps
      debugPrint("${e}");
    }

    user = credential!.user;
    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await user.updateDisplayName(displayName);

      String? name = (type == 0) ? 'ink. $displayName' : displayName;
      String accountType = (type == 0) ? 'company' : 'customer';
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'type': accountType,
        'email': user.email,
      }, SetOptions(merge: true));

      // set data according to type (company or customer)
      Map<String, dynamic> mp = {
        'id': user.uid,
        'type': accountType,
        'name': name,
        'birthDate': null,
        'email': user.email,
        'phone': null,
        'bio': null,
        'address': null,
        'profilePhoto': null,
      };
      // if company
      if (type == 0) {
        mp.addAll({
          'openHour': "09:00",
          'closeHour': "21:00",
          'rating': null,
          'specification': null,
          'specialization': 'general',
        });
      }

      // sep
      FirebaseFirestore.instance.collection(accountType).doc(user.uid).set(mp);
    } else {}
  }

  //Sign in with email and password.
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
