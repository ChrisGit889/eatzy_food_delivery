import 'package:eatzy_food_delivery/utils/snackbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

String getUserName() {
  return getCurrentUser().displayName!;
}

String getUserEmail() {
  return getCurrentUser().email!;
}

User getCurrentUser() {
  return auth.currentUser!;
}

Future<bool> signUserOut() async {
  try {
    await auth.signOut();
    return true;
  } catch (e) {
    print(e);
  }
  return false;
}

Future<bool> createNewUser(firstName, email, password, context) async {
  if (firstName == '' || email == '' || password == '') {
    return false;
  }
  try {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    await auth.currentUser!.updateDisplayName(firstName);
    return true;
  } on FirebaseException catch (e) {
    if (e.code == 'weak-password') {
      showSnackBar(
        context: context,
        content: Text('The password provided is too weak.'),
      );
    } else if (e.code == 'email-already-in-use') {
      showSnackBar(
        context: context,
        content: Text('The account already exists for that email.'),
      );
    } else {
      showSnackBar(
        context: context,
        content: Text('An error has occured. Please try again'),
      );
    }
  } catch (e) {
    print(e);
  }
  return false;
}

Future<bool> signInUser(email, password, context) async {
  if (email == '' || password == '') {
    return false;
  }
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showSnackBar(
        context: context,
        content: Text('No user found with that email'),
      );
    } else if (e.code == 'wrong-password') {
      showSnackBar(context: context, content: Text('Wrong password'));
    } else {
      showSnackBar(context: context, content: Text('Please try again'));
    }
    return false;
  }
}

Future<bool> updateUser({
  required String email,
  required String name,
  required String phone,
  required String dob,
}) async {
  try {
    await getCurrentUser().updateDisplayName(name);
    return true;
  } catch (e, _) {
    return false;
  }
}

Future<bool> updatePassword({required String password}) async {
  try {
    await getCurrentUser().updatePassword(password);
    return true;
  } catch (e, s) {
    print(e);
    print(s);
    return false;
  }
}
