import 'dart:async';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:notes_repository/src/data_providers/note_provider.dart';
import 'package:notes_repository/src/models/all_notes.dart';
import 'package:notes_repository/src/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_repository/src/models/note_preview.dart';

import 'models/note.dart';

class NotesOverviewRepository {
  final _noteListController = StreamController<AllNotes>.broadcast();
  final _errorController = StreamController<Exception>.broadcast();
  final _notesProvider = NoteProvider();

  NoteDetailsRepository() {
    Hive.registerAdapter(AllNotesAdapter());
    Hive.registerAdapter(NotePreviewAdapter());
    Hive.registerAdapter(NoteAdapter());
  }

  Stream<AllNotes> get all_notes async* {
    yield* _noteListController.stream;
  }

  Stream<Exception> get errors async* {
    yield* _errorController.stream;
  }

  Future<void> saveNotes(
    @required String secureKey,
    @required AllNotes notes,
  ) async {
    assert(secureKey != null);
    assert(notes != null);
    return _notesProvider.saveAllNotes(secureKey, notes);
  }

  Future<void> getNotesStream(@required String secureKey) async {
    assert(secureKey != null);
    await Hive.initFlutter();
    await _notesProvider
        .getAllNotes(secureKey)
        .then((notes) => _emitSuccessSideEffect(notes))
        .catchError((error) => _emitFailureSideEffect(error));
  }

  Future<AllNotes> getNotes(@required String secureKey) async {
    assert(secureKey != null);
    await Hive.initFlutter();
    return _notesProvider.getAllNotes(secureKey);
  }

  Future<void> eraseAllNotes() async {
    await Hive.initFlutter();
    return _notesProvider.deleteAllNotes();
  }

  void _emitSuccessSideEffect(AllNotes notes) {
    _noteListController.add(notes);
  }

  void _emitFailureSideEffect(Exception error) {
    _errorController.add(error);
  }

  void dispose() => _noteListController.close();
}
