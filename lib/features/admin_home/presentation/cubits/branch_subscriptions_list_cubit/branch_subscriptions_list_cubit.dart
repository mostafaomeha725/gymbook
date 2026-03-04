import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin_home/domain/usecases/get_branch_subscriptions_usecase.dart';

part 'branch_subscriptions_list_state.dart';

class BranchSubscriptionsListCubit extends Cubit<BranchSubscriptionsListState> {
  BranchSubscriptionsListCubit(this.getBranchSubscriptionsUseCase)
    : super(BranchSubscriptionsListInitial());

  final GetBranchSubscriptionsUseCase getBranchSubscriptionsUseCase;

  static const int _pageSize = 10;

  Future<void> loadSubscriptions({
    required int branchId,
    int pageNumber = 1,
    String? search,
    int? status,
  }) async {
    emit(BranchSubscriptionsListLoading());

    final result = await getBranchSubscriptionsUseCase(
      branchId: branchId,
      pageNumber: pageNumber,
      pageSize: _pageSize,
      search: search,
      status: status,
    );

    result.fold(
      (failure) => emit(BranchSubscriptionsListFailure(failure.message)),
      (entity) => emit(BranchSubscriptionsListSuccess(entity)),
    );
  }
}
