import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String getUserName() {
  return getCurrentUser().displayName!;
}

User getCurrentUser() {
  return FirebaseAuth.instance.currentUser!;
}

Future<bool> signUserOut(context) async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
  return false;
}

Future<bool> createNewUser(firstName, email, password, context) async {
  if (firstName == '' || email == '' || password == '') {
    return false;
  }
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseAuth.instance.currentUser!.updateDisplayName(firstName);
    return true;
  } on FirebaseException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The password provided is too weak.')),
        snackBarAnimationStyle: AnimationStyle(curve: ElasticInCurve()),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The account already exists for that email.')),
        snackBarAnimationStyle: AnimationStyle(curve: ElasticInCurve()),
      );
    }
  } catch (e) {
    print(e);
  }
  return false;
}
