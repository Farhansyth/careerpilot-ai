import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get uid {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception("No logged in user");
    }

    return user.uid;
  }

  // ==========================================================
  // PERSONAL INFORMATION
  // ==========================================================

  Future<void> savePersonalInformation({
    required String fullName,
    required String jobTitle,
    required String email,
    required String phone,
    required String address,
    required String linkedin,
    required String github,
    required String portfolio,
    required String summary,
  }) async {
    debugPrint("========== FIRESTORE SAVE ==========");
    debugPrint("UID: $uid");

    await firestore.collection("users").doc(uid).set({
      "personal_information": {
        "fullName": fullName,
        "jobTitle": jobTitle,
        "email": email,
        "phone": phone,
        "address": address,
        "linkedin": linkedin,
        "github": github,
        "portfolio": portfolio,
        "summary": summary,
        "updatedAt": FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));

    debugPrint("✅ Personal Information Saved");
  }

  Future<Map<String, dynamic>?> getPersonalInformation() async {
    final doc = await firestore.collection("users").doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data();

    if (data == null) return null;

    if (data["personal_information"] == null) {
      return null;
    }

    return Map<String, dynamic>.from(data["personal_information"]);
  }

  Future<void> deletePersonalInformation() async {
    await firestore.collection("users").doc(uid).update({
      "personal_information": FieldValue.delete(),
    });
  }

  // ==========================================================
  // PROFESSIONAL SUMMARY
  // ==========================================================

  Future<void> saveProfessionalSummary({required String summary}) async {
    await firestore.collection("users").doc(uid).set({
      "professional_summary": {
        "summary": summary,
        "updatedAt": FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));

    debugPrint("✅ Professional Summary Saved");
  }

  Future<Map<String, dynamic>?> getProfessionalSummary() async {
    final doc = await firestore.collection("users").doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data();

    if (data == null) return null;

    if (data["professional_summary"] == null) {
      return null;
    }

    return Map<String, dynamic>.from(data["professional_summary"]);
  }

  Future<void> deleteProfessionalSummary() async {
    await firestore.collection("users").doc(uid).update({
      "professional_summary": FieldValue.delete(),
    });
  }
  // ==========================================================
  // SKILLS
  // ==========================================================

  Future<void> saveSkills({required List<String> skills}) async {
    await firestore.collection("users").doc(uid).set({
      "skills": {"items": skills, "updatedAt": FieldValue.serverTimestamp()},
    }, SetOptions(merge: true));

    debugPrint("✅ Skills Saved");
  }

  Future<List<String>> getSkills() async {
    final doc = await firestore.collection("users").doc(uid).get();

    if (!doc.exists) {
      return [];
    }

    final data = doc.data();

    if (data == null) {
      return [];
    }

    if (data["skills"] == null) {
      return [];
    }

    final List<dynamic> items = data["skills"]["items"] ?? [];

    return items.map((e) => e.toString()).toList();
  }

  Future<void> deleteSkills() async {
    await firestore.collection("users").doc(uid).update({
      "skills": FieldValue.delete(),
    });
  }
  // ==========================================================
  // WORK EXPERIENCE
  // ==========================================================

  Future<void> saveWorkExperience({
    required List<Map<String, dynamic>> experiences,
  }) async {
    await firestore.collection("users").doc(uid).set({
      "work_experience": {
        "items": experiences,
        "updatedAt": FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));

    debugPrint("✅ Work Experience Saved");
  }

  Future<List<Map<String, dynamic>>> getWorkExperience() async {
    final doc = await firestore.collection("users").doc(uid).get();

    if (!doc.exists) {
      return [];
    }

    final data = doc.data();

    if (data == null) {
      return [];
    }

    if (data["work_experience"] == null) {
      return [];
    }

    final List<dynamic> items = data["work_experience"]["items"] ?? [];

    return items.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> deleteWorkExperience() async {
    await firestore.collection("users").doc(uid).update({
      "work_experience": FieldValue.delete(),
    });
  }
}
