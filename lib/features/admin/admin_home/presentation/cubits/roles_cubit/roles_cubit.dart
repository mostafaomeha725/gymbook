import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_roles_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/roles_cubit/roles_state.dart';

class RolesCubit extends Cubit<RolesState> {
  final GetRolesUseCase getRolesUseCase;

  RolesCubit({required this.getRolesUseCase}) : super(RolesInitial());

  Future<void> getRoles() async {
    emit(RolesLoading());
    final result = await getRolesUseCase();
    result.fold(
      (failure) => emit(RolesError(failure.message)),
      (roles) => emit(RolesLoaded(roles)),
    );
  }
}
