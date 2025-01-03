enum ScanResultType { image, pdf, link, document, unknown }

enum ScanStatus { initial, scanning, paused, permissionDenied }

class ScanResult {
  final String data;
  final ScanResultType type;
  final DateTime timestamp;

  ScanResult(this.data, this.type) : timestamp = DateTime.now();

  String get typeString {
    switch (type) {
      case ScanResultType.image:
        return 'Image';
      case ScanResultType.pdf:
        return 'PDF';
      case ScanResultType.link:
        return 'Web Link';
      case ScanResultType.document:
        return 'Document';
      case ScanResultType.unknown:
        return 'Unknown';
    }
  }
}

class ScannerState {
  final ScanStatus status;
  final bool isFlashOn;
  final ScanResult? result;
  final String? error;
  final bool hasPermission;

  ScannerState({
    this.status = ScanStatus.initial,
    this.isFlashOn = false,
    this.result,
    this.error,
    this.hasPermission = false,
  });

  bool get isScanning => status == ScanStatus.scanning;

  ScannerState copyWith({
    ScanStatus? status,
    bool? isFlashOn,
    ScanResult? result,
    String? error,
    bool? hasPermission,
  }) {
    return ScannerState(
      status: status ?? this.status,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      result: result ?? this.result,
      error: error,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}
