import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_subscriptions_usecase.dart';

part 'branch_subscriptions_list_state.dart';

class BranchSubscriptionsListCubit extends Cubit<BranchSubscriptionsListState> {
  BranchSubscriptionsListCubit(this.getBranchSubscriptionsUseCase)
    : super(BranchSubscriptionsListInitial());

  final GetBranchSubscriptionsUseCase getBranchSubscriptionsUseCase;
  StreamSubscription? _subscription;

  static const int _pageSize = 10;

  Future<void> loadSubscriptions({
    required int branchId,
    int pageNumber = 1,
    String? search,
    int? status,
  }) async {
    if (state is! BranchSubscriptionsListSuccess) {
      emit(BranchSubscriptionsListLoading());
    }

    _subscription?.cancel();
    _subscription = getBranchSubscriptionsUseCase(
      branchId: branchId,
      pageNumber: pageNumber,
      pageSize: _pageSize,
      search: search,
      status: status,
    ).listen((result) {
      result.fold(
        (failure) {
          if (state is! BranchSubscriptionsListSuccess) {
            emit(BranchSubscriptionsListFailure(failure.message));
          }
        },
        (entity) => emit(BranchSubscriptionsListSuccess(entity)),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
