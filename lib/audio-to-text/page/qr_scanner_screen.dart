// scanner_bloc.dart
// ignore_for_file: unused_element, deprecated_member_use, use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/bloc/qr_code_scanner_bloc_dart_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/bloc/qr_code_scanner_bloc_dart_event.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/bloc/qr_code_scanner_bloc_dart_state.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/qr_code_scanner_bloc_dart_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/qr_code_scanner_bloc_dart_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/qr_code_scanner/qr_code_scanner_bloc_dart_state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/link_reader_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScannerBloc()..add(StartScanning()),
      child: Scaffold(
        body: BlocConsumer<ScannerBloc, ScannerState>(
          listener: (context, state) {
            if (state.result != null) {
              showScanResult(context, state.result!);
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
          builder: (context, state) {
            if (!state.hasPermission) {
              return _buildPermissionRequest(context);
            }
            return Stack(
              children: [
                _QRViewWidget(),
                // _TopActionBar(),
                const _ScannerOverlay(),
                _BottomControls(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionRequest(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Camera Permission Required',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'We need camera access to scan QR codes',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                context.read<ScannerBloc>().add(RequestCameraPermission()),
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
}

class _QRViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerBloc, ScannerState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return QRView(
          key: GlobalKey(debugLabel: 'QR'),
          onQRViewCreated: (QRViewController controller) {
            context.read<ScannerBloc>().controller = controller;
            controller.scannedDataStream.listen((scanData) {
              if (scanData.code != null && state.isScanning) {
                context.read<ScannerBloc>().add(CodeScanned(scanData.code!));
              }
            });
          },
          overlay: QrScannerOverlayShape(
            borderColor: Colors.blue,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250,
          ),
        );
      },
    );
  }
}

/*
class _TopActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BlocBuilder<ScannerBloc, ScannerState>(
            //   buildWhen: (previous, current) =>
            //       previous.isFlashOn != current.isFlashOn,
            //   builder: (context, state) {
            //     return _ActionButton(
            //       icon: state.isFlashOn ? Icons.flash_on : Icons.flash_off,
            //       onTap: () => context.read<ScannerBloc>().add(ToggleFlash()),
            //     );
            //   },
            // ),
            // BlocBuilder<ScannerBloc, ScannerState>(
            //   buildWhen: (previous, current) =>
            //       previous.status != current.status,
            //   builder: (context, state) {
            //     return _ActionButton(
            //       icon: state.isScanning ? Icons.pause : Icons.play_arrow,
            //       onTap: () => context.read<ScannerBloc>().add(TogglePause()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
*/
class _BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 8,
              ),
            ],
          ),
          child: BlocBuilder<ScannerBloc, ScannerState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return Icon(
                state.isScanning ? Icons.qr_code_scanner : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              );
            },
          ),
        ),
      ),
    );
  }
}

/*
void showScanResult(BuildContext context, ScanResult result) {
  String title = 'Scan Result';
  IconData icon;
  Color color;

  switch (result.type) {
    case ScanResultType.image:
      icon = Icons.image;
      color = Colors.green;
      break;
    case ScanResultType.pdf:
      icon = Icons.picture_as_pdf;
      color = Colors.red;
      break;
    case ScanResultType.link:
      icon = Icons.link;
      color = Colors.blue;
      break;
    case ScanResultType.document:
      icon = Icons.description;
      color = Colors.orange;
      break;
    default:
      icon = Icons.help_outline;
      color = Colors.grey;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            '${result.typeString} Detected',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            result.data,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (result.type == ScanResultType.link ||
              result.type == ScanResultType.pdf ||
              result.type == ScanResultType.image)
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: Text('Open ${result.typeString}'),
              style: ElevatedButton.styleFrom(
                primary: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                // final url = Uri.parse(result.data);
                // if (await canLaunchUrl(url)) {
                //   await launchUrl(url);
                // }
                 Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LinkReaderScreen()));
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
*/
void showScanResult(BuildContext context, ScanResult result) {
  String title = 'Scan Result';
  IconData icon;
  Color color;

  switch (result.type) {
    case ScanResultType.image:
      icon = Icons.image;
      color = Colors.green;
      break;
    case ScanResultType.pdf:
      icon = Icons.picture_as_pdf;
      color = Colors.red;
      break;
    case ScanResultType.link:
      icon = Icons.link;
      color = Colors.blue;
      break;
    case ScanResultType.document:
      icon = Icons.description;
      color = Colors.orange;
      break;
    default:
      icon = Icons.help_outline;
      color = Colors.grey;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            '${result.typeString} Detected',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            result.data,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (result.type == ScanResultType.link ||
              result.type == ScanResultType.pdf ||
              result.type == ScanResultType.image)
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: Text('Open ${result.typeString}'),
              style: ElevatedButton.styleFrom(
                primary: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LinkReaderScreen()
                  ),
                );
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color ?? Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  final double scanAreaSize;
  final double borderRadius;

  const _ScannerOverlay({
    Key? key,
    this.scanAreaSize = 250,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black54,
          child: Center(
            child: Container(
              width: scanAreaSize,
              height: scanAreaSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - 3),
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: _buildCorner(),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Transform.rotate(
                          angle: 1.5708,
                          child: _buildCorner(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Transform.rotate(
                          angle: 3.14159,
                          child: _buildCorner(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Transform.rotate(
                          angle: -1.5708,
                          child: _buildCorner(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: scanAreaSize + 40,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Align QR code within the frame',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner() {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue, width: 3),
          top: BorderSide(color: Colors.blue, width: 3),
        ),
      ),
    );
  }
}
/*
class LinkReaderScreen extends StatelessWidget {
  final String scannedData;
  final ScanResultType scannedType;

  const LinkReaderScreen({
    Key? key,
    required this.scannedData,
    required this.scannedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Content'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getIconForType(scannedType),
                          color: _getColorForType(scannedType),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Scanned Content',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SelectableText(
                      scannedData,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 24),
                    if (_canOpenExternally(scannedType))
                      ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Open in Browser'),
                        onPressed: () => _launchUrl(scannedData),
                        style: ElevatedButton.styleFrom(
                          primary: _getColorForType(scannedType),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(ScanResultType type) {
    switch (type) {
      case ScanResultType.image:
        return Icons.image;
      case ScanResultType.pdf:
        return Icons.picture_as_pdf;
      case ScanResultType.link:
        return Icons.link;
      case ScanResultType.document:
        return Icons.description;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForType(ScanResultType type) {
    switch (type) {
      case ScanResultType.image:
        return Colors.green;
      case ScanResultType.pdf:
        return Colors.red;
      case ScanResultType.link:
        return Colors.blue;
      case ScanResultType.document:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  bool _canOpenExternally(ScanResultType type) {
    return type == ScanResultType.link ||
        type == ScanResultType.pdf ||
        type == ScanResultType.image;
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch $urlString');
    }
  }
}
*/