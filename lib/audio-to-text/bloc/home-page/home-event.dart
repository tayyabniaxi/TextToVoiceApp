abstract class HomePageEvent {}

class LoadItemsEvent extends HomePageEvent {
  final String url;

  LoadItemsEvent(this.url);
}

class SliderValueChange extends HomePageEvent {
  final double value;
  SliderValueChange(this.value);
}

class HidePopupDialog extends HomePageEvent {}

class InitializeSpeech extends HomePageEvent {}

class PlayAudioEvent extends HomePageEvent {}

class PauseAudioEvent extends HomePageEvent {}

class SeekAudioEvent extends HomePageEvent {
  final Duration position;
  SeekAudioEvent(this.position);
}

class ChangeSpeedEvent extends HomePageEvent {
  final double speed;
  ChangeSpeedEvent(this.speed);
}

class AudioDurationLoaded extends HomePageEvent {
  final Duration duration;
  AudioDurationLoaded(this.duration);
}

class UpdateTranscription extends HomePageEvent {
  final String transcription;
  UpdateTranscription(this.transcription);
}

// New Event for Country Selection
class ChangeCountryEvent extends HomePageEvent {
  final String country;
  ChangeCountryEvent(this.country);
}

class ShowPopupDialog extends HomePageEvent {}

class OpenCameraEvent extends HomePageEvent {
  final bool openCamera;
  OpenCameraEvent(this.openCamera);
}

class CaptureImageEvent extends HomePageEvent {
  final String imagePath;
  CaptureImageEvent(this.imagePath);
}

class EditImageEvent extends HomePageEvent {
  final String imagePath;
  EditImageEvent(this.imagePath);
}

class ApplyFilterEvent extends HomePageEvent {
  final int filterIndex;
  ApplyFilterEvent(this.filterIndex);
}

class RotateImageEvent extends HomePageEvent {}

class ResizeImageEvent extends HomePageEvent {
  final double scale;
  ResizeImageEvent(this.scale);
}

class CropImageEvent extends HomePageEvent {
  final String imagePath;
  CropImageEvent(this.imagePath);
}

class InitializeCameraEvent extends HomePageEvent {}

class OpenGalleryEvent extends HomePageEvent {}

class TakePictureEvent extends HomePageEvent {}

class FlipCameraEvent extends HomePageEvent {}

class HomePickAndProcessFileEvent extends HomePageEvent {}

class PickImageAndRecognizeTextEvent extends HomePageEvent {
  final bool isCamera;
  PickImageAndRecognizeTextEvent({required this.isCamera});
}

class ProcessEditedImage extends HomePageEvent {
  final String imagePath;
  ProcessEditedImage(this.imagePath);
}

