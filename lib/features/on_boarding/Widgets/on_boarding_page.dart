import 'package:flutter/material.dart';

class OnboardingPageData {
  final String image;
  final String title;
  final String subtitle;
  final Color accentColor;

  const OnboardingPageData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Full-screen background image
        Image.asset(
          data.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(color: const Color(0xff0F172A)),
        ),

        // Dark gradient overlay from bottom
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.35, 0.75, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.75),
                Colors.black.withValues(alpha: 0.95),
              ],
            ),
          ),
        ),

        // Accent color shimmer strip at top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  data.accentColor.withValues(alpha: 0.0),
                  data.accentColor,
                  data.accentColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
