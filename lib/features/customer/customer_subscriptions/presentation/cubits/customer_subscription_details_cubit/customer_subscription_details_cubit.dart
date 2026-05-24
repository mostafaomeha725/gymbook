import 'package:bloc/bloc.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/usecases/get_customer_subscription_details_usecase.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscription_details_cubit/customer_subscription_details_state.dart';

class CustomerSubscriptionDetailsCubit
    extends Cubit<CustomerSubscriptionDetailsState> {
  final GetCustomerSubscriptionDetailsUseCase _useCase;

  CustomerSubscriptionDetailsCubit(this._useCase)
    : super(CustomerSubscriptionDetailsInitial());

  Future<void> loadDetails({required int subscriptionId}) async {
    emit(CustomerSubscriptionDetailsLoading());
    final result = await _useCase(subscriptionId: subscriptionId);
    result.fold(
      (failure) => emit(CustomerSubscriptionDetailsFailure(failure.message)),
      (details) => emit(CustomerSubscriptionDetailsSuccess(details)),
    );
  }
}
