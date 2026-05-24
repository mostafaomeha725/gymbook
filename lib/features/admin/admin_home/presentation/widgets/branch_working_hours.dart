import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/branch_setup_details_entity.dart';
import 'package:gymbook/features/admin/admin_home/presentation/widgets/day_working_card.dart';

part 'branch_working_hours_actions.dart';

class BranchWorkingHours extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onHoursChanged;
  final List<BranchSetupWorkingHourEntity>? initialWorkingHours;

  const BranchWorkingHours({
    super.key,
    this.onHoursChanged,
    this.initialWorkingHours,
  });

  @override
  State<BranchWorkingHours> createState() => _BranchWorkingHoursState();
}

class _BranchWorkingHoursState extends State<BranchWorkingHours> {
  final List<Map<String, dynamic>> workingDays = [
    {
      'day': 'Saturday',
      'dayIndex': 6,
      'isOpen': false,
      'openTime': '',
      'closeTime': '',
    },
    {
      'day': 'Sunday',
      'dayIndex': 0,
      'isOpen': true,
      'openTime': '',
      'closeTime': '',
    },
    {
      'day': 'Monday',
      'dayIndex': 1,
      'isOpen': true,
      'openTime': '',
      'closeTime': '',
    },
    {
      'day': 'Tuesday',
      'dayIndex': 2,
      'isOpen': true,
      'openTime': '',
      'closeTime': '',
    },
    {
      'day': 'Wednesday',
      'dayIndex': 3,
      'isOpen': true,
      'openTime': '',
      'closeTime': '',
    },
    {
      'day': 'Thursday',
      'dayIndex': 4,
      'isOpen': true,
      'openTime': '',
      'closeTime': '',
    },
    {
      'day': 'Friday',
      'dayIndex': 5,
      'isOpen': false,
      'openTime': '',
      'closeTime': '',
    },
  ];

  late List<TextEditingController> openTimeControllers;
  late List<TextEditingController> closeTimeControllers;
  bool _didApplyInitialData = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _applyInitialWorkingHoursIfNeeded();
    // Notify initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyChanges();
    });
  }

  @override
  void didUpdateWidget(covariant BranchWorkingHours oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialWorkingHours != widget.initialWorkingHours) {
      _didApplyInitialData = false;
      _applyInitialWorkingHoursIfNeeded();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyChanges();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in openTimeControllers) {
      controller.dispose();
    }
    for (var controller in closeTimeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateState(VoidCallback changes) {
    setState(changes);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workingDays.length,
      itemBuilder: (context, index) {
        final day = workingDays[index];
        return DayWorkingCard(
          day: day['day'],
          isOpen: day['isOpen'],
          openTimeController: openTimeControllers[index],
          closeTimeController: closeTimeControllers[index],
          onStatusChanged: (isOpen) => _updateDayStatus(index, isOpen),
          onOpenTimeChanged: (time) => _updateOpenTime(index, time),
          onCloseTimeChanged: (time) => _updateCloseTime(index, time),
        );
      },
    );
  }
}
