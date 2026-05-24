import 'package:bloc/bloc.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/add_subscription_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/add_subscription_usecase.dart';

part 'add_subscription_state.dart';

class AddSubscriptionCubit extends Cubit<AddSubscriptionState> {
  AddSubscriptionCubit(this.addSubscriptionUseCase)
    : super(AddSubscriptionInitial());

  final AddSubscriptionUseCase addSubscriptionUseCase;

  Future<void> addSubscription({
    required int branchId,
    required String email,
    required int packageId,
  }) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      showError("Email can't be empty");
      emit(AddSubscriptionFailure("Email can't be empty"));
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(trimmed)) {
      showError('Please enter a valid email address');
      emit(AddSubscriptionFailure('Please enter a valid email address'));
      return;
    }

    emit(AddSubscriptionLoading());
    showLoading();

    final result = await addSubscriptionUseCase(
      branchId: branchId,
      email: trimmed,
      packageId: packageId,
    );

    hideLoading();

    result.fold(
      (failure) {
        showError(failure.message);
        emit(AddSubscriptionFailure(failure.message));
      },
      (entity) {
        showSuccess('Subscription added successfully');
        emit(AddSubscriptionSuccess(entity));
      },
    );
  }
}
