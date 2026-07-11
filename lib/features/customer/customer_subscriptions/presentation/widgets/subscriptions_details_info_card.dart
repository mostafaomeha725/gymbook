import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/widgets/bouncing_social_button.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/utils/subscription_date_formatter.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscription_info_row.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscription_sessions_progress.dart';

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
        showError(message);
      },
      (_) {
        setState(() {
          _isLoading = false;
        });
        widget.onStatusChanged(wasFrozen ? 1 : 2);
        showSuccess(
          wasFrozen
              ? 'Subscription unfrozen successfully'
              : 'Subscription frozen successfully',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

          SubscriptionInfoRow(title: "Plan", value: widget.packageName),

          SizedBox(height: 18.h),

          SubscriptionInfoRow(
            title: "Price",
            value: '${widget.price.toStringAsFixed(2)} EGP',
          ),

          SizedBox(height: 18.h),

          SubscriptionInfoRow(
            title: "Start Date",
            value: SubscriptionDateFormatter.formatDate(widget.activationDate),
          ),

          SizedBox(height: 18.h),

          SubscriptionInfoRow(
            title: "Expires On",
            value: SubscriptionDateFormatter.formatDate(widget.endDate),
          ),

          SizedBox(height: 24.h),

          Divider(color: Colors.grey.shade200),

          SizedBox(height: 20.h),

          SubscriptionSessionsProgress(
            checkInsCount: widget.checkInsCount,
            durationInDays: widget.durationInDays,
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
}
