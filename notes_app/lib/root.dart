import 'package:notes_app/login/view/login_page.dart';
import 'package:notes_repository/notes_repository_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.notesRepository,
    @required this.noteSecurityRepository,
    @required this.notesOverviewRepository,
  })  : assert(notesRepository != null),
        assert(noteSecurityRepository != null),
        super(key: key);

  final NoteDetailsRepository notesRepository;
  final NoteSecurityRepository noteSecurityRepository;
  final NotesOverviewRepository notesOverviewRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NoteDetailsRepository>(
          create: (context) => notesRepository,
        ),
        RepositoryProvider<NoteSecurityRepository>(
          create: (context) => noteSecurityRepository,
        ),
        RepositoryProvider<NotesOverviewRepository>(
          create: (context) => notesOverviewRepository,
        )
      ],
      child: RootAppView(),
    );
  }
}

class RootAppView extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: LoginPage(),
    );
  }

  /*
  * Invoke side effect func on route pop. Frequently used to force root route to rebuild on child route pop event.
  * */
  void pushReplaceAsyncWithSideEffect(BuildContext context, Route route, Function sideEffect) async {
    await Navigator.pushReplacement(context, route).then((_) => sideEffect());
  }
}
