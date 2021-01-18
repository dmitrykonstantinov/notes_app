import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:notes_repository/notes_repository_export.dart';

part 'note_details_event.dart';

part 'note_details_state.dart';

class NoteDetailsBloc extends Bloc<NoteDetailsEvent, NoteDetailsState> {
  NoteDetailsBloc({
    @required NoteDetailsRepository noteDetailsRepository,
    @required NotesOverviewRepository notesOverviewRepository,
    @required NoteSecurityRepository noteSecurityRepository,
  })  : assert(noteDetailsRepository != null),
        _noteDetailsRepository = noteDetailsRepository,
        _notesOverviewRepository = notesOverviewRepository,
        _noteSecurityRepository = noteSecurityRepository,
        super(NoteDetailsState_NotLoaded()) {
    _noteDetailsRepository.get_note.listen((event) {
      add(NoteDetailsEvent_Loaded(event));
    });
  }

  final NoteDetailsRepository _noteDetailsRepository;
  final NotesOverviewRepository _notesOverviewRepository;
  final NoteSecurityRepository _noteSecurityRepository;

  @override
  Stream<NoteDetailsState> mapEventToState(NoteDetailsEvent event) async* {
    if (event is NoteDetailsEvent_Load) {
      yield await _mapLoadNotesEventToState(event);
    } else if (event is NoteDetailsEvent_Loaded) {
      yield await _mapLoadedCampaignsEventToState(event);
    } else if (event is NoteDetailsEvent_NameChanged) {
      yield await _mapNameChangedEventToState(event);
    } else if (event is NoteDetailsEvent_ContentChanged) {
      yield await _mapContentChangedEventToState(event);
    }
  }

  Future<NoteDetailsState> _mapNameChangedEventToState(NoteDetailsEvent_NameChanged event) async {
    String securityKey = await _noteSecurityRepository.getSecurityKey();
    final note = Note(id: event.note.id, name: event.name, content: event.note.content);
    await _noteDetailsRepository.saveNote(securityKey, note);
    final allNotes = await _notesOverviewRepository.getNotes(securityKey);
    var notes = SplayTreeMap<int, NotePreview>.from(allNotes.notes);
    notes.removeWhere((key, element) => element.id == note.id);
    notes.addAll({
      DateTime.now().millisecondsSinceEpoch: NotePreview(id: note.id, name: note.name),
    });
    await _notesOverviewRepository.saveNotes(securityKey, AllNotes(notes));
    return NoteDetailsState_Loaded(note);
  }

  Future<NoteDetailsState> _mapContentChangedEventToState(NoteDetailsEvent_ContentChanged event) async {
    String securityKey = await _noteSecurityRepository.getSecurityKey();
    final note = Note(id: event.note.id, name: event.note.name, content: event.content);
    await _noteDetailsRepository.saveNote(securityKey, note);
    return NoteDetailsState_Loaded(note);
  }

  Future<NoteDetailsState> _mapLoadNotesEventToState(NoteDetailsEvent_Load eventLoad) async {
    String securityKey = await _noteSecurityRepository.getSecurityKey();
    _noteDetailsRepository.getNote(securityKey, eventLoad.noteId);
    return NoteDetailsState_Loading();
  }

  Future<NoteDetailsState> _mapLoadedCampaignsEventToState(NoteDetailsEvent_Loaded event) async {
    return NoteDetailsState_Loaded(event.note);
  }
}
