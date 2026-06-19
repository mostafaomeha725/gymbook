import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/usecases/get_customer_subscription_details_usecase.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscription_details_cubit/customer_subscription_details_state.dart';

class CustomerSubscriptionDetailsCubit
    extends Cubit<CustomerSubscriptionDetailsState> {
  final GetCustomerSubscriptionDetailsUseCase _useCase;
  StreamSubscription? _subscription;

  CustomerSubscriptionDetailsCubit(this._useCase)
    : super(CustomerSubscriptionDetailsInitial());

  Future<void> loadDetails({required int subscriptionId}) async {
    await _subscription?.cancel();

    if (state is! CustomerSubscriptionDetailsSuccess) {
      emit(CustomerSubscriptionDetailsLoading());
    }

    _subscription = _useCase(subscriptionId: subscriptionId).listen((result) {
      result.fold(
        (failure) {
          if (state is! CustomerSubscriptionDetailsSuccess) {
            emit(CustomerSubscriptionDetailsFailure(failure.message));
          }
        },
        (details) {
          emit(CustomerSubscriptionDetailsSuccess(details));
        },
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
