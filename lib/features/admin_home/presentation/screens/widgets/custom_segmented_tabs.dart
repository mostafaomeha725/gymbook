import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'status_card.dart'; // 👈 استدعاء الكارت

class CustomSegmentedTabs extends StatefulWidget {
  const CustomSegmentedTabs({super.key});

  @override
  State<CustomSegmentedTabs> createState() => _CustomSegmentedTabsState();
}

class _CustomSegmentedTabsState extends State<CustomSegmentedTabs> {
  int selectedIndex = 0;

  final List<String> tabs = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
    "All",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48.h,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0EA5E9)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: AppText(
                        tabs[index],
                        style: font16w600.copyWith(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xff4B5563),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 28.h),

          AppText(
            "Performance (${tabs[selectedIndex]})",
            style: font20w700.copyWith(color: const Color(0xff2C3E50)),
          ),

          SizedBox(height: 12.h),

          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: const [
              StatusCard(
                icon: Icons.person_add_alt,
                title: "3",
                subtitle: "New Subscriptions",
                iconColor: Color(0xFFF59E0B),
              ),

              StatusCard(
                icon: Icons.attach_money,
                title: "4,800",
                subtitle: "Revenue (EGP)",
                iconColor: Color(0xFF10B981),
              ),

              StatusCard(
                icon: Icons.check_circle_outline,
                title: "87",
                subtitle: "Check-ins Count",
                iconColor: Color(0xFF0EA5E9),
              ),

              StatusCard(
                icon: Icons.event_busy_outlined,
                title: "1",
                subtitle: "Expired Subscriptions",
                iconColor: Color(0xFFEF4444),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
