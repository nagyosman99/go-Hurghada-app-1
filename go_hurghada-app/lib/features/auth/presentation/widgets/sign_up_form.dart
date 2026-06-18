import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/auth/constants/auth_constants.dart';
import 'package:go_hurghada/features/auth/utils/validators.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_header.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final authVM = AppProvider.of(context).authViewModel;

      final success = await authVM.signUp(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        // Load profile in the background — router redirect handles navigation
        // automatically because FirebaseAuth.currentUser is now non-null.
        AppProvider.of(context).profileViewModel.loadProfile();

        if (!mounted) return;
        context.go(AppRouter.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authVM.errorMessage ?? 'Sign up failed'),
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
                AppLocalizations.of(context)?.welcomeTo ?? 'Welcome to',
          ),
          const SizedBox(height: 30),
          // First Name Field
          AuthTextField(
            controller: _firstNameController,
            label: AppLocalizations.of(context)?.firstName ?? 'First Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)?.pleaseEnterFirstName ??
                    'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Last Name Field
          AuthTextField(
            controller: _lastNameController,
            label: AppLocalizations.of(context)?.lastName ?? 'Last Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)?.pleaseEnterLastName ??
                    'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
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
            validator: (value) => PasswordValidator.validate(
              value,
              minLength: AuthConstants.minPasswordLength,
            ),
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _confirmPasswordController,
            label:
                AppLocalizations.of(context)?.confirmPassword ??
                'Confirm Password',
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
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: AppProvider.of(context).authViewModel,
            builder: (context, child) {
              final isLoading = AppProvider.of(context).authViewModel.isLoading;
              return AuthButton.primary(
                text: AppLocalizations.of(context)?.signUp ?? 'Sign Up',
                onPressed: isLoading ? () {} : () => _handleSignUp(),
                isLoading: isLoading,
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.alreadyHaveAccount ??
                    'Already have an account? ',
                style: theme.textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () => context.push(AppRouter.signIn),
                child: Text(
                  AppLocalizations.of(context)?.signIn ?? 'Sign in',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.authPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

