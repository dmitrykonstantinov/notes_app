import 'package:notes_app/login/bloc/login_bloc.dart';
import 'package:notes_app/login/view/login_form.dart';
import 'package:notes_app/notes_overview/bloc/notes_overview_bloc.dart';
import 'package:notes_app/notes_overview/view/notes_overview_form.dart';
import 'package:notes_repository/notes_repository_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My notes',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocProvider(
            create: (context) {
              return NotesOverviewBloc(
                notesOverviewRepository: RepositoryProvider.of<NotesOverviewRepository>(context),
                noteDetailsRepository: RepositoryProvider.of<NoteDetailsRepository>(context),
                noteSecurityRepository: RepositoryProvider.of<NoteSecurityRepository>(context),
              );
            },
            child: NotesOverviewForm(
              key: const Key('overview_form'),
            ),
          ),
        ),
      ),
    );
  }
}
