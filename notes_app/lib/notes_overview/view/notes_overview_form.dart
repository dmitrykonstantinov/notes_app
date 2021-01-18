import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/note_details/view/note_details_page.dart';
import 'package:notes_app/notes_overview/bloc/notes_overview_bloc.dart';
import 'package:notes_repository/notes_repository_export.dart';

class NotesOverviewForm extends StatelessWidget {

  NotesOverviewForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildNotesPreview(context);
  }

  Widget _buildNotesPreview(BuildContext buildContext) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(builder: (context, state) {
      if (state is NotesOverviewState_Loaded) {
        return _buildNotesList(buildContext, state.allNotes);
      } else if (state is NotesOverviewState_Loading) {
        return _buildLoadingIndicator(buildContext);
      } else if (state is NotesOverviewState_NotLoaded) {
        context.watch<NotesOverviewBloc>().add(NotesOverviewEvent_Load());
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (state is NotesOverviewState_NoteCreated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigateToNoteDetails(buildContext, state.note.id);
        });
        return _buildNotesList(buildContext, state.allNotes);
      } else {
        throw Exception("Unexpected State: " + state.toString());
      }
    });
  }

  void navigateToNoteDetails(BuildContext buildContext, String noteId) async {
    await Navigator.of(buildContext)
        .push(
          MaterialPageRoute<NoteDetailsPage>(
            builder: (_) => NoteDetailsPage(nodeId: noteId),
          ),
        )
        .then((value) => buildContext.read<NotesOverviewBloc>().add(NotesOverviewEvent_Load()));
  }

  Widget _buildLoadingIndicator(BuildContext buildContext) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNotesList(BuildContext buildContext, AllNotes allNotes) {
    return Stack(
      children: [
        ListView(
          children: allNotes.notes.values.map((campaign) => _buildRow(buildContext, campaign)).toList(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ClipOval(
            key: const Key('overview_form_add'),
            child: Material(
              color: Colors.blue, // button color
              child: InkWell(
                splashColor: Colors.red, // inkwell color
                child: SizedBox(width: 56, height: 56, child: Icon(Icons.add)),
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    buildContext.read<NotesOverviewBloc>().add(NotesOverviewEvent_CreateNote());
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRow(BuildContext buildContext, NotePreview notePreview) {
    return Container(
      padding: const EdgeInsets.only(left: 2, top: 0, right: 2, bottom: 0),
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  navigateToNoteDetails(buildContext, notePreview.id);
                }),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, top: 14, right: 16, bottom: 16),
                          child: Text(
                            notePreview.name,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Expanded(
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4, right: 12, bottom: 4),
                  child: ClipOval(
                    child: Material(
                      color: Colors.red, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(width: 24, height: 24, child: Icon(Icons.remove)),
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            buildContext.read<NotesOverviewBloc>().add(NotesOverviewEvent_NoteDelete(notePreview.id));
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            // ),
          ],
        ),
      ),
    );
  }
}
