import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/usecases/get_customer_subscriptions_usecase.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscriptions_cubit/customer_subscriptions_state.dart';

class CustomerSubscriptionsCubit extends Cubit<CustomerSubscriptionsState> {
  final GetCustomerSubscriptionsUseCase getCustomerSubscriptionsUseCase;

  CustomerSubscriptionsCubit(this.getCustomerSubscriptionsUseCase)
    : super(CustomerSubscriptionsInitial());

  StreamSubscription? _subscription;

  Future<void> loadSubscriptions({
    int pageNumber = 1,
    int pageSize = 5,
  }) async {
    await _subscription?.cancel();

    if (state is! CustomerSubscriptionsLoaded) {
      emit(CustomerSubscriptionsLoading());
    }

    _subscription =
        getCustomerSubscriptionsUseCase(
          pageNumber: pageNumber,
          pageSize: pageSize,
        ).listen((result) {
          result.fold(
            (failure) {
              if (state is! CustomerSubscriptionsLoaded) {
                emit(CustomerSubscriptionsError(failure.message));
              }
            },
            (data) {
              emit(CustomerSubscriptionsLoaded(data));
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
