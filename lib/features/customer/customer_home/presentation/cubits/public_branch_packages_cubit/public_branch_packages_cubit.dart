import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/customer/customer_home/data/datasources/public_branch_packages_remote_datasource.dart';
import 'package:gymbook/features/customer/customer_home/presentation/cubits/public_branch_packages_cubit/public_branch_packages_state.dart';

class PublicBranchPackagesCubit extends Cubit<PublicBranchPackagesState> {
  final PublicBranchPackagesRemoteDataSource remoteDataSource;

  PublicBranchPackagesCubit(this.remoteDataSource)
      : super(PublicBranchPackagesInitial());

  static const int _pageSize = 5;

  int _currentPage = 1;
  late int _branchId;

  Future<void> init(int branchId) async {
    _branchId = branchId;
    _currentPage = 1;
    await _load();
  }

  Future<void> changePage(int page) async {
    if (_currentPage == page) return;
    _currentPage = page;
    await _load();
  }

  Future<void> _load() async {
    if (state is! PublicBranchPackagesLoaded) {
      emit(PublicBranchPackagesLoading());
    }

    try {
      final response = await remoteDataSource.getBranchPackages(
        branchId: _branchId,
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );
      emit(PublicBranchPackagesLoaded(response));
    } catch (e) {
      if (state is! PublicBranchPackagesLoaded) {
        emit(PublicBranchPackagesFailure(e.toString()));
      }
    }
  }
}
