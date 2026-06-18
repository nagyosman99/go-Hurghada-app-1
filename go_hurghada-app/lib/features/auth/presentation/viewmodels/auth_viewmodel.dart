import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_hurghada/features/auth/domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel({required AuthRepository repository})
    : _repository = repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _cleanErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        // Legacy codes (Firebase SDK v8)
        case 'user-not-found':
          return 'No account found with this email. / لا يوجد حساب بهذا البريد الإلكتروني.';
        case 'wrong-password':
          return 'Incorrect password. Please try again. / كلمة المرور غير صحيحة. حاول مرة أخرى.';
        // New unified code (Firebase SDK v9+)
        case 'invalid-credential':
          return 'Incorrect email or password. Please try again. / البريد الإلكتروني أو كلمة المرور غير صحيحة.';
        case 'email-already-in-use':
          return 'This email is already registered. / هذا البريد الإلكتروني مسجل بالفعل.';
        case 'invalid-email':
          return 'The email address is badly formatted. / صيغة البريد الإلكتروني غير صحيحة.';
        case 'weak-password':
          return 'Password must be at least 6 characters. / كلمة المرور يجب أن تكون 6 أحرف على الأقل.';
        case 'user-disabled':
          return 'This account has been disabled. / تم تعطيل هذا الحساب.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again. / محاولات كثيرة. انتظر قليلاً وحاول مرة أخرى.';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled. / تسجيل الدخول بالبريد الإلكتروني غير مفعّل.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection. / خطأ في الشبكة. يرجى التحقق من الاتصال بالإنترنت.';
        default:
          return error.message ?? 'An authentication error occurred. / حدث خطأ أثناء المصادقة.';
      }
    }

    String msg = error.toString();
    if (msg.startsWith('Exception: ')) {
      msg = msg.substring(11);
    }
    return msg;
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint('[AuthViewModel] Attempting sign in for: $email');

    try {
      await _repository.signIn(email, password);
      debugPrint('[AuthViewModel] Sign in successful for: $email');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[AuthViewModel] Sign in failed for: $email. Error: $e');
      _isLoading = false;
      _errorMessage = _cleanErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint('[AuthViewModel] Attempting sign up for: $email');

    try {
      await _repository.signUp(email, password, firstName, lastName);
      debugPrint('[AuthViewModel] Sign up successful for: $email');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[AuthViewModel] Sign up failed for: $email. Error: $e');
      _isLoading = false;
      _errorMessage = _cleanErrorMessage(e);
      notifyListeners();
      return false;
    }
  }


  Future<void> signOut() async {
    await _repository.signOut();
    notifyListeners();
  }
}
