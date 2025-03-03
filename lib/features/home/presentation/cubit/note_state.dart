import 'package:equatable/equatable.dart';
import 'package:future_fortune_task/features/home/data/models/note_model.dart';

abstract class NoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}
class NoteLoading extends NoteState {}
class NoteSuccess extends NoteState {}
class NoteLogoutSuccess extends NoteState {}
class NoteFailure extends NoteState {
  final String error;
  NoteFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class NoteLoaded extends NoteState {
  final List<NoteModel> notes;
  NoteLoaded(this.notes);
  @override
  List<Object?> get props => [notes];
}
