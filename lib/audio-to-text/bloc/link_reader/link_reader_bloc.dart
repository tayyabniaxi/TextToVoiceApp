import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';
import '../../../model/store-pdf-sqlite-db-model.dart';
import 'link_reader_event.dart';
import 'link_reader_state.dart';

class LinkReaderBloc extends Bloc<LinkReaderEvent, LinkReaderState> {
  LinkReaderBloc() : super(LinkReaderInitial()) {
    on<FetchWebsiteTextEvent>(_onFetchWebsiteText);
  }
Future<void> _onFetchWebsiteText(
    FetchWebsiteTextEvent event, Emitter<LinkReaderState> emit) async {
  emit(LinkReaderLoading());

  try {
    Uri? parsedUrl = Uri.tryParse(event.url);
    if (parsedUrl == null || !parsedUrl.hasScheme) {
      emit(LinkReaderError('Invalid URL format'));
      return;
    }

    final response = await http.get(parsedUrl);
    if (response.statusCode == 200) {
      var document = html_parser.parse(response.body);
      List<String> paragraphs = document.querySelectorAll('p').map((element) {
        return element.text.trim();
      }).where((text) => text.isNotEmpty).toList();

      final extractedText = paragraphs.join('\n\n');

      if (extractedText.isEmpty) {
        emit(LinkReaderError('No meaningful text found on the webpage.'));
        return;
      }

   
      final documents = Document(
        name: parsedUrl.host, 
        pdfContent: extractedText, 
        description: DateTime.now().toIso8601String(), 
        contentType: "Link",
      );

      final dbHelper = DatabaseHelper();
      await dbHelper.insertDocument(documents);

      emit(LinkReaderLoaded(extractedText));
    } else {
      emit(LinkReaderError('Failed to fetch data. Status code: ${response.statusCode}'));
    }
  } catch (e) {
    emit(LinkReaderError('Error: $e'));
  }
}

}
