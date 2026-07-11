import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gymbook/core/services/notification_refresh_service.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/subscription_item_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_branch_subscriptions_usecase.dart';

part 'branch_subscriptions_list_state.dart';

class BranchSubscriptionsListCubit extends Cubit<BranchSubscriptionsListState> {
  BranchSubscriptionsListCubit(this.getBranchSubscriptionsUseCase)
    : super(BranchSubscriptionsListInitial()) {
    _refreshSubscription = NotificationRefreshService().stream.listen((type) {
      if (type == 2) {
        refresh();
      }
    });
  }

  final GetBranchSubscriptionsUseCase getBranchSubscriptionsUseCase;
  StreamSubscription? _subscription;
  StreamSubscription<int>? _refreshSubscription;
  Timer? _debounce;

  static const int _pageSize = 5;
  static const List<int?> _tabStatuses = [null, 1, 0, 2, 3, 4];

  late int branchId;
  int selectedTab = 0;
  int currentPage = 1;
  String? searchText;

  int? get activeStatus => _tabStatuses[selectedTab];

  void init(int id) {
    branchId = id;
    _load();
  }

  void changeTab(int index) {
    if (selectedTab == index) return;
    selectedTab = index;
    currentPage = 1;
    _load();
  }

  void onSearchChanged(String query) {
    final trimValue = query.trim();
    if (trimValue.isNotEmpty && trimValue.length < 3) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      searchText = trimValue.isEmpty ? null : trimValue;
      currentPage = 1;
      _load();
    });
  }

  void onSearchSubmitted(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final trimValue = query.trim();
    searchText = trimValue.isEmpty ? null : trimValue;
    currentPage = 1;
    _load();
  }

  void changePage(int page) {
    if (currentPage == page) return;
    currentPage = page;
    _load();
  }

  void refresh() {
    currentPage = 1;
    _load(isRefresh: true);
  }

  void _load({bool isRefresh = false}) {
    if (!isRefresh && state is! BranchSubscriptionsListSuccess) {
      emit(BranchSubscriptionsListLoading());
    }

    _subscription?.cancel();
    _subscription =
        getBranchSubscriptionsUseCase(
          branchId: branchId,
          pageNumber: currentPage,
          pageSize: _pageSize,
          search: searchText,
          status: activeStatus,
        ).listen((result) {
          result.fold((failure) {
            if (state is! BranchSubscriptionsListSuccess) {
              emit(BranchSubscriptionsListFailure(failure.message));
            }
          }, (entity) => emit(BranchSubscriptionsListSuccess(entity)));
        });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _refreshSubscription?.cancel();
    _debounce?.cancel();
    return super.close();
  }
}
