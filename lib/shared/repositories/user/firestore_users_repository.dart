import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'users_repository.dart';

class FirestoreUsersRepository implements UsersRepository {
  final FirebaseFirestore _firestore;

  FirestoreUsersRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUser(String uid) async {
    debugPrint('🔍 Fetching users/$uid');
    final doc = await _firestore.collection('users').doc(uid).get();
    debugPrint('🔍 doc.exists = ${doc.exists}');
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, uid: doc.id);
  }
}

//قديم
// Future<UserModel?> getUser(String uid) async {
//   final doc = await _firestore.collection('users').doc(uid).get();
//   if (!doc.exists || doc.data() == null) return null;
//   return UserModel.fromMap(doc.data()!, uid: doc.id);
// }
