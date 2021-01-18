part of 'notes_overview_bloc.dart';

abstract class NotesOverviewState {}

class NotesOverviewState_NotLoaded extends NotesOverviewState {}

class NotesOverviewState_Loading extends NotesOverviewState {}

class NotesOverviewState_Loaded extends NotesOverviewState {
  NotesOverviewState_Loaded(this.allNotes);

  final AllNotes allNotes;
}

class NotesOverviewState_NoteCreated extends NotesOverviewState {
  NotesOverviewState_NoteCreated(this.note, this.allNotes);

  final AllNotes allNotes;
  final Note note;
}
