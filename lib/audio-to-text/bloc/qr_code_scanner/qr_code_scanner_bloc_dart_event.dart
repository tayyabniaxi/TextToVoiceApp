abstract class ScannerEvent {}

class StartScanning extends ScannerEvent {}

class StopScanning extends ScannerEvent {}

class ToggleFlash extends ScannerEvent {}

class TogglePause extends ScannerEvent {}

class CodeScanned extends ScannerEvent {
  final String code;
  CodeScanned(this.code);
}

class RequestCameraPermission extends ScannerEvent {}
