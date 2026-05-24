part of 'branch_statistics_cubit.dart';

abstract class BranchStatisticsState {}

class BranchStatisticsInitial extends BranchStatisticsState {}

class BranchStatisticsLoading extends BranchStatisticsState {}

class BranchStatisticsSuccess extends BranchStatisticsState {
  final BranchStatisticsEntity statistics;
  BranchStatisticsSuccess(this.statistics);
}

class BranchStatisticsFailure extends BranchStatisticsState {
  final String message;
  BranchStatisticsFailure(this.message);
}
