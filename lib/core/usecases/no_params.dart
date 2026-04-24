import 'package:equatable/equatable.dart';

/// Use for use cases that need no input parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}