import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/features/auth/utils/validators.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

/// Screen for initiating password reset
/// Features white background with fade-in animation
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
    _emailController.dispose();
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
          Icon(Icons.lock_reset, size: 80, color: AppColors.authPrimary),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)?.resetPassword ?? 'Reset Password',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)?.enterEmailForOtp ??
                'Enter your Email to send OTP code',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 40),
          AuthTextField(
            controller: _emailController,
            label:
                AppLocalizations.of(context)?.emailAddress ?? 'Email address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: EmailValidator.validate,
          ),
          const SizedBox(height: 40),
          AuthButton.primary(
            text: AppLocalizations.of(context)?.next ?? 'Next',
            onPressed: _handleNext,
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // Send OTP logic would go here
      context.push(AppRouter.otpVerification);
    }
  }
}
