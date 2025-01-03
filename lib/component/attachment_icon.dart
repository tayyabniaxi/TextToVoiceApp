import 'package:flutter/material.dart';

IconData getAttachmentIcon(String mimeType) {
  if (mimeType.startsWith('image/')) {
    return Icons.image;
  } else if (mimeType.startsWith('video/')) {
    return Icons.video_file;
  } else if (mimeType.startsWith('audio/')) {
    return Icons.audio_file;
  } else if (mimeType.contains('pdf')) {
    return Icons.picture_as_pdf;
  } else if (mimeType.contains('word') ||
      mimeType.contains('document') ||
      mimeType.contains('msword')) {
    return Icons.description;
  } else if (mimeType.contains('spreadsheet') || mimeType.contains('excel')) {
    return Icons.table_chart;
  } else if (mimeType.contains('presentation') ||
      mimeType.contains('powerpoint')) {
    return Icons.slideshow;
  }
  return Icons.attach_file;
}
