// import '../audio-to-text/model/store-pdf-sqlite-db-model.dart';

import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';

abstract class OpenedPdfsEvent {}

class LoadDocumentsEvent extends OpenedPdfsEvent {}

class SelectOptionEvent extends OpenedPdfsEvent {
  final String selectedOption;

  SelectOptionEvent(this.selectedOption);
}

class ResetOptionEvent extends OpenedPdfsEvent {}

class ToggleMultiSelectModeEvent extends OpenedPdfsEvent {}

class AddSelectedItemEvent extends OpenedPdfsEvent {
  final int itemId;

  AddSelectedItemEvent(this.itemId);
}

class RemoveSelectedItemEvent extends OpenedPdfsEvent {
  final int itemId;

  RemoveSelectedItemEvent(this.itemId);
}

class DeleteSelectedItemsEvent extends OpenedPdfsEvent {
  final Set<int> selectedItems;

  DeleteSelectedItemsEvent(this.selectedItems);
}

class RenameDocumentEvent extends OpenedPdfsEvent {
  final Document document;
  final String newName;

  RenameDocumentEvent(this.document, this.newName);
}

class DeleteDocumentEvent extends OpenedPdfsEvent {
  final int documentId;

  DeleteDocumentEvent(this.documentId);
}