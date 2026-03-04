import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin_home/domain/usecases/cancel_subscription_usecase.dart';
import 'package:gymbook/features/admin_home/presentation/cubits/cancel_subscription_cubit/cancel_subscription_state.dart';

class CancelSubscriptionCubit extends Cubit<CancelSubscriptionState> {
  CancelSubscriptionCubit(this.cancelSubscriptionUseCase)
    : super(CancelSubscriptionInitial());

  final CancelSubscriptionUseCase cancelSubscriptionUseCase;

  Future<void> cancelSubscription({required int subscriptionId}) async {
    emit(CancelSubscriptionLoading());
    final result = await cancelSubscriptionUseCase(
      subscriptionId: subscriptionId,
    );
    result.fold(
      (failure) => emit(CancelSubscriptionFailure(failure.message)),
      (_) => emit(CancelSubscriptionSuccess()),
    );
  }
}
