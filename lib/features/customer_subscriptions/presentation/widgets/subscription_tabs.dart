import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/enums/app_enums.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionTabs extends StatelessWidget {
  final SubscriptionTab selectedTab;
  final Function(SubscriptionTab) onChanged;

  const SubscriptionTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = <MapEntry<SubscriptionTab, String>>[
      const MapEntry(SubscriptionTab.all, 'All'),
      const MapEntry(SubscriptionTab.active, 'Active'),
      const MapEntry(SubscriptionTab.expired, 'Expired'),
      const MapEntry(SubscriptionTab.frozen, 'Frozen'),
      const MapEntry(SubscriptionTab.cancelled, 'Cancelled'),
      const MapEntry(SubscriptionTab.scheduled, 'Scheduled'),
    ];

    return Container(
      height: 42.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs
              .map(
                (tab) => Padding(
                  padding: EdgeInsetsDirectional.only(end: 4.w),
                  child: GestureDetector(
                    onTap: () => onChanged(tab.key),
                    child: _buildTab(tab.value, selectedTab == tab.key),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(25.r),
      ),
      alignment: Alignment.center,
      child: AppText(
        text,
        style: selected
            ? font14w700.copyWith(color: Colors.white)
            : font14w500.copyWith(color: const Color(0xff717182)),
        alignment: AlignmentDirectional.center,
      ),
    );
  }
}
