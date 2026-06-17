import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/settings/presentation/widgets/privacy_section_card.dart';

class TermsOfUseScreenBody extends StatelessWidget {
  const TermsOfUseScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> lines(String text) =>
        text.split('\n').where((e) => e.trim().isNotEmpty).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppbarSubscriptionWidget(text: "Terms of Use"),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                const PrivacySectionCard(
                  title: "Acceptance of Terms",
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: Color(0xFF008545),
                  iconBgColor: Color(0xFFE6F6EC),
                  description:
                      "By accessing and using our app, you accept and agree to be bound by the terms and provision of this agreement.",
                ),
                SizedBox(height: 20.h),

                PrivacySectionCard(
                  title: "Use of Services",
                  icon: Icons.gavel_rounded,
                  iconColor: const Color(0xFF134FA2),
                  iconBgColor: const Color(0xFFE6F0FF),
                  description:
                      "When using our services, you agree to the following rules:",
                  bulletPoints: lines(
                    "You must provide accurate information.\nYou are responsible for your account activity.\nYou must not use the service for illegal purposes.",
                  ),
                ),
                SizedBox(height: 20.h),

                PrivacySectionCard(
                  title: "Bookings and Payments",
                  icon: Icons.error_outline_rounded,
                  iconColor: const Color(0xFFD97706),
                  iconBgColor: const Color(0xFFFFF9E5),
                  description:
                      "All bookings made through the app are subject to availability and our payment policies.",
                  bulletPoints: lines(
                    "Payments are processed securely.\nPrices are subject to change without notice.\nBooking confirmations will be sent via email.",
                  ),
                ),
                SizedBox(height: 20.h),

                PrivacySectionCard(
                  title: "Cancellation Policy",
                  icon: Icons.cancel_outlined,
                  iconColor: const Color(0xFFD32F2F),
                  iconBgColor: const Color(0xFFFFEBEE),
                  description:
                      "If you need to cancel a booking, please be aware of our cancellation policy.",
                  bulletPoints: lines(
                    "Cancellations must be made 24 hours in advance.\nLate cancellations may incur a fee.\nRefunds take 3-5 business days to process.",
                  ),
                ),
                SizedBox(height: 20.h),

                PrivacySectionCard(
                  title: "User Content",
                  description:
                      "Any content you upload or share on our platform remains yours, but you grant us a license to use it.",
                  bulletPoints: lines(
                    "You retain copyright to your content.\nYou grant us a non-exclusive license to use it.\nYou must not post offensive or copyrighted material.",
                  ),
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "Intellectual Property",
                  description:
                      "The service and its original content, features, and functionality are owned by GymBook and are protected by international copyright, trademark, and other intellectual property laws.",
                ),
                SizedBox(height: 20.h),

                PrivacySectionCard(
                  title: "Emergency Situations",
                  description:
                      "In case of emergency, please follow the guidelines provided by our staff or local authorities.",
                  bulletPoints: lines(
                    "Familiarize yourself with emergency exits.\nFollow instructions from authorized personnel.\nReport any suspicious activity immediately.",
                  ),
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "Changes to Terms",
                  description:
                      "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will try to provide at least 30 days notice prior to any new terms taking effect.",
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "Governing Law",
                  description:
                      "These Terms shall be governed and construed in accordance with the laws of Egypt, without regard to its conflict of law provisions.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
