import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/customer/customer_subscriptions/data/models/customer_subscription_model.dart';
import 'package:gymbook/features/customer/customer_subscriptions/domain/usecases/get_customer_subscriptions_usecase.dart';
import 'package:gymbook/features/customer/customer_subscriptions/presentation/cubits/customer_subscriptions_cubit/customer_subscriptions_state.dart';

class CustomerSubscriptionsCubit extends Cubit<CustomerSubscriptionsState> {
  final GetCustomerSubscriptionsUseCase getCustomerSubscriptionsUseCase;

  CustomerSubscriptionsCubit(this.getCustomerSubscriptionsUseCase)
    : super(CustomerSubscriptionsInitial());

  StreamSubscription? _subscription;
  bool _isFetchingMore = false;
  List<CustomerSubscriptionModel> _accumulatedItems = [];
  int _currentPage = 1;
  static const int _pageSize = 5;

  Future<void> loadSubscriptions({
    int? pageNumber,
    int? status,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _accumulatedItems.clear();
    } else if (pageNumber != null) {
      if (_currentPage != pageNumber) {
        _currentPage = pageNumber;
        _accumulatedItems.clear();
      }
    }

    await _subscription?.cancel();

    if (state is! CustomerSubscriptionsLoaded) {
      emit(CustomerSubscriptionsLoading());
    }

    _subscription =
        getCustomerSubscriptionsUseCase(
          pageNumber: _currentPage,
          pageSize: _pageSize,
          status: status,
        ).listen((result) {
          result.fold(
            (failure) {
              if (isClosed) return;
              if (state is! CustomerSubscriptionsLoaded) {
                emit(CustomerSubscriptionsError(failure.message));
              }
            },
            (data) {
              if (isClosed) return;
              if (_currentPage == 1) {
                _accumulatedItems = List.from(data.data);
              } else {
                _accumulatedItems.addAll(data.data);
              }
              emit(
                CustomerSubscriptionsLoaded(
                  pageModel: data,
                  items: List.from(_accumulatedItems),
                  isFetchingMore: false,
                  hasReachedMax: _currentPage >= data.totalPages || data.data.isEmpty,
                ),
              );
            },
          );
        });
  }

  Future<void> loadMore({int? status}) async {
    if (_isFetchingMore) return;
    if (state is! CustomerSubscriptionsLoaded) return;

    final currentState = state as CustomerSubscriptionsLoaded;
    if (currentState.hasReachedMax) return;

    _isFetchingMore = true;
    _currentPage++;
    emit(currentState.copyWith(isFetchingMore: true));

    _subscription?.cancel();

    _subscription =
        getCustomerSubscriptionsUseCase(
          pageNumber: _currentPage,
          pageSize: _pageSize,
          status: status,
        ).listen((result) {
          _isFetchingMore = false;
          result.fold(
            (failure) {
              if (isClosed) return;
              _currentPage--;
              emit(currentState.copyWith(isFetchingMore: false));
            },
            (data) {
              if (isClosed) return;
              _accumulatedItems.addAll(data.data);
              emit(
                CustomerSubscriptionsLoaded(
                  pageModel: data,
                  items: List.from(_accumulatedItems),
                  isFetchingMore: false,
                  hasReachedMax: _currentPage >= data.totalPages || data.data.isEmpty,
                ),
              );
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
