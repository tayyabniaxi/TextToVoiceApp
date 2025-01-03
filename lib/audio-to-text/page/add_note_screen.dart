// // ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_event.dart';
import 'package:new_wall_paper_app/model/note_paid_model.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({this.note});

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String formattedDateTime = '';
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _updateDateTime();

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      formattedDateTime = DateFormat('hh:mm a, MMM dd, yyyy').format(now);
    });
  }

  void _showValidationDialog({required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.amber[700], size: 28),
              const SizedBox(width: 10),
              CommonText(
                title: "Required Field",
                color: Colors.black,
                size: 0.025,
                fontFamly: AppFont.robot,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
          content: CommonText(
            title: message,
            color: Colors.black,
            size: 0.023,
            fontFamly: AppFont.robot,
            fontWeight: FontWeight.w400,
          ),
          actions: [
            TextButton(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber[700]),
                const SizedBox(width: 10),
                CommonText(
                  title: "Unsaved Changes",
                  color: Colors.black,
                  size: 0.025,
                  fontFamly: AppFont.robot,
                  fontWeight: FontWeight.w700,
                )
              ],
            ),
            content: CommonText(
              title: "Do you want to discard your changes?",
              color: Colors.black,
              size: 0.023,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w400,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Discard',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      return shouldPop ?? false;
    }
    return true;
  }

  void _saveNote(BuildContext context) {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      _showValidationDialog(
        message: 'Both title and content are required.',
      );
      return;
    }

    if (title.isEmpty) {
      _showValidationDialog(
        message: 'Please enter a title for your note.',
      );
      return;
    }

    if (content.isEmpty) {
      _showValidationDialog(
        message: 'Please enter some content for your note.',
      );
      return;
    }

    if (widget.note == null) {
      context.read<NotesBloc>().add(
            AddNote(title, content),
          );
    } else {
      context.read<NotesBloc>().add(
            UpdateNote(
              widget.note!.copy(
                title: title,
                content: content,
                dateTime: DateTime.now(),
              ),
            ),
          );
    }

    setState(() {
      _hasUnsavedChanges = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          title: CommonText(
            title: widget.note == null ? "New Note" : "Edit Note",
            color: Colors.black,
            size: 0.023,
            fontFamly: AppFont.robot,
            fontWeight: FontWeight.w500,
          ),
          actions: [
            TextButton(
              onPressed: () => _saveNote(context),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.022,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Title',
                        hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.022,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Text(
                      formattedDateTime,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: 'Note something down...',
                        hintStyle: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.019,
                            fontFamily: AppFont.robot,
                            color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _contentController.removeListener(_onTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
