import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/status_card.dart';

class ManagePackageStatus extends StatelessWidget {
  const ManagePackageStatus({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.averagePrice,
  });

  final int totalCount;
  final int activeCount;
  final double averagePrice;

  String get _averagePriceText {
    final hasFraction = averagePrice % 1 != 0;
    return hasFraction
        ? averagePrice.toStringAsFixed(2)
        : averagePrice.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Row(
        children: [
          Expanded(
            child: StatusCard(
              icon: Icons.inventory_2_outlined,
              title: totalCount.toString(),
              subtitle: 'Total',
              isCenter: true,
              gradient: LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: StatusCard(
              icon: Icons.trending_up,
              title: activeCount.toString(),
              subtitle: 'Active',
              isCenter: true,
              gradient: LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: StatusCard(
              icon: Icons.attach_money,
              title: _averagePriceText,
              subtitle: 'Avg. Price',
              isCenter: true,
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
