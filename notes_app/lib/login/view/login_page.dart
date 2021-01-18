import 'package:notes_app/login/bloc/login_bloc.dart';
import 'package:notes_app/login/view/login_form.dart';
import 'package:notes_repository/notes_repository_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Easy Notes',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocProvider(
            create: (context) {
              return LoginBloc(
                noteSecurityRepository: RepositoryProvider.of<NoteSecurityRepository>(context),
                notesOverviewRepository: RepositoryProvider.of<NotesOverviewRepository>(context),
              );
            },
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
