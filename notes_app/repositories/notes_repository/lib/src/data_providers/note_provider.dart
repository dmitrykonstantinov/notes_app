import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:notes_repository/src/models/all_notes.dart';
import 'package:notes_repository/src/models/note.dart';
import 'package:notes_repository/src/models/note_preview.dart';

class NoteProvider {
  Future<Note> getNote(String secureKey, String noteId) async {
    return Hive.openBox<Note>('notesBox', encryptionCipher: HiveAesCipher(secureKey.codeUnits)).then(
      (hiveBox) => Future(() {
        return hiveBox.get(noteId, defaultValue: Note());
      }),
    );
  }

  Future<void> saveNote(String secureKey, Note note) async {
    return Hive.openBox<Note>('notesBox', encryptionCipher: HiveAesCipher(secureKey.codeUnits)).then(
      (hiveBox) => Future(() {
        hiveBox.put(note.id, note);
      }),
    );
  }

  Future<void> deleteNote(String secureKey, String noteId) async {
    return Hive.openBox<Note>('notesBox', encryptionCipher: HiveAesCipher(secureKey.codeUnits)).then(
      (hiveBox) => Future(() {
        hiveBox.delete(noteId);
      }),
    );
  }

  Future<AllNotes> getAllNotes(String secureKey) async {
    return await Hive.openBox<AllNotes>('allNotesBox', encryptionCipher: HiveAesCipher(secureKey.codeUnits)).then(
      (hiveBox) => Future(() {
        return hiveBox.get("allNotes", defaultValue: AllNotes(SplayTreeMap<int, NotePreview>()));
      }),
    );
  }

  Future<void> saveAllNotes(String secureKey, AllNotes allNotes) async {
    return Hive.openBox<AllNotes>('allNotesBox', encryptionCipher: HiveAesCipher(secureKey.codeUnits)).then(
      (hiveBox) => Future(() {
        hiveBox.put("allNotes", allNotes);
      }),
    );
  }

  Future<void> deleteAllNotes() async {
    return await Hive.openBox('allNotesBox')
        .then((value) => value.deleteFromDisk())
        .then((value) => Hive.openBox('notesBox').then((value) => value.deleteFromDisk()));
  }
}
