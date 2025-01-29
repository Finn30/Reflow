import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/function/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class FirestoreService {
  FirestoreService._privateConstructor();
  static final FirestoreService _instance = FirestoreService._privateConstructor();
  factory FirestoreService() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Users? user;

  addUsertoFirestore(String password) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final hashPass = sha256.convert(utf8.encode(password)).toString();

      DocumentReference userDoc = _firestore.collection('user').doc(currentUser?.uid);
      Map<String, dynamic> data = {
        'email': currentUser?.email,
        'password': hashPass,
        'firstName': '',
        'lastName': '',
        'gender': '',
        'phone': '',
        'createdAt': DateTime.now().toString(),
        'pictUrl': '',
      };
      await userDoc.set(data);
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }

  Future<Map<String, dynamic>?> loadUser(String email) async {
    try{
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      if (query.docs.isNotEmpty) {
        return query.docs.first.data();
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error loading user: $e");
      return null;
    }
  }

  updateFirstname(String email, String newName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'firstName': newName});
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  updateLastname(String email, String newName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'lastName': newName});
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  updateEmail(String email, String newEmail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(email: email, password: 'password'); // Ganti 'password' dengan input password aktual
        await user.reauthenticateWithCredential(credential);
        await user.updateEmail(newEmail);

        QuerySnapshot<Map<String, dynamic>> query = await _firestore
            .collection('user')
            .where('email', isEqualTo: email)
            .get();
        for (var doc in query.docs) {
          await doc.reference.update({'email': newEmail});
        }
      } else {
        print("User tidak terautentikasi.");
      }
    } catch (e) {
      print("Error updating email: $e");
    }
  }

  updatePassword(String email, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        final hashPass = sha256.convert(utf8.encode(newPassword)).toString();
        QuerySnapshot<Map<String, dynamic>> query = await _firestore
            .collection('user')
            .where('email', isEqualTo: email)
            .get();
        for (var doc in query.docs) {
          await doc.reference.update({'password': hashPass});
        }
      } else {
        print("User tidak terautentikasi.");
      }
    } catch (e) {
      print("Error updating password: $e");
    }
  }

  updatePhone(String email, String newPhone) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'phone': newPhone});
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  updateGender(String email, String newGender) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'gender': newGender});
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }
  checkPassword(String email, String password) async {
    try {
      final hashPass = sha256.convert(utf8.encode(password)).toString();
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      if (query.docs.isNotEmpty) {
        final userDoc = query.docs.first;
        final storedPassword = userDoc.data()['password'];
        if (storedPassword == hashPass) {
          return true;
        } else {
          return false;
        }
      } else {
        print("User not found");
        return false;
      }
    } catch (e) {
      print("Error loading user: $e");
      return false;
    }
  }


  changeProfilPicture(String email, String url) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'pictUrl': url});
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }
}

