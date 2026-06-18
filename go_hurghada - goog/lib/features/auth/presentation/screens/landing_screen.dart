import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/config/constants/app_constants.dart';
import 'package:go_hurghada/features/auth/constants/auth_constants.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_background_with_image.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_hurghada/features/auth/presentation/widgets/social_login_icon.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

/// Landing screen with sign in/up options
/// Features beach background image with animated content
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackgroundWithImage(
        imagePath: 'assets/background.png',
        child: SafeArea(
          child: Column(
            children: [
              // Top section with logo and tagline
              Expanded(
                flex: 2,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildHeader(context),
                ),
              ),
              // Bottom section with buttons
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(
                      AuthConstants.horizontalPadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        _buildActionButtons(context),
                        const SizedBox(height: 24),
                        _buildSocialLoginSection(context),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header with title and subtitle
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AuthConstants.horizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'app_name',
            child: Text(
              AppConstants.appName,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)?.landingTagline ??
                'Start Your Journey With Us Now!',
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds sign in and sign up buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        AuthButton.primary(
          text: AppLocalizations.of(context)?.signIn ?? 'Sign In',
          onPressed: () => context.push(AppRouter.signIn),
        ),
        const SizedBox(height: 16),
        AuthButton.secondary(
          text: AppLocalizations.of(context)?.signUp ?? 'Sign Up',
          onPressed: () => context.push(AppRouter.signUp),
        ),
      ],
    );
  }

  /// Builds social login section with icons
  Widget _buildSocialLoginSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Center(
          child: Text(
            AppLocalizations.of(context)?.socialSignInPrefix ??
                'You can sign up with :',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginIcon(
              label: 'f',
              backgroundColor: AuthConstants.facebookBlue,
              onTap: () {
                // TODO: Implement Facebook login
              },
            ),
            const SizedBox(width: 20),
            SocialLoginIcon(
              label: 'G',
              backgroundColor: theme.cardColor,
              textColor: AuthConstants.googleRed,
              onTap: () {
                // TODO: Implement Google login
              },
            ),
          ],
        ),
      ],
    );
  }
}
