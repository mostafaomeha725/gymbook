import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer_subscriptions/presentation/screens/widgets/subscriptions_screen_body.dart';

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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(SubscriptionTab.active),
              child: _buildTab("Active", selectedTab == SubscriptionTab.active),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(SubscriptionTab.expired),
              child: _buildTab(
                "Expired",
                selectedTab == SubscriptionTab.expired,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
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
