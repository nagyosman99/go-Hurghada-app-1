import 'package:flutter/material.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthStateNotifier extends ChangeNotifier {
  final AuthViewModel _authViewModel;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthStateNotifier(this._authViewModel) {
    _authViewModel.addListener(_onAuthChanged);
    // Also listen to Firebase Auth changes directly for more robustness
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      final isLoggedIn = user != null;
      if (_isAuthenticated != isLoggedIn) {
        _isAuthenticated = isLoggedIn;
        notifyListeners();
      }
    });
  }

  void _onAuthChanged() {
    // This might be redundant if we listen to FirebaseAuth stream directly,
    // but useful if AuthViewModel has other state logic.
    // For now, let's rely on FirebaseAuth stream in init.
  }

  @override
  void dispose() {
    _authViewModel.removeListener(_onAuthChanged);
    super.dispose();
  }
}
