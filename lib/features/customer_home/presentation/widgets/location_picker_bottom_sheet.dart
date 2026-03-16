import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymbook/core/theme/styles.dart';
import 'package:gymbook/core/widgets/custom_text.dart';
import 'package:gymbook/features/customer_home/presentation/models/saved_location.dart';

class LocationPickerBottomSheet extends StatelessWidget {
  final List<SavedLocation> savedLocations;
  final String? selectedLocationId;
  final ValueChanged<SavedLocation> onSelectSaved;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onChooseFromMap;

  const LocationPickerBottomSheet({
    super.key,
    required this.savedLocations,
    required this.selectedLocationId,
    required this.onSelectSaved,
    required this.onUseCurrentLocation,
    required this.onChooseFromMap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  AppText('Choose location', style: font16w600),
                ],
              ),
              SizedBox(height: 10.h),
              if (savedLocations.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText('Saved locations', style: font14w500),
                ),
              if (savedLocations.isNotEmpty) SizedBox(height: 6.h),
              ...savedLocations.map((location) {
                final isSelected = selectedLocationId == location.id;
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    tileColor: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.08)
                        : null,
                    leading: Icon(
                      Icons.place_outlined,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(
                      location.label,
                      softWrap: true,
                      style: isSelected ? font14w500 : null,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => onSelectSaved(location),
                  ),
                );
              }),
              if (savedLocations.isNotEmpty) SizedBox(height: 6.h),
              if (savedLocations.isNotEmpty) const Divider(),
              SizedBox(height: 6.h),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                leading: const Icon(Icons.my_location),
                title: const Text('Use and save current location'),
                onTap: onUseCurrentLocation,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                leading: const Icon(Icons.edit_location_alt_outlined),
                title: const Text('Choose and save location from map'),
                onTap: onChooseFromMap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
