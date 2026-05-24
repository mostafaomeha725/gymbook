import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/freeze_subscription_usecase.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/unfreeze_subscription_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/freeze_subscription_cubit/freeze_subscription_state.dart';

class FreezeSubscriptionCubit extends Cubit<FreezeSubscriptionState> {
  FreezeSubscriptionCubit({
    required this.freezeSubscriptionUseCase,
    required this.unfreezeSubscriptionUseCase,
  }) : super(FreezeSubscriptionInitial());

  final FreezeSubscriptionUseCase freezeSubscriptionUseCase;
  final UnfreezeSubscriptionUseCase unfreezeSubscriptionUseCase;

  Future<void> submit({
    required int subscriptionId,
    required bool shouldFreeze,
  }) async {
    emit(FreezeSubscriptionLoading());

    final result = shouldFreeze
        ? await freezeSubscriptionUseCase(subscriptionId: subscriptionId)
        : await unfreezeSubscriptionUseCase(subscriptionId: subscriptionId);

    result.fold(
      (failure) => emit(FreezeSubscriptionFailure(failure.message)),
      (_) => emit(FreezeSubscriptionSuccess()),
    );
  }
}
