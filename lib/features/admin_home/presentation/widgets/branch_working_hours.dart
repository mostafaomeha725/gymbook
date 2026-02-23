import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/features/admin_home/presentation/widgets/day_working_card.dart';

class BranchWorkingHours extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onHoursChanged;

  const BranchWorkingHours({super.key, this.onHoursChanged});

  @override
  State<BranchWorkingHours> createState() => _BranchWorkingHoursState();
}

class _BranchWorkingHoursState extends State<BranchWorkingHours> {
  final List<Map<String, dynamic>> workingDays = [
    {'day': 'Saturday', 'isOpen': false, 'openTime': '', 'closeTime': ''},
    {'day': 'Sunday', 'isOpen': true, 'openTime': '', 'closeTime': ''},
    {'day': 'Monday', 'isOpen': true, 'openTime': '', 'closeTime': ''},
    {'day': 'Tuesday', 'isOpen': true, 'openTime': '', 'closeTime': ''},
    {'day': 'Wednesday', 'isOpen': true, 'openTime': '', 'closeTime': ''},
    {'day': 'Thursday', 'isOpen': true, 'openTime': '', 'closeTime': ''},
    {'day': 'Friday', 'isOpen': false, 'openTime': '', 'closeTime': ''},
  ];

  late List<TextEditingController> openTimeControllers;
  late List<TextEditingController> closeTimeControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Notify initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyChanges();
    });
  }

  void _initializeControllers() {
    openTimeControllers = List.generate(
      workingDays.length,
      (index) => TextEditingController(text: workingDays[index]['openTime']),
    );
    closeTimeControllers = List.generate(
      workingDays.length,
      (index) => TextEditingController(text: workingDays[index]['closeTime']),
    );
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

  void _notifyChanges() {
    final workingHours = <Map<String, dynamic>>[];
    for (int i = 0; i < workingDays.length; i++) {
      final isOpen = workingDays[i]['isOpen'] as bool;

      if (isOpen) {
        final openTime = openTimeControllers[i].text.trim();
        final closeTime = closeTimeControllers[i].text.trim();

        workingHours.add({
          'day': i,
          'openTime': openTime.isNotEmpty ? openTime : null,
          'closeTime': closeTime.isNotEmpty ? closeTime : null,
          'isClosed': false,
        });
      } else {
        workingHours.add({
          'day': i,
          'openTime': null,
          'closeTime': null,
          'isClosed': true,
        });
      }
    }

    widget.onHoursChanged?.call({'workingHours': workingHours});
  }

  void _updateDayStatus(int index, bool isOpen) {
    setState(() {
      workingDays[index]['isOpen'] = isOpen;
      if (!isOpen) {
        openTimeControllers[index].clear();
        closeTimeControllers[index].clear();
      }
    });
    _notifyChanges();
  }

  void _updateOpenTime(int index, String time) {
    setState(() {
      workingDays[index]['openTime'] = time;
    });
    _notifyChanges();
  }

  void _updateCloseTime(int index, String time) {
    setState(() {
      workingDays[index]['closeTime'] = time;
    });
    _notifyChanges();
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
