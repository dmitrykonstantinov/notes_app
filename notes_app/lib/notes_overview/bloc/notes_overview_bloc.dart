import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:notes_repository/notes_repository_export.dart';

part 'notes_overview_event.dart';

part 'notes_overview_state.dart';

class NotesOverviewBloc extends Bloc<NotesOverviewEvent, NotesOverviewState> {
  NotesOverviewBloc({
    @required NotesOverviewRepository notesOverviewRepository,
    @required NoteDetailsRepository noteDetailsRepository,
    @required NoteSecurityRepository noteSecurityRepository,
  })  : assert(notesOverviewRepository != null),
        assert(noteDetailsRepository != null),
        assert(noteSecurityRepository != null),
        _notesOverviewRepository = notesOverviewRepository,
        _noteDetailsRepository = noteDetailsRepository,
        _noteSecurityRepository = noteSecurityRepository,
        super(NotesOverviewState_NotLoaded()) {
    _notesOverviewRepository.all_notes.listen((event) {
      add(NotesOverviewEvent_Loaded(event));
    });
    _noteDetailsRepository.create_note.listen((event) {
      add(NotesOverviewEvent_NoteCreated(event));
    });
  }

  final NotesOverviewRepository _notesOverviewRepository;
  final NoteDetailsRepository _noteDetailsRepository;
  final NoteSecurityRepository _noteSecurityRepository;

  @override
  Stream<NotesOverviewState> mapEventToState(NotesOverviewEvent event) async* {
    if (event is NotesOverviewEvent_Load) {
      yield await _mapLoadNotesEventToState(event);
    } else if (event is NotesOverviewEvent_Loaded) {
      yield await _mapLoadedNotesEventToState(event);
    } else if (event is NotesOverviewEvent_CreateNote) {
      yield await _mapCreateNoteEventToState(event);
    } else if (event is NotesOverviewEvent_NoteCreated) {
      yield await _mapNoteCreatedEventToState(event);
    } else if (event is NotesOverviewEvent_NoteDelete) {
      yield await _mapDeleteEventToState(event);
    }
  }

  Future<NotesOverviewState> _mapNoteCreatedEventToState(NotesOverviewEvent_NoteCreated event) async {
    final curState = super.state;
    String securityKey = await _noteSecurityRepository.getSecurityKey();
    if (curState is NotesOverviewState_Loaded) {
      var notes = SplayTreeMap<int, NotePreview>.from(curState.allNotes.notes);
      notes.addAll({
        DateTime.now().millisecondsSinceEpoch: NotePreview(id: event.note.id, name: event.note.name),
      });
      return _notesOverviewRepository
          .saveNotes(securityKey, AllNotes(notes))
          .then((value) => NotesOverviewState_NoteCreated(event.note, curState.allNotes))
          .catchError((onError) => NotesOverviewState_NotLoaded());
    } else if (curState is NotesOverviewState_NoteCreated) {
      return NotesOverviewState_Loaded(curState.allNotes);
    } else {
      throw Exception("Unexpected State: " + curState.toString());
    }
  }

  Future<NotesOverviewState> _mapDeleteEventToState(NotesOverviewEvent_NoteDelete event) async {
    String securityKey = await _noteSecurityRepository.getSecurityKey();
    final allNotes = await _notesOverviewRepository.getNotes(securityKey);
    var notes = SplayTreeMap<int, NotePreview>.from(allNotes.notes);
    notes.removeWhere((key, element) => element.id == event.id);
    await _notesOverviewRepository.saveNotes(securityKey, AllNotes(notes));
    await _noteDetailsRepository.deleteNote(securityKey, event.id);
    add(NotesOverviewEvent_Load());
    return NotesOverviewState_Loading();
  }

  Future<NotesOverviewState> _mapCreateNoteEventToState(NotesOverviewEvent_CreateNote event) async {
    String securityKey = await _noteSecurityRepository.getSecurityKey();
    _noteDetailsRepository.createNote(securityKey);
    return super.state; //Don't forget to fix it later pls.
  }

  Future<NotesOverviewState> _mapLoadNotesEventToState(NotesOverviewEvent_Load event) async {
    String securityKey = await _noteSecurityRepository.getSecurityKey();
    _notesOverviewRepository.getNotesStream(securityKey);
    return NotesOverviewState_Loading();
  }

  Future<NotesOverviewState> _mapLoadedNotesEventToState(NotesOverviewEvent_Loaded event) async {
    return NotesOverviewState_Loaded(event.allNotes);
  }
}
