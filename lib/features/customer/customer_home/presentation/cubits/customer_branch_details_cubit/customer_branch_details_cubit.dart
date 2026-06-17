import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/core/constants/app_assets.dart';
import 'package:gymbook/features/customer/customer_home/data/models/customer_branch_details_model.dart';
import 'package:gymbook/features/customer/customer_home/domain/usecases/get_customer_branch_details_usecase.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/customer_branch_details_cubit/customer_branch_details_state.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/opening_hours_card.dart';
import 'package:gymbook/features/customer/customer_home/presentation/widgets/subscription_plan_card.dart';

class CustomerBranchDetailsCubit extends Cubit<CustomerBranchDetailsState> {
  final GetCustomerBranchDetailsUseCase getBranchDetailsUseCase;

  CustomerBranchDetailsCubit(this.getBranchDetailsUseCase)
    : super(CustomerBranchDetailsInitial());

  Future<void> loadBranchDetails(int branchId) async {
    emit(CustomerBranchDetailsLoading());

    final result = await getBranchDetailsUseCase(branchId: branchId);

    result.fold(
      (failure) => emit(CustomerBranchDetailsError(failure.message)),
      (details) {
        final images = details.images
            .map((item) => item.url)
            .where((url) => url.trim().isNotEmpty)
            .toList();
        final displayImages = images.isEmpty
            ? <String>[Assets.gym3, Assets.gym2, Assets.gym3]
            : images;

        final workingHours = _mapWorkingHours(details.workingHours);
        final plans = _mapPlans(details.packages);

        emit(
          CustomerBranchDetailsLoaded(
            details: details,
            displayImages: displayImages,
            workingHours: workingHours,
            plans: plans,
          ),
        );
      },
    );
  }

  String _formatTime(String value) {
    if (value.trim().isEmpty) return '--:--';
    final split = value.split(':');
    if (split.length < 2) return value;
    return '${split[0].padLeft(2, '0')}:${split[1].padLeft(2, '0')}';
  }

  List<WorkingHourViewModel> _mapWorkingHours(
    List<CustomerWorkingHourModel> workingHours,
  ) {
    const dayNames = {
      0: 'Sunday',
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
    };

    final mapped =
        workingHours
            .map(
              (item) => WorkingHourViewModel(
                dayName: dayNames[item.day] ?? 'Day ${item.day}',
                hoursLabel: item.isClosed
                    ? 'Closed'
                    : '${_formatTime(item.openTime)} - ${_formatTime(item.closeTime)}',
                dayIndex: item.day,
              ),
            )
            .toList()
          ..sort((a, b) => a.dayIndex.compareTo(b.dayIndex));

    return mapped;
  }

  List<PlanModel> _mapPlans(List<CustomerPackageModel> packages) {
    return packages
        .map(
          (item) => PlanModel(
            title: item.name,
            price: item.price,
            duration:
                '${item.durationInMonths} month${item.durationInMonths == 1 ? '' : 's'}',
          ),
        )
        .toList();
  }
}
