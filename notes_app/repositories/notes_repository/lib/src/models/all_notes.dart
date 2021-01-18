import 'dart:collection';

import 'package:hive/hive.dart';
import 'package:notes_repository/src/models/note_preview.dart';

class AllNotes {
  //Key here is the date of the note creation in milliseconds
  final Map<int, NotePreview> notes;

  AllNotes(this.notes);
}

class AllNotesAdapter extends TypeAdapter<AllNotes> {
  @override
  final typeId = 0;

  @override
  AllNotes read(BinaryReader reader) {
    final splTree = SplayTreeMap<int, NotePreview>.from(reader.read(), (a, b) {
      if (a < b) {
        return 1;
      } else if (a > b) {
        return -1;
      } else {
        return 0;
      }
    });
    return AllNotes((splTree));
  }

  @override
  void write(BinaryWriter writer, AllNotes obj) {
    writer.write(obj.notes as SplayTreeMap<int, NotePreview>);
  }
}
