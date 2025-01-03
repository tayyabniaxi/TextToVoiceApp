import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';

// import '../audio-to-text/model/store-pdf-sqlite-db-model.dart';

abstract class OpenedPdfsState {}

class InitialOpenedPdfsState extends OpenedPdfsState {}

class DocumentsLoadedState extends OpenedPdfsState {
  final List<Document> documents;

  DocumentsLoadedState(this.documents);
}

class OptionSelectedState extends OpenedPdfsState {
  final String selectedOption;

  OptionSelectedState(this.selectedOption);
}

class MultiSelectModeState extends OpenedPdfsState {
  final bool isMultiSelectMode;
  final List<Document> documents;
  final Set<int> selectedItems;

  MultiSelectModeState(this.isMultiSelectMode, this.documents, this.selectedItems);
}

class DocumentRenamedState extends OpenedPdfsState {
  final String message;

  DocumentRenamedState(this.message);
}

class DocumentDeletedState extends OpenedPdfsState {
  final String message;

  DocumentDeletedState(this.message);
}

class ErrorState extends OpenedPdfsState {
  final String message;

  ErrorState(this.message);
}