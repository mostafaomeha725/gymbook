import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'segmented_tab_item.dart';

class CustomSegmentedTabs extends StatelessWidget {
  const CustomSegmentedTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.titlePrefix = "Performance",
    this.titleBuilder,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  final String titlePrefix;

  final String Function(String tab)? titleBuilder;

  @override
  Widget build(BuildContext context) {
    final selectedTab = tabs[selectedIndex];

    final title = titleBuilder != null
        ? titleBuilder!(selectedTab)
        : "$titlePrefix ($selectedTab)";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Tabs
          SizedBox(
            height: 48.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                return SegmentedTabItem(
                  text: tabs[index],
                  isSelected: index == selectedIndex,
                  onTap: () => onChanged(index),
                );
              },
            ),
          ),

          SizedBox(height: 28.h),

          AppText(
            title,
            style: font20w700.copyWith(color: const Color(0xff2C3E50)),
          ),
        ],
      ),
    );
  }
}
