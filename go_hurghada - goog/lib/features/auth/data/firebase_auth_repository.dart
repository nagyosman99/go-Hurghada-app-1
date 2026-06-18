import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_hurghada/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_hurghada/features/auth/models/profile_model.dart';
import 'package:go_hurghada/features/auth/models/settings_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Box _settingsBox;

  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    Box? settingsBox,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _settingsBox = settingsBox ?? Hive.box('settings_box');

  @override
  Future<void> signIn(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    debugPrint('[FirebaseAuthRepository] Calling signInWithEmailAndPassword for: $normalizedEmail');
    await _auth
        .signInWithEmailAndPassword(email: normalizedEmail, password: password)
        .timeout(const Duration(seconds: 15), onTimeout: () {
          throw Exception('Connection timed out. Please check your internet connection and try again.');
        });
  }

  @override
  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final normalizedEmail = email.trim().toLowerCase();
    debugPrint('[FirebaseAuthRepository] Calling createUserWithEmailAndPassword for: $normalizedEmail');
    final credential = await _auth
        .createUserWithEmailAndPassword(email: normalizedEmail, password: password)
        .timeout(const Duration(seconds: 15), onTimeout: () {
          throw Exception('Connection timed out. Please check your internet connection and try again.');
        });

    // Create user profile in Firestore
    if (credential.user != null) {
      debugPrint('[FirebaseAuthRepository] Creating profile in Firestore for: ${credential.user?.uid}');
      final profile = UserProfile(
        firstName: firstName,
        lastName: lastName,
        email: normalizedEmail,
        updatedAt: DateTime.now(),
      );
      try {
        await saveProfile(profile).timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint('[FirebaseAuthRepository] Failed to save profile to Firestore: $e');
        // Clean up the created auth user so they can retry registration
        try {
          await credential.user!.delete();
        } catch (cleanupError) {
          debugPrint('[FirebaseAuthRepository] Failed to clean up user: $cleanupError');
        }
        throw Exception('Failed to save profile: $e');
      }
    }
  }


  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<UserProfile?> getProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get()
          .timeout(const Duration(seconds: 8));
      if (doc.exists) {
        return UserProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('[FirebaseAuthRepository] Error in getProfile: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) return;

    var finalProfile = profile;

    // Check if we need to upload a local image
    if (profile.profileImagePath != null &&
        !profile.profileImagePath!.startsWith('http') &&
        File(profile.profileImagePath!).existsSync()) {
      debugPrint('[FirebaseAuthRepository] Local image detected. Uploading to Storage...');
      final downloadUrl = await _uploadProfileImage(
        user.uid,
        profile.profileImagePath!,
      );
      if (downloadUrl != null) {
        finalProfile = profile.copyWith(profileImagePath: downloadUrl);
      }
    }

    // Use the current user UID as the document ID
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(finalProfile.toJson(), SetOptions(merge: true));
  }

  Future<String?> _uploadProfileImage(String userId, String localPath) async {
    try {
      final file = File(localPath);
      final ref = _storage.ref().child('user_profiles').child('$userId.jpg');
      
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      debugPrint('[FirebaseAuthRepository] Image uploaded successfully: $url');
      return url;
    } catch (e) {
      debugPrint('[FirebaseAuthRepository] Error uploading image: $e');
      return null;
    }
  }

  @override
  Future<void> clearProfile() async {
    // Usually we don't delete the profile on logout, but if 'clear' implies deletion:
    // await _firestore.collection('users').doc(_auth.currentUser?.uid).delete();
    // For now, assume it just means local state clearing, which is handled by ViewModel.
    // But since this is a repo, maybe do nothing or actually delete.
    // Let's leave it empty or log it, as signOut handles the session.
  }

  // Settings (keep local in Hive)
  @override
  Future<SettingsState?> getSettings() async {
    final data = _settingsBox.get('app_settings');
    if (data != null) {
      if (data is String) {
        try {
          return SettingsState.fromJson(json.decode(data));
        } catch (e) {
          // Fallback if parsing fails
          return null;
        }
      } else if (data is Map) {
        return SettingsState.fromJson(Map<String, dynamic>.from(data));
      }
    }
    return null;
  }

  @override
  Future<void> saveSettings(SettingsState settings) async {
    await _settingsBox.put('app_settings', json.encode(settings.toJson()));
  }
}
