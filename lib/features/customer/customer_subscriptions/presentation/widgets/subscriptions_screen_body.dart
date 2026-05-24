import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/enums/app_enums.dart' show SubscriptionTab;
import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/core/widgets/appbar_subscription_widget.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/core/widgets/custom_nav_bar.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscription_list_view.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/subscription_tabs.dart';

class SubscriptionsScreenBody extends StatefulWidget {
  const SubscriptionsScreenBody({super.key});

  @override
  State<SubscriptionsScreenBody> createState() =>
      _SubscriptionsScreenBodyState();
}

class _SubscriptionsScreenBodyState extends State<SubscriptionsScreenBody> {
  SubscriptionTab selectedTab = SubscriptionTab.all;
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _subscriptions = const [];

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final networkService = sl<NetworkService>();
    final response = await networkService.getData(
      endPoint: EndPoints.getMySubscriptions,
      queryParameters: {'PageNumber': 1, 'PageSize': 50},
    );

    if (!mounted) return;

    response.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (data) {
        final map = data as Map<String, dynamic>;
        final list = (map['data'] as List<dynamic>? ?? const [])
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        setState(() {
          _isLoading = false;
          _subscriptions = list;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          AppbarSubscriptionWidget(
            text: 'My Subscriptions',
            onBack: () {
              CustomNavBar.of(context)?.goBack();
            },
          ),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SubscriptionTabs(
              selectedTab: selectedTab,
              onChanged: (tab) {
                setState(() {
                  selectedTab = tab;
                });
              },
            ),
          ),

          SizedBox(height: 32.h),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(_errorMessage!),
                        SizedBox(height: 12.h),
                        ElevatedButton(
                          onPressed: _loadSubscriptions,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SubscriptionListView(
                      selectedTab: selectedTab,
                      subscriptions: _subscriptions,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
