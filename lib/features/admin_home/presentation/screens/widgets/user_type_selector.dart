import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/screens/widgets/user_type_item_selector.dart';

class UserTypeSelector extends StatelessWidget {
  const UserTypeSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Row(
        children: [
          UserTypeItemSelector(
            index: 0,
            title: "New User",
            subtitle: "No account",
            icon: Icons.person_add_alt,
            selectedIndex: selectedIndex,
            onTap: () => onChanged(0),
          ),
          SizedBox(width: 12.w),
          UserTypeItemSelector(
            index: 1,
            title: "Existing User",
            subtitle: "Has account",
            icon: Icons.person_outline,
            selectedIndex: selectedIndex,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}
