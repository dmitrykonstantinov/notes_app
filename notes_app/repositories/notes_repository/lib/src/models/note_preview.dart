import 'package:hive/hive.dart';

class NotePreview {
  String id;
  String name;

  NotePreview({
    this.id = "",
    this.name = "",
  });
}

class NotePreviewAdapter extends TypeAdapter<NotePreview> {
  @override
  final typeId = 1;

  @override
  NotePreview read(BinaryReader reader) {
    return NotePreview(
      id: reader.read(),
      name: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, NotePreview obj) {
    writer.write(obj.id);
    writer.write(obj.name);
  }
}
