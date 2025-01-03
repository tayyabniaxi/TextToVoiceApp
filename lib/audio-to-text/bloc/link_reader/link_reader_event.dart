// link_reader_event.dart

abstract class LinkReaderEvent {}

class FetchWebsiteTextEvent extends LinkReaderEvent {
  final String url;

  FetchWebsiteTextEvent(this.url);
}
