import 'package:notes_app/note_details/bloc/note_details_bloc.dart';
import 'package:notes_app/note_details/view/note_details_form.dart';
import 'package:notes_repository/notes_repository_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteDetailsPage extends StatelessWidget {
  final String nodeId;

  NoteDetailsPage({Key key, @required this.nodeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
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
              return NoteDetailsBloc(
                noteDetailsRepository: RepositoryProvider.of<NoteDetailsRepository>(context),
                notesOverviewRepository: RepositoryProvider.of<NotesOverviewRepository>(context),
                noteSecurityRepository: RepositoryProvider.of<NoteSecurityRepository>(context),
              );
            },
            child: NoteDetailsForm(
              nodeId: nodeId,
            ),
          ),
        ),
      ),
    );
  }
}
