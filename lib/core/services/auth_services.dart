import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_app_task/features/auth/model/user.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Sign in with phone number
//   Future<void> signInWithPhoneNumber(String phoneNumber) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         throw e;
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         // Store verificationId and show code input screen
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }

//   // Verify SMS code
//   Future<UserCredential> verifySMSCode(
//     String verificationId,
//     String smsCode,
//   ) async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: smsCode,
//     );
//     return await _auth.signInWithCredential(credential);
//   }

//   // Get current user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Stream of user data
//   Stream<UserModel> getUserData(String userId) {
//     return _firestore
//         .collection('users')
//         .doc(userId)
//         .snapshots()
//         .map((snapshot) => UserModel.fromMap(snapshot.data()!, snapshot.id));
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إضافة method للحصول على تغييرات حالة المصادقة
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store verificationId and show code input screen
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify SMS code
  Future<UserCredential> verifySMSCode(
    String verificationId,
    String smsCode,
  ) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream of user data
  Stream<UserModel> getUserData(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!, snapshot.id));
  }
}
