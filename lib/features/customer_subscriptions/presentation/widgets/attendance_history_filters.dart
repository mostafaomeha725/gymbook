import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceHistoryFilters extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final List<int> yearOptions;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  const AttendanceHistoryFilters({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.yearOptions,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  static const List<String> _monthNames = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedMonth,
            items: List.generate(12, (index) {
              final month = index + 1;
              return DropdownMenuItem<int>(
                value: month,
                child: Text(_monthNames[index]),
              );
            }),
            onChanged: onMonthChanged,
            decoration: const InputDecoration(
              labelText: 'Month',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedYear,
            items: yearOptions.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: onYearChanged,
            decoration: const InputDecoration(
              labelText: 'Year',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
