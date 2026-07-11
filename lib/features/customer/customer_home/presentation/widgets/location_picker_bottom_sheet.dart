import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer/customer_home/presentation/models/saved_location.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/location_picker_sheet_widgets/location_picker_header.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/location_picker_sheet_widgets/location_picker_actions.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/location_picker_sheet_widgets/saved_location_item.dart';

class LocationPickerBottomSheet extends StatefulWidget {
  final List<SavedLocation> savedLocations;
  final String? selectedLocationId;
  final ValueChanged<SavedLocation> onSelectSaved;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onChooseFromMap;
  final VoidCallback? onClearLocation;
  final ValueChanged<SavedLocation>? onDeleteLocation;

  const LocationPickerBottomSheet({
    super.key,
    required this.savedLocations,
    required this.selectedLocationId,
    required this.onSelectSaved,
    required this.onUseCurrentLocation,
    required this.onChooseFromMap,
    this.onClearLocation,
    this.onDeleteLocation,
  });

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  late List<SavedLocation> _currentLocations;
  late String? _currentSelectedId;

  @override
  void initState() {
    super.initState();
    // Deduplicate by id, keeping the first occurrence (most recent)
    final seen = <String>{};
    _currentLocations = widget.savedLocations
        .where((loc) => seen.add(loc.id))
        .toList();
    _currentSelectedId = widget.selectedLocationId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LocationPickerHeader(
                showClearAll:
                    _currentLocations.isNotEmpty &&
                    widget.onClearLocation != null,
                onClearAll: () {
                  setState(() {
                    _currentLocations.clear();
                    _currentSelectedId = null;
                  });
                  if (widget.onClearLocation != null) {
                    widget.onClearLocation!();
                  }
                },
              ),
              SizedBox(height: 12.h),

              if (_currentLocations.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    'Saved Locations',
                    style: font14w500.copyWith(color: const Color(0xff64748B)),
                  ),
                ),
                SizedBox(height: 12.h),
                ..._currentLocations.map((location) {
                  return SavedLocationItem(
                    location: location,
                    isSelected: _currentSelectedId == location.id,
                    onTap: () => widget.onSelectSaved(location),
                    onDelete: widget.onDeleteLocation != null
                        ? () {
                            setState(() {
                              _currentLocations.remove(location);
                              if (_currentSelectedId == location.id) {
                                _currentSelectedId = null;
                              }
                            });
                            widget.onDeleteLocation!(location);
                          }
                        : null,
                  );
                }),
                SizedBox(height: 8.h),
                Divider(color: Colors.grey.shade200, height: 24.h),
              ],

              LocationPickerActions(
                onUseCurrentLocation: widget.onUseCurrentLocation,
                onChooseFromMap: widget.onChooseFromMap,
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
