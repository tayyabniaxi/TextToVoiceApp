import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/bloc/qr_code_scanner_bloc_dart_event.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/bloc/qr_code_scanner_bloc_dart_state.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/qr_code_scanner_bloc_dart_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'qr_code_scanner_bloc_dart_event.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  QRViewController? controller;
  bool _processingCode = false;

  ScannerBloc() : super(ScannerState()) {
    on<StartScanning>(_onStartScanning);
    on<StopScanning>(_onStopScanning);
    on<ToggleFlash>(_onToggleFlash);
    on<TogglePause>(_onTogglePause);
    on<CodeScanned>(_onCodeScanned);
    on<RequestCameraPermission>(_onRequestPermission);
  }

  Future<void> _onRequestPermission(
      RequestCameraPermission event, Emitter<ScannerState> emit) async {
    final status = await Permission.camera.request();
    final hasPermission = status.isGranted;

    emit(state.copyWith(
        hasPermission: hasPermission,
        status:
            hasPermission ? ScanStatus.scanning : ScanStatus.permissionDenied,
        error: hasPermission
            ? null
            : 'Camera permission is required to scan QR codes'));
  }

  void _onStartScanning(StartScanning event, Emitter<ScannerState> emit) {
    if (state.hasPermission) {
      emit(state.copyWith(
          status: ScanStatus.scanning, result: null, error: null));
    } else {
      add(RequestCameraPermission());
    }
  }

  void _onStopScanning(StopScanning event, Emitter<ScannerState> emit) {
    emit(state.copyWith(status: ScanStatus.paused));
  }

  void _onTogglePause(TogglePause event, Emitter<ScannerState> emit) {
    final newStatus = state.status == ScanStatus.scanning
        ? ScanStatus.paused
        : ScanStatus.scanning;
    emit(state.copyWith(status: newStatus));
  }

  Future<void> _onToggleFlash(
      ToggleFlash event, Emitter<ScannerState> emit) async {
    try {
      await controller?.toggleFlash();
      final isFlashOn = await controller?.getFlashStatus() ?? false;
      emit(state.copyWith(isFlashOn: isFlashOn));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to toggle flash'));
    }
  }

/*
  void _onCodeScanned(CodeScanned event, Emitter<ScannerState> emit) async {
    if (_processingCode) return;
    _processingCode = true;

    try {
      final code = event.code.trim().toLowerCase();
      ScanResultType type;

      if (code.startsWith('data:image/') ||
          code.endsWith('.jpg') ||
          code.endsWith('.png') ||
          code.endsWith('.jpeg') ||
          code.endsWith('.gif')) {
        type = ScanResultType.image;
      } else if (code.endsWith('.pdf')) {
        type = ScanResultType.pdf;
      } else if (code.startsWith('http://') || code.startsWith('https://')) {
        type = ScanResultType.link;
      } else if (code.endsWith('.doc') ||
          code.endsWith('.docx') ||
          code.endsWith('.txt')) {
        type = ScanResultType.document;
      } else {
        type = ScanResultType.unknown;
      }

      emit(state.copyWith(
          result: ScanResult(code, type), status: ScanStatus.paused));
    } catch (e) {
      emit(state.copyWith(
          error: 'Failed to process QR code', status: ScanStatus.paused));
    } finally {
      _processingCode = false;
    }
  }
*/
  void _onCodeScanned(CodeScanned event, Emitter<ScannerState> emit) async {
    if (_processingCode) return;
    _processingCode = true;

    try {
      final code = event.code.trim().toLowerCase();
      ScanResultType type;

      if (code.startsWith('data:image/') ||
          code.endsWith('.jpg') ||
          code.endsWith('.png') ||
          code.endsWith('.jpeg') ||
          code.endsWith('.gif')) {
        type = ScanResultType.image;
      } else if (code.endsWith('.pdf')) {
        type = ScanResultType.pdf;
      } else if (code.startsWith('http://') || code.startsWith('https://')) {
        type = ScanResultType.link;
      } else if (code.endsWith('.doc') ||
          code.endsWith('.docx') ||
          code.endsWith('.txt')) {
        type = ScanResultType.document;
      } else {
        type = ScanResultType.unknown;
      }

      // Temporarily pause scanning while showing the result
      emit(state.copyWith(
          result: ScanResult(code, type), status: ScanStatus.paused));

      // Resume scanning after a short delay
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) {
        emit(state.copyWith(status: ScanStatus.scanning, result: null));
      }
    } catch (e) {
      emit(state.copyWith(
          error: 'Failed to process QR code', status: ScanStatus.paused));
    } finally {
      _processingCode = false;
    }
  }

  @override
  Future<void> close() {
    controller?.dispose();
    return super.close();
  }
}
