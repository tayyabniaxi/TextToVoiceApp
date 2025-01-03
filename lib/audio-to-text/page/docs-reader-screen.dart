// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/docsReader/docs-reader-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/docsReader/docs-reader-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/docsReader/docs-reader-state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';

class DocxReaderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<DocsReaderBloc, DocsReaderState>(
            builder: (context, state) {
              if (state is DocxLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DocxLoaded) {
                return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WriteAndTextPage(
                              isConvertable: true,
                                  text: state.content, isText: false,
                                )),
                      );
                    },
                    child: Text("Next"));
              } else {
                return const Center(child: Text("No PDF selected"));
              }
            },
          )
        ],
      ),
   
      appBar: AppBar(
        title: const Text('DOCX Reader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<DocsReaderBloc>(context).add(PickDocxFile());
              },
              child: const Text('Pick a DOCX file'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<DocsReaderBloc, DocsReaderState>(
                builder: (context, state) {
                  if (state is DocxLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DocxLoaded) {
                    return SingleChildScrollView(
                      child: Text(
                        state.content,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  } else if (state is DocxError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("Pick a DOCX file to read"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
