part of 'notes_overview_bloc.dart';

abstract class NotesOverviewEvent {
  const NotesOverviewEvent();
}

class NotesOverviewEvent_Load extends NotesOverviewEvent {

  NotesOverviewEvent_Load();
}

class NotesOverviewEvent_Loaded extends NotesOverviewEvent {
  final AllNotes allNotes;

  const NotesOverviewEvent_Loaded(AllNotes allNotes) : this.allNotes = allNotes;
}

class NotesOverviewEvent_CreateNote extends NotesOverviewEvent {

  NotesOverviewEvent_CreateNote();
}

class NotesOverviewEvent_NoteCreated extends NotesOverviewEvent {
  final Note note;

  NotesOverviewEvent_NoteCreated(Note note) : this.note = note;
}

class NotesOverviewEvent_NoteDelete extends NotesOverviewEvent {
  final String id;

  NotesOverviewEvent_NoteDelete(String id) : this.id = id;
}
