import 'package:bloc/bloc.dart';
import 'package:gymbook/features/admin/admin_home/domain/entities/governorate_entity.dart';
import 'package:gymbook/features/admin/admin_home/domain/usecases/get_governorates_usecase.dart';
import 'package:gymbook/features/admin/admin_home/presentation/cubits/governorates_cubit/governorates_state.dart';

class GovernoratesCubit extends Cubit<GovernoratesState> {
  GovernoratesCubit(this.getGovernoratesUseCase) : super(GovernoratesInitial());

  final GetGovernoratesUseCase getGovernoratesUseCase;
  List<GovernorateEntity> _cache = const [];

  Future<void> getAllGovernorates({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache.isNotEmpty) {
      emit(GovernoratesLoaded(_cache));
      return;
    }

    if (state is GovernoratesLoading) return;

    emit(GovernoratesLoading());

    final result = await getGovernoratesUseCase();

    result.fold((failure) => emit(GovernoratesFailure(failure.message)), (
      list,
    ) {
      _cache = list;
      emit(GovernoratesLoaded(list));
    });
  }
}
