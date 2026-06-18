import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/auth/constants/auth_constants.dart';
import 'package:go_hurghada/features/auth/utils/validators.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_text_field.dart';

/// Screen for setting a new password
/// Features white background with fade-in animation
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildForm(),
                  ),
                ),
              ),
            ),
          ),
          const AuthBackButton(color: AppColors.authPrimary),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_open, size: 80, color: AppColors.authPrimary),
          const SizedBox(height: 30),
          Text(
            'New Password',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enter a New password to update your password',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 40),
          AuthTextField(
            controller: _passwordController,
            label: 'New password',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onVisibilityToggle: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
            validator: (value) => PasswordValidator.validate(
              value,
              minLength: AuthConstants.minPasswordLength,
            ),
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _confirmPasswordController,
            label: 'Confirm New password',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onVisibilityToggle: () {
              setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              );
            },
            validator: (value) => ConfirmPasswordValidator.validate(
              value,
              _passwordController.text,
            ),
          ),
          const SizedBox(height: 40),
          AuthButton.primary(text: 'Verify', onPressed: _handleVerify),
        ],
      ),
    );
  }

  void _handleVerify() {
    if (_formKey.currentState!.validate()) {
      // Update password logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordUpdated),
          backgroundColor: AppColors.success,
        ),
      );
      context.go(AppRouter.signIn);
    }
  }
}
