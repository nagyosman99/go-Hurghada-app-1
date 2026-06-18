import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';

import 'package:go_hurghada/features/auth/utils/validators.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_header.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authVM = AppProvider.of(context).authViewModel;
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();

      final success = await authVM.signIn(email, password);

      if (!mounted) return;

      if (success) {
        // Load profile in the background — router redirect will navigate to /home
        // automatically because FirebaseAuth.currentUser is now non-null.
        AppProvider.of(context).profileViewModel.loadProfile();

        if (!mounted) return;
        context.go(AppRouter.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authVM.errorMessage ?? 'Sign in failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          AuthHeader(
            welcomeText:
                AppLocalizations.of(context)?.welcomeBack ?? 'Welcome back',
          ),
          const SizedBox(height: 30),
          AuthTextField(
            controller: _emailController,
            label:
                AppLocalizations.of(context)?.emailAddress ?? 'Email address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: EmailValidator.validate,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _passwordController,
            label: AppLocalizations.of(context)?.password ?? 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onVisibilityToggle: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)?.pleaseEnterPassword ??
                    'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: () => context.push(AppRouter.resetPassword),
              child: Text(
                AppLocalizations.of(context)?.forgotPassword ??
                    'Forgot password?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.authPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: AppProvider.of(context).authViewModel,
            builder: (context, child) {
              final isLoading = AppProvider.of(context).authViewModel.isLoading;
              return AuthButton.primary(
                text: AppLocalizations.of(context)?.signIn ?? 'Sign In',
                onPressed: isLoading ? () {} : () => _handleSignIn(),
                isLoading:
                    isLoading, // Assuming AuthButton supports isLoading, if not, we can rely on null onPressed or modify AuthButton.
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
