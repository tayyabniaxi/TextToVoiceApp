import 'package:new_wall_paper_app/model/note_paid_model.dart';

class NotesState {
  final List<Note> notes;
  final List<Note> filteredNotes;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  NotesState({
    this.notes = const [],
    this.filteredNotes = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  NotesState copyWith({
    List<Note>? notes,
    List<Note>? filteredNotes,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
