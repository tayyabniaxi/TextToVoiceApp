

class Document {
  final int? id;
  final String? name;
  final String? pdfContent;
  final String? description;
  final String? contentType;
  final String? dateAdded;

  Document({
    this.id,
    this.name,
    this.pdfContent,
    this.description,
    this.contentType,
    this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pdfContent': pdfContent,
      'description': description,
      'contentType': contentType,
      'dateAdded': dateAdded,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      name: map['name'],
      pdfContent: map['pdfContent'],
      description: map['description'],
      contentType: map['contentType'],
      dateAdded: map['dateAdded'],
    );
  }

  Document copyWith({
    int? id,
    String? name,
    String? pdfContent,
    String? description,
    String? contentType,
    String? dateAdded,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      pdfContent: pdfContent ?? this.pdfContent,
      description: description ?? this.description,
      contentType: contentType ?? this.contentType,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
