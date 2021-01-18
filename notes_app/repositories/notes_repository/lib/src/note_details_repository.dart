import 'dart:async';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:notes_repository/src/data_providers/note_provider.dart';
import 'package:notes_repository/src/models/all_notes.dart';
import 'package:notes_repository/src/models/note.dart';
import 'package:notes_repository/src/models/note_preview.dart';
import 'package:uuid/uuid.dart';

import 'models/note.dart';

class NoteDetailsRepository {
  final _getNoteController = StreamController<Note>.broadcast();
  final _createNoteController = StreamController<Note>.broadcast();
  final _errorController = StreamController<Exception>.broadcast();
  final _notesProvider = NoteProvider();

  NoteDetailsRepository() {
    Hive.registerAdapter(AllNotesAdapter());
    Hive.registerAdapter(NotePreviewAdapter());
    Hive.registerAdapter(NoteAdapter());
  }

  Stream<Note> get get_note async* {
    yield* _getNoteController.stream;
  }

  Stream<Note> get create_note async* {
    yield* _createNoteController.stream;
  }

  Stream<Exception> get errors async* {
    yield* _errorController.stream;
  }

  Future<void> createNote(
    @required String secureKey,
  ) async {
    assert(secureKey != null);
    final note = Note(id: Uuid().v1());
    await _notesProvider
        .saveNote(secureKey, note)
        .then((value) => _createNoteController.add(note))
        .catchError((error) => _emitFailureSideEffect(error));
  }

  Future<void> getNote(@required String secureKey, @required String noteId) async {
    assert(secureKey != null);
    assert(noteId != null);
    await _notesProvider
        .getNote(secureKey, noteId)
        .then((note) => _getNoteController.add(note))
        .catchError((error) => _emitFailureSideEffect(error));
  }

  Future<void> saveNote(
    @required String secureKey,
    @required Note note,
  ) async {
    assert(secureKey != null);
    assert(note != null);
    return _notesProvider.saveNote(secureKey, note);
  }

  Future<void> deleteNote(@required String secureKey, @required String noteId) async {
    assert(secureKey != null);
    assert(noteId != null);
    _notesProvider.deleteNote(secureKey, noteId);
  }

  void _emitFailureSideEffect(Exception error) {
    _errorController.add(error);
  }

  void dispose() => _getNoteController.close();
}
