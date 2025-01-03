import 'package:html/parser.dart' as htmlparser;

class VRemoveSpecialCharctorWidget {
  String cleanEmailContent(String htmlString) {
    if (htmlString.isEmpty) return '';

    var document = htmlparser.parse(htmlString);
    String text = document.body?.text ?? htmlString;

    text = text
        .replaceAll(RegExp(r'http\S+'), '')
        .replaceAll(RegExp(r'-{2,}'), '')
        .replaceAll(RegExp(r'=+'), '')
        .replaceAll(RegExp(r'_+'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[\n\r]+'), '\n')
        .replaceAll(RegExp(r'[^\S\r\n]+'), ' ')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'[[\]{}()]'), '')
        .trim();

    return text;
  }
}
