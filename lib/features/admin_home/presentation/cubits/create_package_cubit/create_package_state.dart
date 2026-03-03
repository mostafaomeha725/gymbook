part of 'create_package_cubit.dart';

sealed class CreatePackageState {}

final class CreatePackageInitial extends CreatePackageState {}

final class CreatePackageLoading extends CreatePackageState {}

final class CreatePackageSuccess extends CreatePackageState {
  final CreatePackageResponse package;
  CreatePackageSuccess(this.package);
}

final class CreatePackageFailure extends CreatePackageState {
  final String message;
  CreatePackageFailure(this.message);
}

final class PackageStatusUpdated extends CreatePackageState {}

final class PackageDeleted extends CreatePackageState {}
