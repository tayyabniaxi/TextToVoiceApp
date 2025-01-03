// notes_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_state.dart';
import 'package:new_wall_paper_app/helper/note_paid_helper.dart';
// import 'package:new_wall_paper_app/helper/note_paid_helper.dart';
import 'package:new_wall_paper_app/model/note_paid_model.dart';

// notes_bloc.dart
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final dbHelper = DatabaseHelper.instance;

  NotesBloc() : super(NotesState()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<SearchNotes>(_onSearchNotes);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final notes = await dbHelper.readAllNotes();
      emit(state.copyWith(notes: notes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onSearchNotes(SearchNotes event, Emitter<NotesState> emit) {
    final query = event.query.toLowerCase();
    final filteredNotes = state.notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
    emit(state.copyWith(
      filteredNotes: filteredNotes,
      searchQuery: query,
    ));
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      final note = Note(
        id: DateTime.now().toString(),
        title: event.title,
        content: event.content,
        dateTime: DateTime.now(),
      );
      await dbHelper.create(note);
      final notes = await dbHelper.readAllNotes();
      emit(state.copyWith(notes: notes));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      await dbHelper.update(event.note);
      final notes = await dbHelper.readAllNotes();
      emit(state.copyWith(notes: notes));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      await dbHelper.delete(event.id);
      final notes = await dbHelper.readAllNotes();
      emit(state.copyWith(notes: notes));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
