import 'package:gymbook/features/admin_home/domain/entities/governorate_entity.dart';

abstract class GovernoratesState {}

class GovernoratesInitial extends GovernoratesState {}

class GovernoratesLoading extends GovernoratesState {}

class GovernoratesLoaded extends GovernoratesState {
  final List<GovernorateEntity> governorates;

  GovernoratesLoaded(this.governorates);
}

class GovernoratesFailure extends GovernoratesState {
  final String message;

  GovernoratesFailure(this.message);
}
