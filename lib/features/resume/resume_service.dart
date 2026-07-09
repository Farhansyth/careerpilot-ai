import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/resume_model.dart';

class ResumeService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveResume(ResumeModel resume) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .set(resume.toMap(), SetOptions(merge: true));
  }

  Future<ResumeModel?> getResume() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) return null;

    return ResumeModel.fromMap(snapshot.data()!);
  }
}
