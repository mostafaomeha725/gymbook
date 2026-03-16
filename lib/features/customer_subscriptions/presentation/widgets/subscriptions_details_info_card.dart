import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';

class SubscriptionsDetailsInfoCard extends StatefulWidget {
  final int subscriptionId;
  final int status;
  final String packageName;
  final double price;
  final String activationDate;
  final String endDate;
  final int durationInDays;
  final int checkInsCount;
  final ValueChanged<int> onStatusChanged;

  const SubscriptionsDetailsInfoCard({
    super.key,
    required this.subscriptionId,
    required this.status,
    required this.packageName,
    required this.price,
    required this.activationDate,
    required this.endDate,
    required this.durationInDays,
    required this.checkInsCount,
    required this.onStatusChanged,
  });

  @override
  State<SubscriptionsDetailsInfoCard> createState() =>
      _SubscriptionsDetailsInfoCardState();
}

class _SubscriptionsDetailsInfoCardState
    extends State<SubscriptionsDetailsInfoCard> {
  bool _isLoading = false;

  bool get _isFrozen => widget.status == 2;
  bool get _canToggleFreeze => widget.status == 1 || widget.status == 2;

  Future<void> _toggleFreeze() async {
    if (widget.subscriptionId <= 0 || _isLoading || !_canToggleFreeze) return;
    final wasFrozen = _isFrozen;

    setState(() {
      _isLoading = true;
    });

    final networkService = sl<NetworkService>();
    final response = await networkService.patchData(
      endPoint: _isFrozen
          ? EndPoints.unfreezeSubscription(widget.subscriptionId)
          : EndPoints.freezeSubscription(widget.subscriptionId),
      data: {},
    );

    if (!mounted) return;

    response.fold(
      (message) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      },
      (_) {
        setState(() {
          _isLoading = false;
        });
        widget.onStatusChanged(wasFrozen ? 1 : 2);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              wasFrozen
                  ? 'Subscription unfrozen successfully'
                  : 'Subscription frozen successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeDuration = widget.durationInDays <= 0 ? 1 : widget.durationInDays;
    final safeCheckIns = widget.checkInsCount.clamp(0, safeDuration);
    final progress = (safeCheckIns / safeDuration).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Subscription Details",
            style: font18w700.copyWith(color: const Color(0xff2E3A46)),
          ),

          SizedBox(height: 24.h),

          _buildRow("Plan", widget.packageName),

          SizedBox(height: 18.h),

          _buildRow("Price", '${widget.price.toStringAsFixed(2)} EGP'),

          SizedBox(height: 18.h),

          _buildRow("Start Date", _formatDate(widget.activationDate)),

          SizedBox(height: 18.h),

          _buildRow("Expires On", _formatDate(widget.endDate)),

          SizedBox(height: 24.h),

          Divider(color: Colors.grey.shade200),

          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Sessions Used",
                style: font16w500.copyWith(color: Colors.grey[700]),
              ),
              AppText(
                '$safeCheckIns/${widget.durationInDays <= 0 ? 0 : widget.durationInDays}',
                style: font16w700.copyWith(color: const Color(0xff2E3A46)),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(Color(0xff0A0A1A)),
            ),
          ),

          SizedBox(height: 28.h),

          if (_canToggleFreeze)
            BouncingSocialButton(
              text: _isLoading
                  ? 'Processing...'
                  : _isFrozen
                  ? 'Unfreeze Subscription'
                  : 'Freeze Subscription',
              borderColor: const Color(0xffF54900),
              icon: _isFrozen ? Icons.play_arrow : Icons.pause,
              onTap: _toggleFreeze,
              textSize: 14.sp,
              textColor: const Color(0xffF54900),
            ),
        ],
      ),
    );
  }

  String _formatDate(String value) {
    if (value.trim().isEmpty) return '--';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final month = _monthName(parsed.month);
    final day = parsed.day.toString().padLeft(2, '0');
    return '$month $day, ${parsed.year}';
  }

  String _monthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(title, style: font16w400.copyWith(color: Colors.grey[600])),
        AppText(
          value,
          style: font16w700.copyWith(color: const Color(0xff2E3A46)),
        ),
      ],
    );
  }
}
