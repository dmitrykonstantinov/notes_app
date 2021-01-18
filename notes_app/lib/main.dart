import 'package:flutter/widgets.dart';
import 'package:notes_app/root.dart';
import 'package:notes_repository/notes_repository_export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(
    noteSecurityRepository: NoteSecurityRepository(),
    notesRepository: NoteDetailsRepository(),
    notesOverviewRepository: NotesOverviewRepository(),
  ));
}
