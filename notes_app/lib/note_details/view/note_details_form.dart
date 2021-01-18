import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/note_details/bloc/note_details_bloc.dart';
import 'package:notes_app/note_details/view/note_details_page.dart';
import 'package:notes_app/notes_overview/bloc/notes_overview_bloc.dart';
import 'package:notes_repository/notes_repository_export.dart';

class NoteDetailsForm extends StatelessWidget {
  final String nodeId;

  NoteDetailsForm({Key key, @required this.nodeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCurrentSales(context);
  }

  Widget _buildCurrentSales(BuildContext buildContext) {
    return BlocBuilder<NoteDetailsBloc, NoteDetailsState>(builder: (context, state) {
      if (state is NoteDetailsState_Loaded) {
        return _NoteDetailsView(buildContext, state.note);
      } else if (state is NoteDetailsState_Loading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (state is NoteDetailsState_NotLoaded) {
        context.watch<NoteDetailsBloc>().add(NoteDetailsEvent_Load(nodeId));
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }

  Widget _NoteDetailsView(BuildContext buildContext, Note note) {
    return Container(
        padding: const EdgeInsets.only(left: 2, top: 0, right: 2, bottom: 0),
        child: Column(
          children: [
            TextFormField(
              initialValue: note.name,
              maxLines: 1,
              key: const Key('note_name_input'),
              onChanged: (name) => buildContext.bloc<NoteDetailsBloc>().add(NoteDetailsEvent_NameChanged(name, note)),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Note Name',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 4.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: TextFormField(
                initialValue: note.content,
                maxLines: 40,
                keyboardType: TextInputType.multiline,
                key: const Key('note_name_input'),
                onChanged: (content) =>
                    buildContext.bloc<NoteDetailsBloc>().add(NoteDetailsEvent_ContentChanged(content, note)),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Note content',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 4.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
