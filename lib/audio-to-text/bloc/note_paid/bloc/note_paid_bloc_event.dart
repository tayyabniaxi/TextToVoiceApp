// notes_event.dart
import 'package:new_wall_paper_app/model/note_paid_model.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final String title;
  final String content;
  AddNote(this.title, this.content);
}

class DeleteNote extends NotesEvent {
  final String id;
  DeleteNote(this.id);
}

class UpdateNote extends NotesEvent {
  final Note note;
  UpdateNote(this.note);
}

class SearchNotes extends NotesEvent {
  final String query;
  SearchNotes(this.query);
}
