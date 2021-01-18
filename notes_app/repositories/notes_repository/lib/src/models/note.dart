import 'package:hive/hive.dart';

class Note {
  String id;
  String name;
  String content;

  Note({
    this.id = "",
    this.name = "",
    this.content = "",
  });
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 2;

  @override
  Note read(BinaryReader reader) {
    return Note(
      id: reader.read(),
      name: reader.read(),
      content: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.content);
  }
}
