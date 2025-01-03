// notes_screen.dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/add_note_screen.dart';
import 'package:new_wall_paper_app/model/note_paid_model.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

// notes_screen.dart
class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: MediaQuery.of(context).size.height * 0.03,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: CommonText(
            title: "Notes",
            color: Colors.black,
            size: 0.023,
            fontFamly: AppFont.robot,
            fontWeight: FontWeight.w400,
          )),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              SearchBar(),
              height(size: 0.016),
              Expanded(
                child: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notesToShow = state.searchQuery.isEmpty
                        ? state.notes
                        : state.filteredNotes;

                    return ListView.builder(
                      itemCount: notesToShow.length,
                      itemBuilder: (context, index) {
                        final note = notesToShow[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.containerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: CommonText(
                              title: note.title,
                              color: Colors.black,
                              size: 0.019,
                              fontFamly: AppFont.robot,
                              fontWeight: FontWeight.w400,
                            ).paddingOnly(top: 5),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonText(
                                  title: DateFormat('HH:mm a, MMMM dd, yyyy')
                                      .format(note.dateTime),
                                  color: Colors.grey,
                                  size: 0.016,
                                  fontFamly: AppFont.robot,
                                  fontWeight: FontWeight.w400,
                                ).paddingOnly(top: 5),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                        onTap: () => _editNote(context, note),
                                        child: SvgPicture.asset(
                                            "assets/icons/note_edit.svg")),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(
                                        onTap: () => context
                                            .read<NotesBloc>()
                                            .add(DeleteNote(note.id)),
                                        child: SvgPicture.asset(
                                            "assets/icons/note_delete.svg")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addNote(context),
      ),
    );
  }

  void _addNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NotesBloc>(context),
          child: const AddEditNoteScreen(),
        ),
      ),
    );
  }

  void _editNote(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NotesBloc>(context),
          child: AddEditNoteScreen(note: note),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.containerColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        onChanged: (query) {
          context.read<NotesBloc>().add(SearchNotes(query));
        },
        decoration: const InputDecoration(
          hintText: 'Search Notes',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
