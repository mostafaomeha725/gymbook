import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/subscription_attendance_history_cubit/subscription_attendance_history_cubit.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/subscription_attendance_history_cubit/subscription_attendance_history_state.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/attendance_history_filters.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/widgets/attendance_week_widget.dart';

class AttendanceHistoryCard extends StatefulWidget {
  final int subscriptionId;

  const AttendanceHistoryCard({super.key, required this.subscriptionId});

  @override
  State<AttendanceHistoryCard> createState() => _AttendanceHistoryCardState();
}

class _AttendanceHistoryCardState extends State<AttendanceHistoryCard> {
  late final SubscriptionAttendanceHistoryCubit _cubit;
  late int _selectedYear;
  late int _selectedMonth;

  List<int> _yearOptions() {
    final now = DateTime.now().year;
    const startYear = 2026;
    final count = (now - startYear + 1).clamp(1, 50);
    return List<int>.generate(count, (index) => startYear + index);
  }

  void _reloadHistory() {
    _cubit.loadAttendanceHistory(
      subscriptionId: widget.subscriptionId,
      year: _selectedYear,
      month: _selectedMonth,
    );
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    _cubit = sl<SubscriptionAttendanceHistoryCubit>()
      ..loadAttendanceHistory(
        subscriptionId: widget.subscriptionId,
        year: _selectedYear,
        month: _selectedMonth,
      );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Container(
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20.r,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: const Color(0xff2196F3),
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                AppText(
                  'Attendance History',
                  style: font18w700.copyWith(color: const Color(0xff2E3A46)),
                ),
              ],
            ),

            SizedBox(height: 16.h),
            AttendanceHistoryFilters(
              selectedMonth: _selectedMonth,
              selectedYear: _selectedYear,
              yearOptions: _yearOptions(),
              onMonthChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedMonth = value;
                });
                _reloadHistory();
              },
              onYearChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedYear = value;
                });
                _reloadHistory();
              },
            ),

            SizedBox(height: 24.h),
            BlocBuilder<
              SubscriptionAttendanceHistoryCubit,
              SubscriptionAttendanceHistoryState
            >(
              builder: (context, state) {
                if (state is SubscriptionAttendanceHistoryLoading ||
                    state is SubscriptionAttendanceHistoryInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SubscriptionAttendanceHistoryFailure) {
                  return Center(
                    child: Column(
                      children: [
                        AppText(
                          state.message,
                          alignment: AlignmentDirectional.center,
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () {
                            context
                                .read<SubscriptionAttendanceHistoryCubit>()
                                .loadAttendanceHistory(
                                  subscriptionId: widget.subscriptionId,
                                  year: _selectedYear,
                                  month: _selectedMonth,
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final successState =
                    state as SubscriptionAttendanceHistorySuccess;
                final weeks = successState.weeks;

                return Column(
                  children: List.generate(weeks.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == weeks.length - 1 ? 0 : 20.h,
                      ),
                      child: AttendanceWeekWidget(
                        title: 'Week ${index + 1}',
                        days: weeks[index],
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
