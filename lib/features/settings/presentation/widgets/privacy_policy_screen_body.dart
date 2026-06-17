import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/features/settings/presentation/widgets/custom_info_row.dart';
import 'package:gymbook/features/settings/presentation/widgets/privacy_section_card.dart';

class PrivacyPolicyScreenBody extends StatelessWidget {
  const PrivacyPolicyScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppbarSubscriptionWidget(text: "Privacy Policy"),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                const PrivacySectionCard(
                  title: "Information We Collect",
                  icon: Icons.storage_rounded,
                  iconColor: Color(0xFF134FA2),
                  iconBgColor: Color(0xFFE6F0FF),
                  description:
                      "We collect certain information to provide and improve our services.",
                  bulletPoints: [
                    "Personal information such as name and email address",
                    "Profile and account details",
                    "Usage and activity data",
                    "Device and technical information",
                  ],
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "How We Use Your Information",
                  icon: Icons.person_outline_rounded,
                  iconColor: Color(0xFF008545),
                  iconBgColor: Color(0xFFE6F6EC),
                  description:
                      "We use your information to provide, maintain, and improve our services.",
                  bulletPoints: [
                    "Create and manage your account",
                    "Provide personalized experiences",
                    "Improve application performance",
                    "Communicate updates and notifications",
                  ],
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "Data Security",
                  icon: Icons.lock_outline_rounded,
                  iconColor: Color(0xFF9C27B0),
                  iconBgColor: Color(0xFFFAF0FA),
                  description:
                      "We take appropriate security measures to protect your personal information.",
                  bulletPoints: [
                    "Encrypted data transmission",
                    "Secure storage systems",
                    "Access control and authentication",
                    "Regular security monitoring",
                  ],
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "Information Sharing",
                  icon: Icons.visibility_outlined,
                  iconColor: Color(0xFFD97706),
                  iconBgColor: Color(0xFFFFF9E5),
                  description:
                      "We do not sell your personal information to third parties.",
                  bulletPoints: [
                    "Service providers assisting our operations",
                    "Legal compliance requirements",
                    "Protection of rights and security",
                  ],
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "Cookies and Tracking Technologies",
                  description:
                      "We may use cookies and similar technologies to improve user experience and analyze application usage.",
                ),
                SizedBox(height: 20.h),

                const PrivacySectionCard(
                  title: "Children's Privacy",
                  description:
                      "Our services are not intended for children under the age of 13. We do not knowingly collect personal information from children.",
                ),
                SizedBox(height: 20.h),

                PrivacySectionCard(
                  title: "Contact Us",
                  description:
                      "If you have any questions about this Privacy Policy, please contact us.",
                  extraContent: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ContactInfoRow(
                        label: "Email",
                        value: "privacy@tourismapp.com",
                      ),
                      SizedBox(height: 8.h),
                      const ContactInfoRow(
                        label: "Address",
                        value: "Cairo, Egypt",
                      ),
                      SizedBox(height: 8.h),
                      const ContactInfoRow(
                        label: "Phone",
                        value: "+20 123 456 7890",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
