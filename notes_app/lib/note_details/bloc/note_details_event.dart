part of 'note_details_bloc.dart';

abstract class NoteDetailsEvent {
  const NoteDetailsEvent();
}

class NoteDetailsEvent_Load extends NoteDetailsEvent {
  final String noteId;

  const NoteDetailsEvent_Load(String noteId) : this.noteId = noteId;
}

class NoteDetailsEvent_Loaded extends NoteDetailsEvent {
  final Note note;

  const NoteDetailsEvent_Loaded(Note note) : this.note = note;
}

class NoteDetailsEvent_NameChanged extends NoteDetailsEvent {
  final String name;
  final Note note;

  const NoteDetailsEvent_NameChanged(String name, Note note)
      : this.name = name,
        this.note = note;
}

class NoteDetailsEvent_ContentChanged extends NoteDetailsEvent {
  final String content;
  final Note note;

  const NoteDetailsEvent_ContentChanged(String content, Note note)
      : this.content = content,
        this.note = note;
}
