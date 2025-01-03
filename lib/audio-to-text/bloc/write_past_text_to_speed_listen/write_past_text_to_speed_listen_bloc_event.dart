import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/model/country_model.dart';
import 'package:new_wall_paper_app/model/tts_model.dart';

abstract class TextToSpeechEvent {}

class TextChanged extends TextToSpeechEvent {
  final String texts;
  TextChanged(this.texts);
}

class Speak extends TextToSpeechEvent {
  final Duration startFrom;

  Speak({this.startFrom = Duration.zero});
}

class ClearAudioRecordingsEvent extends TextToSpeechEvent {}

class Stop extends TextToSpeechEvent {}

class Pause extends TextToSpeechEvent {}

class TogglePlayPause extends TextToSpeechEvent {}

class ChangeSpeechRate extends TextToSpeechEvent {
  final double rate;
  ChangeSpeechRate(this.rate);
}

class SeekBy extends TextToSpeechEvent {
  final Duration offset;
  SeekBy(this.offset);
}

class SeekTo extends TextToSpeechEvent {
  final Duration position;
  SeekTo(this.position);
}

class Reset extends TextToSpeechEvent {}

class SelectCountry extends TextToSpeechEvent {
  final String country;
  SelectCountry(this.country);
}

class SelectVoice extends TextToSpeechEvent {
  final Voice voice;
  SelectVoice(this.voice);
}

class SelectCountryPic extends TextToSpeechEvent {
  final String countrypic;
  SelectCountryPic(this.countrypic);
}

class SelectLanguage extends TextToSpeechEvent {
  final Language language;
  SelectLanguage(this.language);
}

class WordSelected extends TextToSpeechEvent {
  final int wordIndex;
  WordSelected(this.wordIndex);
}

class ToggleLanguageOn extends TextToSpeechEvent {
  String selectLang;
  ToggleLanguageOn(this.selectLang);
}

class ToggleSubCategory extends TextToSpeechEvent {
  final String selectCountriesCode;
  final String CountryFlag;
  ToggleSubCategory(this.selectCountriesCode, this.CountryFlag);
}

class PitchValueChange extends TextToSpeechEvent {
  final double value;
  PitchValueChange(this.value);
}

class setVolumeValueChange extends TextToSpeechEvent {
  final double volumeValue;
  setVolumeValueChange(this.volumeValue);
}

class IncreaseTextSize extends TextToSpeechEvent {}

class DecreaseTextSize extends TextToSpeechEvent {}

// class InitializeWordKeys extends TextToSpeechEvent {
//   final String text;
//   InitializeWordKeys(this.text);
// }

class SelectFont extends TextToSpeechEvent {
  final String fontName;
  SelectFont(this.fontName);
}

class ChangeTheme extends TextToSpeechEvent {
  final ThemeData themeData;
  ChangeTheme(this.themeData);
}

class ChangeBackgroundColor extends TextToSpeechEvent {
  final Color backgroundColor;
  ChangeBackgroundColor(this.backgroundColor);
}

class ChangeColorToggle extends TextToSpeechEvent {}

class RequestStoragePermission extends TextToSpeechEvent {}

class SummarizeText extends TextToSpeechEvent {
  final String text;
  SummarizeText(this.text);
}

class HideShowPlayerToggle extends TextToSpeechEvent {}

class ScreenTouched extends TextToSpeechEvent {}

class UpdateText extends TextToSpeechEvent {
  final String editText;
  UpdateText(this.editText);
}

class UpdateVoicesEvent extends TextToSpeechEvent {
  final List<Voice> voices;
  UpdateVoicesEvent(this.voices);
}

class LoadingVoicesEvent extends TextToSpeechEvent {}

class VoicesErrorEvent extends TextToSpeechEvent {
  final String error;
  VoicesErrorEvent(this.error);
}

class FetchVoicesEvent extends TextToSpeechEvent {}

class SelectVoiceEvent extends TextToSpeechEvent {
  final Voice voice;
  SelectVoiceEvent(this.voice);
}

class LoadAudioEvent extends TextToSpeechEvent {
  final String text;
  final Voice voice;
  LoadAudioEvent(this.text, this.voice);
}

class AudioLoadedEvent extends TextToSpeechEvent {
  final String audioUrl;
  AudioLoadedEvent(this.audioUrl);
}

class InitializeWordKeys extends TextToSpeechEvent {
  final String text;
  InitializeWordKeys(this.text);
}

class DownloadAudioWithFormat extends TextToSpeechEvent {
  final String text;
  final String format;
  DownloadAudioWithFormat(this.text, this.format);
}

class InitializeText extends TextToSpeechEvent {
  final String text;
  InitializeText(this.text);
}

class OpenAllFuctinoBottomSheet extends TextToSpeechEvent {}

class SpeedrateBottomSheet extends TextToSpeechEvent {}

class WeeklySchuduleBottomSheet extends TextToSpeechEvent {}

// In your existing events file
class SummarizeTextEvent extends TextToSpeechEvent {
  String text;
  SummarizeTextEvent(this.text);
}

class OpenTimePickerEvent extends TextToSpeechEvent {}

class UpdateReminderTimeEvent extends TextToSpeechEvent {
  final TimeOfDay newTime;
  final int seconds;
  UpdateReminderTimeEvent(this.newTime, this.seconds);
}

class DownloadCurrentAudio extends TextToSpeechEvent {}

class LoadSavedSchedules extends TextToSpeechEvent {}

class SaveScheduleEvent extends TextToSpeechEvent {
  final Map<String, dynamic> schedule;
  SaveScheduleEvent(this.schedule);
}

class UpdateGoalEvent extends TextToSpeechEvent {
  final String goal;
  UpdateGoalEvent(this.goal);
}

class UpdateSelectedDayEvent extends TextToSpeechEvent {
  final int dayIndex;
  UpdateSelectedDayEvent(this.dayIndex);
}

class ToggleRemindMeEvent extends TextToSpeechEvent {
  final bool value;
  ToggleRemindMeEvent(this.value);
}

class ResetSchedulesEvent extends TextToSpeechEvent {}

class UpdateSelectedDaysEvent extends TextToSpeechEvent {
  final List<int> selectedDays;
  UpdateSelectedDaysEvent(this.selectedDays);
}

class ResetScheduleEvent extends TextToSpeechEvent {}

class RenameFile extends TextToSpeechEvent {
  final String oldFileName;
  final String newFileName;
  RenameFile(this.oldFileName, this.newFileName);
}

class StartCountdownEvent extends TextToSpeechEvent {
  final Duration duration;
  final TimeOfDay reminderTime;

  StartCountdownEvent({
    required this.duration,
    required this.reminderTime,
  });
}

class StartTimer extends TextToSpeechEvent {}

class CompleteCountdownEvent extends TextToSpeechEvent {}

class PauseCountdownEvent extends TextToSpeechEvent {}

class ResumeCountdownEvent extends TextToSpeechEvent {}

class CancelCountdownEvent extends TextToSpeechEvent {}

class UpdateTimePickerEvent extends TextToSpeechEvent {
  final int hours;
  final int minutes;
  final int seconds;
  UpdateTimePickerEvent(this.hours, this.minutes, this.seconds);
}
// Add these events to your TextToSpeechEvent class

// Event to load saved schedule
class LoadSavedScheduleEvent extends TextToSpeechEvent {}

// Event when schedule is loaded from storage
class ScheduleLoadedEvent extends TextToSpeechEvent {
  final Map<String, dynamic> scheduleData;
  ScheduleLoadedEvent(this.scheduleData);
}

// Event to save current schedule
class SaveCurrentScheduleEvent extends TextToSpeechEvent {
  final List<int> selectedDays;
  final String goalPerDay;
  final TimeOfDay reminderTime;
  final bool remindMeToRead;
  final int selectedHour;
  final int selectedMinute;

  SaveCurrentScheduleEvent({
    required this.selectedDays,
    required this.goalPerDay,
    required this.reminderTime,
    required this.remindMeToRead,
    required this.selectedHour,
    required this.selectedMinute,
  });
}

// Event when schedule is cleared
class ClearScheduleEvent extends TextToSpeechEvent {}

class SetDeviceTheme extends TextToSpeechEvent {
  final bool useDeviceTheme;
  SetDeviceTheme(this.useDeviceTheme);

  @override
  List<Object?> get props => [useDeviceTheme];
}
