import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/get_type_color.dart';

class TagBadge extends StatelessWidget {
  final String tag;

  const TagBadge({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: GetTypeColor().getTypeColor(tag).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: AppText(
        tag,
        style: font12w700.copyWith(color: GetTypeColor().getTypeColor(tag)),
      ),
    );
  }
}
