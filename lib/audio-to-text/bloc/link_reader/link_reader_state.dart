// link_reader_state.dart
abstract class LinkReaderState {}

class LinkReaderInitial extends LinkReaderState {}

class LinkReaderLoading extends LinkReaderState {}

class LinkReaderLoaded extends LinkReaderState {
  final String extractedText;

  LinkReaderLoaded(this.extractedText);
}

class LinkReaderError extends LinkReaderState {
  final String message;

  LinkReaderError(this.message);
}
