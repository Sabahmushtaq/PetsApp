import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final fireStoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref) => FirebaseAuth.instance);
final storageProvider = Provider((ref) => FirebaseStorage.instance);
final categoryValues = [
  "Cat",
  "Dog",
  "Birds",
  "Fish",
  "cow",
  "sheep",
  "horse",
  "others"
];
Map<String, dynamic> firebaseValues = {};
final vaccinatedValues = [true, false];
final photosProvider = StateProvider<Map<String, XFile>>((ref) => {});
final verificationProvider =
    StateProvider((ref) => ref.watch(authProvider).currentUser?.emailVerified);
final queryValue = StateProvider((ref) => '');
