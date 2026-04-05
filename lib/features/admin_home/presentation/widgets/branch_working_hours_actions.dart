part of 'branch_working_hours.dart';

extension _BranchWorkingHoursActions on _BranchWorkingHoursState {
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

  TimeOfDay? _parseApiTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final parts = value.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String _toApiTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  void _applyInitialWorkingHoursIfNeeded() {
    if (_didApplyInitialData) return;
    final initialHours = widget.initialWorkingHours;
    if (initialHours == null || initialHours.isEmpty) return;

    final mapByDay = <int, BranchSetupWorkingHourEntity>{
      for (final item in initialHours) item.day: item,
    };

    for (int i = 0; i < workingDays.length; i++) {
      final dayIndex = workingDays[i]['dayIndex'] as int;
      final apiDay = mapByDay[dayIndex];
      if (apiDay == null) continue;

      final openTimeOfDay = _parseApiTime(apiDay.openTime);
      final closeTimeOfDay = _parseApiTime(apiDay.closeTime);
      final openTimeString = openTimeOfDay == null
          ? ''
          : _toApiTime(openTimeOfDay);
      final closeTimeString = closeTimeOfDay == null
          ? ''
          : _toApiTime(closeTimeOfDay);

      workingDays[i]['isOpen'] = !apiDay.isClosed;
      workingDays[i]['openTime'] = openTimeString;
      workingDays[i]['closeTime'] = closeTimeString;

      openTimeControllers[i].text = openTimeString;
      closeTimeControllers[i].text = closeTimeString;
    }

    _didApplyInitialData = true;
  }

  void _notifyChanges() {
    final workingHours = <Map<String, dynamic>>[];
    for (int i = 0; i < workingDays.length; i++) {
      final isOpen = workingDays[i]['isOpen'] as bool;

      if (isOpen) {
        final openTime = openTimeControllers[i].text.trim();
        final closeTime = closeTimeControllers[i].text.trim();

        workingHours.add({
          'day': workingDays[i]['dayIndex'],
          'openTime': openTime.isNotEmpty ? openTime : null,
          'closeTime': closeTime.isNotEmpty ? closeTime : null,
          'isClosed': false,
        });
      } else {
        workingHours.add({
          'day': workingDays[i]['dayIndex'],
          'openTime': null,
          'closeTime': null,
          'isClosed': true,
        });
      }
    }

    widget.onHoursChanged?.call({'workingHours': workingHours});
  }

  void _updateDayStatus(int index, bool isOpen) {
    _updateState(() {
      workingDays[index]['isOpen'] = isOpen;
      if (!isOpen) {
        openTimeControllers[index].clear();
        closeTimeControllers[index].clear();
      }
    });
    _notifyChanges();
  }

  void _updateOpenTime(int index, String time) {
    _updateState(() {
      workingDays[index]['openTime'] = time;
    });
    _notifyChanges();
  }

  void _updateCloseTime(int index, String time) {
    _updateState(() {
      workingDays[index]['closeTime'] = time;
    });
    _notifyChanges();
  }
}
