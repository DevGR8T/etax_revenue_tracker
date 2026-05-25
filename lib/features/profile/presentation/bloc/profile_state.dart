import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class ProfileLoadedState extends ProfileState {
  const ProfileLoadedState({required this.profile});

  final ProfileEntity profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileErrorState extends ProfileState {
  const ProfileErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ProfileLoggedOutState extends ProfileState {
  const ProfileLoggedOutState();
}