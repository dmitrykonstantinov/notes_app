part of 'note_details_bloc.dart';

abstract class NoteDetailsState {}

class NoteDetailsState_NotLoaded extends NoteDetailsState {}

class NoteDetailsState_Loading extends NoteDetailsState {}

class NoteDetailsState_Loaded extends NoteDetailsState {
  NoteDetailsState_Loaded(this.note);

  final Note note;
}
