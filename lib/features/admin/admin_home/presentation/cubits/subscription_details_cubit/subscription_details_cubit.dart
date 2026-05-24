import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_subscription_details_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/subscription_details_cubit/subscription_details_state.dart';

class SubscriptionDetailsCubit extends Cubit<SubscriptionDetailsState> {
  SubscriptionDetailsCubit(this._useCase) : super(SubscriptionDetailsInitial());

  final GetSubscriptionDetailsUseCase _useCase;

  Future<void> loadDetails(int subscriptionId) async {
    emit(SubscriptionDetailsLoading());
    final result = await _useCase(subscriptionId);
    result.fold(
      (failure) => emit(SubscriptionDetailsFailure(failure.message)),
      (details) => emit(SubscriptionDetailsSuccess(details)),
    );
  }
}
