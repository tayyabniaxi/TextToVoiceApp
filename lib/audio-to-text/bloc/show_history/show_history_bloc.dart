import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/show_history/show_history_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/show_history/show_history_state.dart';
import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';

class OpenedPdfsBloc extends Bloc<OpenedPdfsEvent, OpenedPdfsState> {
  final DatabaseHelper dbHelper;

  String selectedOption = 'None';
  bool isMultiSelectMode = false;
  Set<int> selectedItems = {};
  List<Document> documents = [];

  OpenedPdfsBloc(this.dbHelper) : super(InitialOpenedPdfsState()) {
    on<LoadDocumentsEvent>(_onLoadDocuments);
    on<SelectOptionEvent>(_onSelectOption);
    on<ResetOptionEvent>(_onResetOption);
    on<ToggleMultiSelectModeEvent>(_onToggleMultiSelectMode);
    on<AddSelectedItemEvent>(_onAddSelectedItem);
    on<RemoveSelectedItemEvent>(_onRemoveSelectedItem);
    on<DeleteSelectedItemsEvent>(_onDeleteSelectedItems);
    on<RenameDocumentEvent>(_onRenameDocument);
    on<DeleteDocumentEvent>(_onDeleteDocument);
  }

  Future<void> _onLoadDocuments(
      LoadDocumentsEvent event, Emitter<OpenedPdfsState> emit) async {
    try {
      documents = await dbHelper.getDocuments();
      emit(DocumentsLoadedState(documents));
    } catch (e) {
      emit(ErrorState("Failed to load documents: $e"));
    }
  }

  void _onSelectOption(SelectOptionEvent event, Emitter<OpenedPdfsState> emit) {
    selectedOption = event.selectedOption;
    emit(OptionSelectedState(selectedOption));
  }

  void _onResetOption(ResetOptionEvent event, Emitter<OpenedPdfsState> emit) {
    selectedOption = 'None';
    emit(OptionSelectedState(selectedOption));
  }

  void _onToggleMultiSelectMode(
      ToggleMultiSelectModeEvent event, Emitter<OpenedPdfsState> emit) {
    isMultiSelectMode = !isMultiSelectMode;
    selectedItems.clear();
    emit(MultiSelectModeState(isMultiSelectMode, documents, selectedItems));
  }

  void _onAddSelectedItem(
      AddSelectedItemEvent event, Emitter<OpenedPdfsState> emit) {
    selectedItems.add(event.itemId);
    emit(MultiSelectModeState(isMultiSelectMode, documents, selectedItems));
  }

  void _onRemoveSelectedItem(
      RemoveSelectedItemEvent event, Emitter<OpenedPdfsState> emit) {
    selectedItems.remove(event.itemId);
    emit(MultiSelectModeState(isMultiSelectMode, documents, selectedItems));
  }

  Future<void> _onDeleteSelectedItems(DeleteSelectedItemsEvent event,
      Emitter<OpenedPdfsState> emit) async {
    try {
      for (var id in event.selectedItems) {
        await dbHelper.deleteDocument(id);
      }
      documents = await dbHelper.getDocuments();
      selectedItems.clear();
      isMultiSelectMode = false;
      emit(DocumentsLoadedState(documents));
    } catch (e) {
      emit(ErrorState("Failed to delete selected items: $e"));
    }
  }

  Future<void> _onRenameDocument(
      RenameDocumentEvent event, Emitter<OpenedPdfsState> emit) async {
    try {
      final updatedDocument = event.document.copyWith(name: event.newName);
      await dbHelper.updateDocument(updatedDocument);
      documents = await dbHelper.getDocuments();
      emit(DocumentsLoadedState(documents));
    } catch (e) {
      emit(ErrorState("Failed to rename document: $e"));
    }
  }

  Future<void> _onDeleteDocument(
      DeleteDocumentEvent event, Emitter<OpenedPdfsState> emit) async {
    try {
      await dbHelper.deleteDocument(event.documentId);
      documents = await dbHelper.getDocuments();
      emit(DocumentsLoadedState(documents));
    } catch (e) {
      emit(ErrorState("Failed to delete document: $e"));
    }
  }
}