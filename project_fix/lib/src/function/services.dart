import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_fix/src/function/User.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirestoreService {
  FirestoreService._privateConstructor();
  static final FirestoreService _instance =
      FirestoreService._privateConstructor();
  factory FirestoreService() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Users? user;

  addUsertoFirestore(String password) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final hashPass = sha256.convert(utf8.encode(password)).toString();

      DocumentReference userDoc =
          _firestore.collection('user').doc(currentUser?.uid);
      Map<String, dynamic> data = {
        'email': currentUser?.email,
        'password': hashPass,
        'fullName': '',
        'firstName': '',
        'lastName': '',
        'gender': '',
        'phone': '',
        'createdAt': DateTime.now().toString(),
        'pictUrl': '',
        'age': '',
      };
      await userDoc.set(data);
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }

  Future<Map<String, dynamic>> loadUser(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        return {
          'email': data['email'] ?? "",
          'password': data['password'] ?? "",
          'fullName': data['fullName'] ?? "",
          'firstName': data['firstName'] ?? "",
          'lastName': data['lastName'] ?? "",
          'gender': data['gender'] ?? "",
          'phone': data['phone'] ?? "",
          'createdAt': data['createdAt'] ?? "",
          'pictUrl': data['pictUrl'] ?? "",
          'age': data['age'] ?? "",
        };
      } else {
        print("User not found");
        return {};
      }
    } catch (e) {
      print("Error loading user: $e");
      return {};
    }
  }

  updateAge(String email, String newAge) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'age': newAge});
      }
    } catch (e) {
      print("Error updating age: $e");
    }
  }

  updateFullname(String email, String newName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'fullName': newName});
      }
    } catch (e) {
      print("Error updating user data: $e");
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
        final credential = EmailAuthProvider.credential(
            email: email,
            password:
                'password'); // Ganti 'password' dengan input password aktual
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

  Future<String?> getGender(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      if (query.docs.isNotEmpty) {
        return query.docs.first.data()['gender'];
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error getting gender: $e");
      return null;
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

  Future<String?> createPaymentLinkMidtrans(String email, int amount) async {
    try {
      var userData = await loadUser(email);
      //production url
      // final url = Uri.parse('https://app.midtrans.com/snap/v1/transactions');
      //sandbox url
      final url =
          Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');
      final serverKey =
          dotenv.env['MIDTRANS_SERVER_KEY_SANDBOX'] ?? 'Not Found';
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ' + base64Encode(utf8.encode(serverKey)),
        },
        body: jsonEncode({
          'transaction_details': {
            'order_id': 'order-${DateTime.now().millisecondsSinceEpoch}',
            'gross_amount': amount,
          },
          'customer_details': {
            'email': email,
            'first_name': userData?['firstName'],
            'last_name': userData?['lastName'],
            'phone': userData?['phone'],
          }
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final paymentUrl = responseData['redirect_url'];
        print('Payment Link: $paymentUrl');
        return paymentUrl;
      } else {
        print('Failed to create payment link: ${response.body}');
        return null;
      }
    } catch (e) {
      print("Error in createPaymentLinkMidtrans: $e");
      return null;
    }
  }

  Future<void> topUpFirebase(String uid, int amount) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('bank')
          .where('uid', isEqualTo: uid)
          .get();
      for (var doc in query.docs) {
        await doc.reference.update({'balance': FieldValue.increment(amount)});
      }
    } catch (e) {
      print("Error in topUpFirebase: $e");
    }
  }

  Future<int?> getBalance(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('bank')
          .where('uid', isEqualTo: uid)
          .get();
      if (query.docs.isNotEmpty) {
        return query.docs.first.data()['balance'];
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error loading user: $e");
      return null;
    }
  }
}
