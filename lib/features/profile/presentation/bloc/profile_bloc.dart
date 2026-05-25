import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/refresh_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._getProfileUseCase,
    this._refreshProfileUseCase,
    
  ) : super(const ProfileInitialState()) {
    on<LoadProfileEvent>(_onLoad);
    on<RefreshProfileEvent>(_onRefresh);
  }

  final GetProfileUseCase _getProfileUseCase;
  final RefreshProfileUseCase _refreshProfileUseCase;
 

  Future<void> _onLoad(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoadingState());

    final result = await _getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        ProfileErrorState(message: _mapFailure(failure)),
      ),
      (profile) => emit(ProfileLoadedState(profile: profile)),
    );
  }

  Future<void> _onRefresh(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _refreshProfileUseCase(const NoParams());

    result.fold(
      (failure) {
        // Keep existing data on refresh failure
        final current = state;
        if (current is ProfileLoadedState) {
          emit(current);
        } else {
          emit(ProfileErrorState(message: _mapFailure(failure)));
        }
      },
      (profile) => emit(ProfileLoadedState(profile: profile)),
    );
  }


  String _mapFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() =>
        'No internet connection. Check your connection.',
      ServerFailure() => 'Could not load profile. Please try again.',
      _ => 'Something went wrong. Please try again.',
    };
  }
}