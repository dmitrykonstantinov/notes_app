import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes_repository/notes_repository_export.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required NoteSecurityRepository noteSecurityRepository,
    @required NotesOverviewRepository notesOverviewRepository,
  })  : assert(noteSecurityRepository != null),
        assert(notesOverviewRepository != null),
        _noteSecurityRepository = noteSecurityRepository,
        _notesOverviewRepository = notesOverviewRepository,
        super(const LoginState());

  final NoteSecurityRepository _noteSecurityRepository;
  final NotesOverviewRepository _notesOverviewRepository;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is PasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is PasswordSubmitted) {
      yield* _mapLoginSubmittedToState(state);
    } else if (event is WipeData) {
      yield* _mapWipeDataToState(state);
    }
  }

  LoginState _mapPasswordChangedToState(PasswordChanged event, LoginState state) {
    //Validate Password
    if (event.password.trim().length > 0) {
      return LoginState_NotLoggedIn(LoginState(), password: event.password);
    } else {
      return LoginState_NotLoggedIn(state, error: "Check password. Can't be empty");
    }
  }

  Stream<LoginState> _mapLoginSubmittedToState(LoginState state) async* {
    yield LoginState_InProgress(state);
    try {
      final key = await _noteSecurityRepository.getSecurityKeyFromPassword(state.password);
      yield LoginState_LoggedIn(state, key);
    } catch (ex) {
      yield LoginState_NotLoggedIn(state, error: ex.toString());
    }
  }

  Stream<LoginState> _mapWipeDataToState(LoginState state) async* {
    yield LoginState_InProgress(state);
    await _noteSecurityRepository
        .wipeSecurityKey()
        .then((value) => null)
        .then((value) => _notesOverviewRepository.eraseAllNotes());
    yield LoginState_NotLoggedIn(state);
  }
}
