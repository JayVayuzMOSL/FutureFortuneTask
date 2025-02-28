import 'package:equatable/equatable.dart';

abstract class AddItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddItemInitial extends AddItemState {}

class AddItemLoading extends AddItemState {}

class AddItemSuccess extends AddItemState {}

class AddItemFailure extends AddItemState {
  final String error;
  AddItemFailure(this.error);

  @override
  List<Object?> get props => [error];
}
