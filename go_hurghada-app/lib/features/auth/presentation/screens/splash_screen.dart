import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_hurghada/config/routes/app_router.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _airplaneTop = 600;
  double _airplaneLeft = -50;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _airplaneTop = 250;
          _airplaneLeft = MediaQuery.of(context).size.width / 2 - 40;
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Already logged in — load profile then go to home
        await AppProvider.of(context).profileViewModel.loadProfile();
        if (mounted) context.go(AppRouter.home);
      } else {
        context.go(AppRouter.onboarding1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // App Name at the Center
          Center(
            child: Text(
              'Go Hurghada',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Animated Airplane Icon
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInCubic,
            top: _airplaneTop,
            left: _airplaneLeft,
            child: Transform.rotate(
              angle: 0.3, // Slight tilt for a realistic flight effect
              child: Image.asset(
                'assets/Component .png',
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
