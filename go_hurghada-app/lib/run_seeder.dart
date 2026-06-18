import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_hurghada/core/utils/firebase_seeder.dart';
import 'package:go_hurghada/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final seeder = FirebaseSeeder();
  await seeder.seedAll();
}
