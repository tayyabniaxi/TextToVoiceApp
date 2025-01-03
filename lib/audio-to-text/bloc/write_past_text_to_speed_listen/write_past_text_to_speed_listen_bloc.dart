// // ignore_for_file: prefer_const_declarations, non_constant_identifier_names, unused_element, prefer_final_fields

// ignore_for_file: prefer_final_fields, unused_field, unused_element, prefer_const_declarations, prefer_interpolation_to_compose_strings, avoid_print, await_only_futures, unnecessary_null_comparison, unused_local_variable, invalid_use_of_visible_for_testing_member, unnecessary_brace_in_string_interps, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_state.dart';
import 'package:new_wall_paper_app/component/bottomsheet.dart';
import 'package:new_wall_paper_app/helper/schedule_storage_helper.dart';
import 'package:new_wall_paper_app/helper/store_tts_audio.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:new_wall_paper_app/model/tts_model.dart';
import 'package:new_wall_paper_app/audio-to-text/repo/tts_repo.dart';
import 'package:new_wall_paper_app/res/app_url.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextToSpeechBloc extends Bloc<TextToSpeechEvent, TextToSpeechState> {
  final TtsRepo _ttsRepo;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _progressTimer;
  BuildContext? context;
  Duration totalDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  String selectedCountry = '';
  String CountryFlat = '';
  String selectLang = '';
  String selectCountriesCode = '';
  static const int _maxChunkSize = 100;
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  Timer? _timer;
  bool _isProcessingChunk = false;
  late ScrollController scrollController;
  bool allowManualScroll = false;
  final Map<int, Duration> _chunkDurations = {};
  Duration _accumulatedDuration = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;
  Timer? _countdownTimer;
  final Map<int, GlobalKey> _wordKeys = {};
  bool _isDialogShowing = false;
  GlobalKey getKeyForWord(int index) {
    if (!_wordKeys.containsKey(index)) {
      _wordKeys[index] = GlobalKey();
    }
    return _wordKeys[index]!;
  }

  void clearWordKeys() {
    _wordKeys.clear();
  }

  TextToSpeechBloc({required TtsRepo ttsRepo})
      : _ttsRepo = ttsRepo,
        super(TextToSpeechState.initial()) {
    on<TextChanged>(_onTextChanged);
    on<Speak>(_onSpeak);
    on<Stop>(_onStop);
    on<Pause>(_onPause);
    on<TogglePlayPause>(_onTogglePlayPause);
    on<ChangeColorToggle>(_onToggleChangeColor);
    on<ChangeSpeechRate>(_onChangeSpeechRate);
    on<SeekBy>(_onSeekBy);
    on<SeekTo>(_onSeekTo);
    on<Reset>(_onReset);
    on<SelectCountry>(_onCountrySelected);
    on<SelectCountryPic>(_onCountryPicSelected);
    on<SelectLanguage>(_onLanguageSelected);
    on<ToggleLanguageOn>(isSelectLanguageOnn);
    on<ToggleSubCategory>(ToggleSubCategries);
    on<WordSelected>(_onWordSelected);
    on<PitchValueChange>(_onSliderValueChanged);
    on<setVolumeValueChange>(_onSlidersetVolumeValueChange);
    on<IncreaseTextSize>(_onIncreaseTextSize);
    on<DecreaseTextSize>(_onDecreaseTextSize);
    on<InitializeWordKeys>(_onInitializeWordKeys);
    on<SelectFont>(_onFontSelected);
    on<ChangeTheme>(_onChangeThemeColor);
    on<ChangeBackgroundColor>(_onChangeBackgroundColor);
    on<RequestStoragePermission>(_onRequestStoragePermission);
    on<SummarizeTextEvent>(_onSummarizeText);
    on<HideShowPlayerToggle>(_onHideShowPlayerToggle);
    on<UpdateText>(_onUpdateText);
    on<ScreenTouched>(_onTouchScreenEvent);
    on<FetchVoicesEvent>(_onFetchVoices);
    on<SelectVoiceEvent>(_onSelectVoice);
    on<RenameFile>(_onRenameFile);
    on<DownloadAudioWithFormat>(_onDownloadAudioWithFormat);
    on<DownloadCurrentAudio>(_onDownloadCurrentAudio);
    on<OpenAllFuctinoBottomSheet>(_onOpenAudioFormatBottomSheet);
    on<SpeedrateBottomSheet>(_onOpenSpeedRateBottomSheet);
    on<WeeklySchuduleBottomSheet>(_onWeeklySchuduleBottomSheet);
    on<OpenTimePickerEvent>(_onOpenTimePicker);
    on<UpdateReminderTimeEvent>(_onUpdateReminderTime);
    on<SaveScheduleEvent>(_onSaveSchedule);
    on<UpdateGoalEvent>(_onUpdateGoal);
    on<UpdateSelectedDayEvent>(_onUpdateSelectedDay);
    on<ToggleRemindMeEvent>(_onToggleRemindMe);
    on<UpdateSelectedDaysEvent>(_onUpdateSelectedDays);
    on<ResetScheduleEvent>(_onResetSchedule);
    on<UpdateTimePickerEvent>(_onUpdateTimePicker);
    on<StartCountdownEvent>(_onStartCountdown);
    on<PauseCountdownEvent>(_onPauseCountdown);
    // on<ResumeCountdownEvent>(_onResumeCountdown);
    on<CancelCountdownEvent>(_onCancelCountdown);
    on<LoadSavedScheduleEvent>(_onLoadSavedSchedule);
    on<SaveCurrentScheduleEvent>(_onSaveCurrentSchedule);
    on<ClearAudioRecordingsEvent>(_onClearAudioRecordings);
    on<SetDeviceTheme>(_onSetDeviceTheme);
    // on<StartTimer>(_onStartTimer);
    // on<ClearScheduleEvent>(_onClearSchedule);
    _initializeAudioPlayer();
  }
  Future<void> _onSaveSchedule(
    SaveScheduleEvent event,
    Emitter<TextToSpeechState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('weeklySchedule', json.encode(event.schedule));

      emit(state.copyWith(
        currentSchedule: event.schedule,
      ));

      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('Schedule updated successfully!')),
        );
      }
    } catch (e) {
      print('Error saving schedule: $e');
      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('Error updating schedule')),
        );
      }
    }
  }

  void _onSetDeviceTheme(
      SetDeviceTheme event, Emitter<TextToSpeechState> emit) {
    final brightness = MediaQuery.of(context!).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    emit(state.copyWith(
      useDeviceTheme: true,
      useLightTheme: false,
      isDarkMode: isDarkMode,
      isChangeColor: isDarkMode,
      themeData: ThemeData(
        scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: isDarkMode ? Colors.white : Colors.black,
              displayColor: isDarkMode ? Colors.white : Colors.black,
            ),
      ),
    ));
  }

  void _onChangeBackgroundColor(
      ChangeBackgroundColor event, Emitter<TextToSpeechState> emit) {
    final isDark = event.backgroundColor == Colors.black;

    emit(state.copyWith(
      useDeviceTheme: false,
      useLightTheme: !isDark,
      isDarkMode: isDark,
      isChangeColor: isDark,
      themeData: ThemeData(
        scaffoldBackgroundColor: event.backgroundColor,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: isDark ? Colors.white : Colors.black,
              displayColor: isDark ? Colors.white : Colors.black,
            ),
      ),
    ));
  }
  // Future<void> _onStartTimer(
  //   StartTimer event,
  //   Emitter<TextToSpeechState> emit,
  // ) async {
  //   emit(state.copyWith(isTimePickerActive: true));
  // }

  void _onUpdateTimePicker(
      UpdateTimePickerEvent event, Emitter<TextToSpeechState> emit) {
    emit(state.copyWith(
      selectedHour: event.hours,
      selectedMinute: event.minutes,
      selectedSecond: event.seconds,
    ));
  }

  void _onStartCountdown(
      StartCountdownEvent event, Emitter<TextToSpeechState> emit) {
    final totalDuration = Duration(
        hours: state.selectedHour,
        minutes: state.selectedMinute,
        seconds: state.selectedSecond);

    emit(state.copyWith(
        isCountdownActive: true,
        isTimePickerActive: true,
        elapsedTime: Duration.zero,
        timerStatus: TimerStatus.running));

    add(Speak());
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPlaying) {
        timer.cancel();
        return;
      }

      final currentPosition = _audioPlayer.position;
      final elapsedTime = Duration(seconds: timer.tick);
      final remainingTime = totalDuration - elapsedTime;

      if (remainingTime <= Duration.zero) {
        timer.cancel();
        add(Stop());
        emit(state.copyWith(
            isCountdownActive: false,
            isTimePickerActive: false,
            timerStatus: TimerStatus.completed,
            elapsedTime: totalDuration));
      } else {
        emit(state.copyWith(
            elapsedTime: elapsedTime,
            isCountdownActive: true,
            isTimePickerActive: false,
            timerStatus: TimerStatus.running));
      }
    });
  }

  void _onPauseCountdown(
      PauseCountdownEvent event, Emitter<TextToSpeechState> emit) {
    // _timer?.cancel();
    add(Pause());
    emit(state.copyWith(
        isCountdownActive: false, timerStatus: TimerStatus.paused));
  }

  void _onCompleteCountdown(
    CompleteCountdownEvent event,
    Emitter<TextToSpeechState> emit,
  ) {
    _timer?.cancel();
    emit(state.copyWith(
      isCountdownActive: false,
      elapsedTime: Duration.zero,
    ));

    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('Goal completed!')),
      );
    }
  }

  void _onCancelCountdown(
      CancelCountdownEvent event, Emitter<TextToSpeechState> emit) {
    _timer?.cancel();
    add(Stop());
    emit(state.copyWith(
        timerStatus: TimerStatus.initial,
        elapsedTime: Duration.zero,
        isTimePickerActive: false));
  }

  void _onResetSchedule(
    ResetScheduleEvent event,
    Emitter<TextToSpeechState> emit,
  ) async {
    try {
      await ScheduleStorageHelper.clearStorage();

      emit(TextToSpeechState.initial().copyWith(
        selectedDays: [],
        goalPerDay: '1 Hour',
        reminderTime: const TimeOfDay(hour: 0, minute: 0),
        remindMeToRead: false,
        selectedHour: 0,
        selectedMinute: 0,
        currentSchedule: {
          'selectedDays': [],
          'goalPerDay': '1 Hour',
          'reminderTime': {'hour': 0, 'minute': 0},
          'remindMeToRead': false,
        },
      ));

      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('Schedule has been reset')),
        );
      }
    } catch (e) {
      print('Error resetting schedule: $e');
      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('Error resetting schedule')),
        );
      }
    }
  }

  void _onUpdateSelectedDays(
    UpdateSelectedDaysEvent event,
    Emitter<TextToSpeechState> emit,
  ) {
    emit(state.copyWith(selectedDays: event.selectedDays));
  }

  void _onToggleRemindMe(
    ToggleRemindMeEvent event,
    Emitter<TextToSpeechState> emit,
  ) async {
    final List<Map<String, String>> days = [
      {'day': 'Sun', 'date': '01'},
      {'day': 'Mon', 'date': '02'},
      {'day': 'Tue', 'date': '03'},
      {'day': 'Wed', 'date': '04'},
      {'day': 'Thu', 'date': '05'},
      {'day': 'Fri', 'date': '06'},
      {'day': 'Sat', 'date': '07'},
    ];
    try {
      // Create new schedule entry
      final newSchedule = {
        'day': days[state.selectedDayIndex]['day'],
        'goalPerDay': state.goalPerDay,
        'reminderTime': {
          'hour': state.reminderTime.hour,
          'minute': state.reminderTime.minute,
        },
        'remindMeToRead': event.value,
        'timestamp': DateTime.now().toIso8601String(),
      };
      final prefs = await SharedPreferences.getInstance();
      // Save the new schedule
      await prefs.setString('weeklySchedule', json.encode(newSchedule));

      // Update state with new schedule
      emit(state.copyWith(
        currentSchedule: newSchedule,
      ));
    } catch (e) {
      print('Error toggling remind me: $e');
      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('Error updating reminder setting')),
        );
      }
    }
  }

  void _onUpdateGoal(
    UpdateGoalEvent event,
    Emitter<TextToSpeechState> emit,
  ) {
    emit(state.copyWith(
      goalPerDay: event.goal,
    ));
  }

  void _onUpdateSelectedDay(
    UpdateSelectedDayEvent event,
    Emitter<TextToSpeechState> emit,
  ) {
    emit(state.copyWith(
      selectedDayIndex: event.dayIndex,
    ));
  }

  void _onUpdateReminderTime(
    UpdateReminderTimeEvent event,
    Emitter<TextToSpeechState> emit,
  ) {
    emit(state.copyWith(
      reminderTime: event.newTime,
      selectedSeconds: event.seconds,
      selectedHour: event.newTime.hour,
      selectedMinute: event.newTime.minute,
    ));
  }

  void _onOpenTimePicker(
    OpenTimePickerEvent event,
    Emitter<TextToSpeechState> emit,
  ) {
    if (context != null) {
      showModalBottomSheet(
        context: context!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => TimePickerBottomSheet(
          initialTime: state.reminderTime,
          onTimeSelected: (newTime, second) {
            add(UpdateReminderTimeEvent(newTime, second));
          },
        ),
      );
    }
  }

  void _onLoadSavedSchedule(
    LoadSavedScheduleEvent event,
    Emitter<TextToSpeechState> emit,
  ) async {
    try {
      final savedSchedule = await ScheduleStorageHelper.getSchedule();
      if (savedSchedule != null) {
        final reminderTimeMap =
            savedSchedule['reminderTime'] as Map<String, dynamic>?;
        final hour = reminderTimeMap?['hour'] ?? 0;
        final minute = reminderTimeMap?['minute'] ?? 0;

        emit(state.copyWith(
          currentSchedule: savedSchedule,
          goalPerDay: savedSchedule['goalPerDay'] ?? '1 Hour',
          selectedDays: List<int>.from(savedSchedule['selectedDays'] ?? []),
          remindMeToRead: savedSchedule['remindMeToRead'] ?? false,
          selectedHour: hour,
          selectedMinute: minute,
          reminderTime: TimeOfDay(hour: hour, minute: minute),
        ));
      }
    } catch (e) {
      print('Error loading saved schedule: $e');
    }
  }

  Future<void> _onSaveCurrentSchedule(
    SaveCurrentScheduleEvent event,
    Emitter<TextToSpeechState> emit,
  ) async {
    try {
      await ScheduleStorageHelper.saveSchedule(
        selectedDays: event.selectedDays,
        goalPerDay: event.goalPerDay,
        reminderTime: event.reminderTime,
        remindMeToRead: event.remindMeToRead,
        selectedHour: event.selectedHour,
        selectedMinute: event.selectedMinute,
      );

      final scheduleData = {
        'selectedDays': event.selectedDays,
        'goalPerDay': event.goalPerDay,
        'reminderTime': {
          'hour': event.selectedHour,
          'minute': event.selectedMinute,
        },
        'remindMeToRead': event.remindMeToRead,
        'selectedHour': event.selectedHour,
        'selectedMinute': event.selectedMinute,
      };

      emit(state.copyWith(
        currentSchedule: scheduleData,
        selectedDays: event.selectedDays,
        goalPerDay: event.goalPerDay,
        reminderTime: event.reminderTime,
        remindMeToRead: event.remindMeToRead,
        selectedHour: event.selectedHour,
        selectedMinute: event.selectedMinute,
      ));

      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('Schedule saved successfully!')),
        );
      }
    } catch (e) {
      print('Error saving schedule: $e');
      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('Error saving schedule')),
        );
      }
    }
  }

  Future<void> _initializeAudioPlayer() async {
    _audioPlayer.playerStateStream.listen((playerState) {
      print('AudioPlayer state changed: ${playerState.processingState}');
      if (playerState.processingState == ProcessingState.completed) {
        add(Stop());
      }
    });

    _audioPlayer.positionStream.listen((position) {
      if (state.isPlaying) {
        emit(state.copyWith(
          currentPosition: position,
        ));
        _updateHighlightedWord(position);
      }
    });

    _audioPlayer.playingStream.listen((playing) {
      print('AudioPlayer playing state: $playing');
      if (!playing && state.isPlaying) {
        emit(state.copyWith(
          isPlaying: false,
          isPaused: true,
        ));
      }
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {});
  }

  void _onTextChanged(TextChanged event, Emitter<TextToSpeechState> emit) {
    emit(state.copyWith(text: event.texts));
  }

  void _onUpdateText(UpdateText event, Emitter<TextToSpeechState> emit) {
    emit(state.copyWith(text: event.editText));
  }

  // change theme  Color
  _onChangeThemeColor(ChangeTheme event, Emitter<TextToSpeechState> emit) {
    emit(state.copyWith(themeData: event.themeData));
  }

  void _onOpenAudioFormatBottomSheet(
      OpenAllFuctinoBottomSheet event, Emitter<TextToSpeechState> emit) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context!,
      backgroundColor: Colors.transparent,
      builder: (context) => OpenAllFuctinoBottomSheetWidget(
        onFormatSelect: (format) {
          if (state.summarizedText.isNotEmpty) {
            add(DownloadAudioWithFormat(state.summarizedText, format));
          } else if (state.normarlText.isNotEmpty) {
            add(DownloadAudioWithFormat(state.normarlText, format));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter some text')),
            );
          }
        },
      ),
    );
  }

  void _onOpenSpeedRateBottomSheet(
      SpeedrateBottomSheet event, Emitter<TextToSpeechState> emit) {
    if (context == null) return;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context!,
      backgroundColor: Colors.transparent,
      builder: (context) => SpeedRateBottomSheetWidget(
        initialValue: state.speechRate,
        onSpeedChanged: (newRate) {
          add(ChangeSpeechRate(newRate));
        },
      ),
    );
  }

  void _onWeeklySchuduleBottomSheet(
      WeeklySchuduleBottomSheet event, Emitter<TextToSpeechState> emit) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context!,
      backgroundColor: Colors.transparent,
      builder: (context) => WeeklyScheduleWidget(),
    );
  }

  Future<void> _onSummarizeText(
      SummarizeTextEvent event, Emitter<TextToSpeechState> emit) async {
    final trimmedText = event.text.trim();
    if (trimmedText.isEmpty) {
      emit(state.copyWith(
          isSummarizing: false,
          summarizationError: 'Please enter some text to summarize'));
      return;
    }

    if (trimmedText.split(' ').length < 5) {
      emit(state.copyWith(
          isSummarizing: false,
          summarizationError:
              'Text is too short to summarize. Please provide more context.'));
      return;
    }

    try {
      final String apiKey = Apis.cloudApi;
      final String apiUrl = Apis.geminiProSummarizeApis;
      emit(state.copyWith(isLoading: true));
      final payload = {
        "contents": [
          {
            "parts": [
              {"text": "Summarize the following text:\n${trimmedText}"}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        }
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        var parsedResponse = jsonDecode(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);

        final summary = _extractComprehensiveSummary(data);
        _audioPlayer.stop();
        _progressTimer?.cancel();
        _timer?.cancel();
        if (summary.isNotEmpty) {
          emit(state.copyWith(
            text: summary,
            summarizedText: summary,
            isSummarizing: false,
            summarizationError: '',
            currentWordIndex: 0,
            currentPosition: Duration.zero,
            isPlaying: false,
            isPaused: false,
            isLoading: false,
            originalAudioDuration: Duration.zero,
            wordStartTimes: [],
          ));
        } else {
          emit(state.copyWith(
            summarizationError: 'Unable to generate a meaningful summary.',
            isSummarizing: false,
          ));
        }
      } else {
        emit(state.copyWith(
          summarizationError: 'API Error: ${response.statusCode}',
          isSummarizing: false,
        ));
      }
    } catch (e) {
      print('Summarization Error: $e');
      emit(state.copyWith(
        summarizationError: 'Unexpected error: $e',
        isSummarizing: false,
      ));
    }
  }

  String getFileName() {
    if (state.summarizedText.isEmpty) {
      return "";
    }
    if (state.normarlText.isEmpty) return "Untitled Text";

    final words = state.summarizedText.isEmpty
        ? state.normarlText.split(" ")
        : state.summarizedText.split(" ");
    if (words.isEmpty) return "Untitled Text";

    String fileName = words.take(3).join(" ").trim();
    return fileName.isNotEmpty ? "$fileName.txt" : "Untitled Text";
  }

  String _extractComprehensiveSummary(Map<String, dynamic> data) {
    try {
      final extractionStrategies = [
        () {
          final text = data['candidates'][0]['content']['parts'][0]['text'] ??
              'No summary available';
          return text;
        },
        () {
          final candidates = data['candidates'];
          if (candidates is List && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            final parts = content['parts'];
            if (parts is List && parts.isNotEmpty) {
              final text = parts[0]['text'] as String?;
              return text;
            }
          }
          return '';
        },
      ];

      for (var strategy in extractionStrategies) {
        String summary = strategy();

        if (_isValidSummary(summary)) return summary;
      }

      return '';
    } catch (e) {
      print('Comprehensive summary extraction error: $e');
      return '';
    }
  }

  bool _isValidSummary(String summary) {
    if (summary.isEmpty) return false;

    final invalidResponses = [
      'no information to summarize',
      'text is too short',
      'cannot generate a summary',
      'does not contain any information',
    ];
    for (var response in invalidResponses) {
      if (summary.toLowerCase().contains(response)) {
        return false;
      }
    }

    return summary.split(' ').length > 5;
  }

  String _cleanupSummary(String summary) {
    if (summary.isEmpty) return '';

    return summary;
  }

  void _updateHighlightedWord(Duration position) {
    if (state.wordStartTimes.isEmpty) return;

    int newWordIndex = _findWordIndexForTime(position, state.wordStartTimes);
    if (newWordIndex != state.currentWordIndex) {
      emit(state.copyWith(
        currentPosition: position,
        currentWordIndex: newWordIndex,
      ));

      if (context != null && state.isPlaying) {
        Future.microtask(() {
          scrollToHighlightedWord(context!, newWordIndex);
        });
      }
    }
  }

  void _onRenameFile(RenameFile event, Emitter<TextToSpeechState> emit) async {
    try {
      emit(state.copyWith(isRenaming: true));

      emit(state.copyWith(
        currentFileName: event.newFileName,
        isRenaming: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Error renaming file: $e',
        isRenaming: false,
      ));
    }
  }

// In TextToSpeechBloc
  Future<void> _onDownloadAudioWithFormat(
      DownloadAudioWithFormat event, Emitter<TextToSpeechState> emit) async {
    try {
      bool hasPermission = await PermissionHandler.requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission required');
      }

      emit(state.copyWith(isDownloadingFormat: true));

      final ttsRequest = TTSRequest(
        input: TextInput(
            text: state.summarizedText.isEmpty
                ? state.normarlText
                : state.summarizedText),
        voice: VoiceSelectionParams(
          languageCode: state.selectedVoice?.languageCodes.first ?? 'en-US',
          name: state.selectedVoice?.name ?? 'en-US-Standard-A',
        ),
        audioConfig: AudioConfig(
          audioEncoding: _getAudioEncoding(event.format),
          speakingRate: state.speechRate,
          pitch: state.setPitch,
          volumeGainDb:
              state.setValume != null ? (state.setValume * 20) - 10 : null,
        ),
      );

      final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
      final audioBytes = base64Decode(audioContent);

      final String downloadPath = await _getDownloadPath();
      final File file =
          await _saveAudioFile(downloadPath, event.format, audioBytes);

      await MediaScanner.loadMedia(path: file.path);

      emit(state.copyWith(
          isDownloadingFormat: false, downloadedFilePath: file.path));

      _showSuccessMessage(file.path);
    } catch (e) {
      print('Download error: $e');
      emit(state.copyWith(isDownloadingFormat: false));
      _showErrorMessage(e.toString());
    }
  }

  Future<String> _getDownloadPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download/Qaiser/Audio';
    }
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/Qaiser/Audio';
  }

  Future<File> _saveAudioFile(
      String dirPath, String format, List<int> bytes) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'voice_$timestamp$format';
    final file = File('$dirPath/$fileName');

    await file.writeAsBytes(bytes);
    return file;
  }

  void _showSuccessMessage(String path) {
    if (context != null) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('Audio saved to $path')));
    }
  }

  void _showErrorMessage(String error) {
    if (context != null) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('Download failed: $error')));
    }
  }

  String _getAudioEncoding(String format) {
    switch (format.toUpperCase()) {
      case '.MP3':
        return 'MP3';
      case '.WAV':
        return 'LINEAR16';
      case '.OGG':
        return 'OGG_OPUS';
      case '.AAC':
        return 'AAC';
      case '.FLAC':
        return 'FLAC';
      default:
        return 'MP3';
    }
  }

  Future<void> _onDownloadCurrentAudio(
      DownloadCurrentAudio event, Emitter<TextToSpeechState> emit) async {
    try {
      if (_audioPlayer.audioSource == null) {
        throw Exception('No audio playing');
      }

      emit(state.copyWith(isDownloading: true, downloadProgress: 0.0));

      final ttsRequest = TTSRequest(
        input: TextInput(
            text: state.summarizedText.isEmpty
                ? state.normarlText
                : state.summarizedText),
        voice: VoiceSelectionParams(
          languageCode: state.selectedVoice?.languageCodes.first ?? 'en-US',
          name: state.selectedVoice?.name ?? 'en-US-Standard-A',
        ),
        audioConfig: AudioConfig(
          audioEncoding: 'MP3',
          speakingRate: state.speechRate,
          pitch: state.setPitch,
          volumeGainDb:
              state.setValume != null ? (state.setValume * 20) - 10 : null,
        ),
      );

      final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
      final audioBytes = base64Decode(audioContent);

      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      final appDir = await getExternalStorageDirectory();
      if (appDir == null) throw Exception('Cannot access storage');

      final qaiserDir = Directory('${appDir.path}/Qaiser/Audio');
      if (!await qaiserDir.exists()) {
        await qaiserDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'voice_$timestamp.mp3';
      final filePath = '${qaiserDir.path}/$fileName';
      final file = File(filePath);

      final chunkSize = 1024 * 8;
      int offset = 0;

      while (offset < audioBytes.length) {
        final end = math.min(offset + chunkSize, audioBytes.length);
        final chunk = audioBytes.sublist(offset, end);
        await file.writeAsBytes(chunk, mode: FileMode.append);

        offset += chunkSize;
        final progress = offset / audioBytes.length;
        emit(state.copyWith(downloadProgress: progress));

        await Future.delayed(Duration(milliseconds: 10));
      }

      await _scanFile(filePath);

      emit(state.copyWith(
          isDownloading: false,
          downloadProgress: 1.0,
          downloadedFilePath: filePath));

      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Audio saved to Qaiser/Audio/$fileName')),
      );
    } catch (e) {
      print('Download error: $e');
      emit(state.copyWith(isDownloading: false));
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  Future<void> _scanFile(String filePath) async {
    try {
      await MediaScanner.loadMedia(path: filePath);
    } catch (e) {
      print('Media scan error: $e');
    }
  }

  Future<File> _getCurrentAudioFile() async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/current_audio.mp3';
    return File(tempPath);
  }

  Future<void> _scanMedia(String filePath) async {
    final channel = const MethodChannel('app_channel');
    try {
      await channel.invokeMethod('scanFile', {'path': filePath});
    } catch (e) {
      print('Error scanning media: $e');
    }
  }

  Future<void> _onWordSelected(
      WordSelected event, Emitter<TextToSpeechState> emit) async {
    final text =
        state.summarizedText.isEmpty ? state.normarlText : state.summarizedText;
    final words = text.split(' ');
    if (event.wordIndex >= words.length) return;

    try {
      context?.read<TextToSpeechBloc>().add(ScreenTouched());
      allowManualScroll = true;

      await _audioPlayer.stop();
      _progressTimer?.cancel();

      final Duration position = state.wordStartTimes[event.wordIndex];

      final existingRecording =
          await TTSAudioStorageHelper.findExistingRecording(
        text: text,
        speechRate: state.speechRate,
        voiceName: state.selectedVoice?.name,
        pitch: state.setPitch,
        volume: state.setValume,
      );

      if (existingRecording != null) {
        final audioFile = File(existingRecording['filePath']);
        await _audioPlayer.setFilePath(audioFile.path);
      } else {
        final ttsRequest = TTSRequest(
          input: TextInput(text: text),
          voice: VoiceSelectionParams(
            languageCode: state.selectedVoice?.languageCodes.first ?? 'en-US',
            name: state.selectedVoice?.name ?? 'en-US-Standard-A',
          ),
          audioConfig: AudioConfig(
            audioEncoding: 'MP3',
            speakingRate: state.speechRate,
            pitch: state.setPitch,
            volumeGainDb:
                state.setValume != null ? (state.setValume * 20) - 10 : null,
          ),
        );

        final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
        final audioBytes = base64Decode(audioContent);

        final tempDir = await getTemporaryDirectory();
        final tempFile = File(
            '${tempDir.path}/word_selection_${DateTime.now().millisecondsSinceEpoch}.mp3');
        await tempFile.writeAsBytes(audioBytes);

        await _audioPlayer.setFilePath(tempFile.path);

        await TTSAudioStorageHelper.saveAudioRecording(
          text: text,
          audioBytes: audioBytes,
          textHash: TTSAudioStorageHelper.generateTextHash(
            text,
            speechRate: state.speechRate,
            voiceName: state.selectedVoice?.name,
            pitch: state.setPitch,
            volume: state.setValume,
          ),
          speechRate: state.speechRate,
          voiceName: state.selectedVoice?.name,
          pitch: state.setPitch,
          volume: state.setValume,
        );
      }

      emit(state.copyWith(
        currentWordIndex: event.wordIndex,
        currentPosition: position,
        isPlaying: true,
        isPaused: false,
      ));

      await _audioPlayer.seek(position);
      await Future.delayed(const Duration(milliseconds: 100));
      await _audioPlayer.play();
      _startProgressTimer();

      Future.delayed(const Duration(milliseconds: 100), () {
        allowManualScroll = false;
      });
    } catch (e) {
      print('Error in word selection: $e');
      emit(state.copyWith(
        isPlaying: false,
        isPaused: true,
        error: 'Error playing from selected word: $e',
      ));
    }
  }

  void isSelectLanguageOnn(
      ToggleLanguageOn event, Emitter<TextToSpeechState> emit) {
    selectLang = event.selectLang;
    state.languageCode = event.selectLang;
    emit(state.copyWith(
        isLanguageSelectOn: !state.isLanguageSelectOn,
        selectCountriesCode: selectLang,
        countryFlat: state.countryFlat));
  }

  void ToggleSubCategries(
      ToggleSubCategory event, Emitter<TextToSpeechState> emit) {
    selectCountriesCode = event.selectCountriesCode;
    CountryFlat = event.CountryFlag;
    state.countryCode = event.selectCountriesCode;
    emit(state.copyWith(
        ToggleSubCategory: !state.ToggleSubCategory,
        selectLang: selectCountriesCode,
        countryFlat: CountryFlat));
  }

  void _prepareTextChunks(String text) {
    _textChunks.clear();
    if (text.isEmpty) return;

    final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    String currentChunk = '';
    for (final sentence in sentences) {
      if ((currentChunk + sentence).length <= _maxChunkSize) {
        currentChunk += '$sentence ';
      } else {
        _textChunks.add(currentChunk.trim());
        currentChunk = '$sentence ';
      }
    }
    if (currentChunk.isNotEmpty) {
      _textChunks.add(currentChunk.trim());
    }
  }

  void _onCountrySelected(
      SelectCountry event, Emitter<TextToSpeechState> emit) {
    String newSelectedCountry = event.country;

    emit(state.copyWith(selectedCountry: newSelectedCountry));

    final updatedHistory = List<String>.from(state.countryHistory);
    if (!updatedHistory.contains(newSelectedCountry)) {
      updatedHistory.add(newSelectedCountry);
      emit(state.copyWith(countryHistory: updatedHistory));
    }
  }

  void _onCountryPicSelected(
      SelectCountryPic event, Emitter<TextToSpeechState> emit) async {
    if (state.isPlaying) {
      await _audioPlayer.stop();
    }
    String newSelectedCountry = event.countrypic;

    emit(state.copyWith(countryFlat: newSelectedCountry));
  }

  Future<void> _onLanguageSelected(
      SelectLanguage event, Emitter<TextToSpeechState> emit) async {
    if (state.isPlaying) {
      await _audioPlayer.stop();
    }
    emit(state.copyWith(
      selectedLanguage: event.language,
      selectedCountry: '',
      countryFlat: "",
      isPlaying: false,
      currentPosition: Duration.zero,
    ));
  }

  
  Future<void> _onSpeak(Speak event, Emitter<TextToSpeechState> emit) async {
    if (state.normarlText.isEmpty) return;

    emit(state.copyWith(isLoading: true, isPaused: false));

    try {
      final textToSpeak = state.editText.isNotEmpty
          ? state.editText
          : state.summarizedText.isEmpty
              ? state.normarlText
              : state.summarizedText;

      final textHash = TTSAudioStorageHelper.generateTextHash(
        textToSpeak,
        speechRate: state.speechRate,
        voiceName: state.selectedVoice?.name,
        pitch: state.setPitch,
        volume: state.setValume,
      );

      final existingRecording =
          await TTSAudioStorageHelper.findExistingRecording(
        text: textToSpeak,
        speechRate: state.speechRate,
        voiceName: state.selectedVoice?.name,
        pitch: state.setPitch,
        volume: state.setValume,
      );

      if (existingRecording != null) {
        await _playExistingRecording(
            existingRecording, textToSpeak, event.startFrom, emit);
        return;
      }

      await _processAndStoreNewRecording(textToSpeak, event.startFrom, emit);
    } catch (e) {
      print('Error in _onSpeak: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Error generating speech: $e',
      ));
    }
  }

  Future<void> _playExistingRecording(Map<String, dynamic> recording,
      String text, Duration startFrom, Emitter<TextToSpeechState> emit) async {
    final audioFile = File(recording['filePath']);
    await _audioPlayer.setFilePath(audioFile.path);

    final actualDuration = await _audioPlayer.duration ?? Duration.zero;
    final wordStartTimes = _calculateWordTimings(text, actualDuration);
    final initialWordIndex = startFrom == Duration.zero
        ? 0
        : _findWordIndexForTime(startFrom, wordStartTimes);

    if (startFrom > Duration.zero) {
      await _audioPlayer.seek(startFrom);
    }

    emit(state.copyWith(
      isPlaying: true,
      isLoading: false,
      originalAudioDuration: actualDuration,
      wordStartTimes: wordStartTimes,
      currentWordIndex: initialWordIndex,
      currentPosition: startFrom,
    ));

    await _audioPlayer.play();
    _startProgressTimer();
  }

  Future<void> _processAndStoreNewRecording(
      String text, Duration startFrom, Emitter<TextToSpeechState> emit) async {
    const int maxChunkSize = 4000;
    final chunks = _splitTextIntoChunks(text, maxChunkSize);
    List<Uint8List> audioChunks = [];

    for (int i = 0; i < chunks.length; i++) {
      emit(state.copyWith(loadingProgress: i / chunks.length));

      final chunk = chunks[i];
      final audioBytes = await _generateAudioForChunk(chunk, emit);
      audioChunks.add(audioBytes);
    }

    final combinedAudio = await _combineAndSaveAudio(text, audioChunks);
    await _playAndSetupAudio(combinedAudio, text, startFrom, emit);
  }

  Future<void> _playAndSetupAudio(File audioFile, String text,
      Duration startFrom, Emitter<TextToSpeechState> emit) async {
    await _audioPlayer.setFilePath(audioFile.path);
    final actualDuration = await _audioPlayer.duration ?? Duration.zero;
    final wordStartTimes = _calculateWordTimings(text, actualDuration);
    final initialWordIndex = startFrom == Duration.zero
        ? 0
        : _findWordIndexForTime(startFrom, wordStartTimes);

    if (startFrom > Duration.zero) {
      await _audioPlayer.seek(startFrom);
    }

    emit(state.copyWith(
      isPlaying: true,
      isLoading: false,
      originalAudioDuration: actualDuration,
      wordStartTimes: wordStartTimes,
      currentWordIndex: initialWordIndex,
      currentPosition: startFrom,
    ));

    await _audioPlayer.play();
    _startProgressTimer();
  }

  Future<Uint8List> _generateAudioForChunk(
      String text, Emitter<TextToSpeechState> emit) async {
    final ttsRequest = TTSRequest(
      input: TextInput(text: text),
      voice: VoiceSelectionParams(
        languageCode: state.selectedVoice?.languageCodes.first ?? 'en-US',
        name: state.selectedVoice?.name ?? 'en-US-Standard-A',
      ),
      audioConfig: AudioConfig(
        audioEncoding: 'MP3',
        speakingRate: state.speechRate,
        pitch: state.setPitch,
        volumeGainDb:
            state.setValume != null ? (state.setValume * 20) - 10 : null,
      ),
    );

    final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
    return base64Decode(audioContent);
  }

  Future<File> _combineAndSaveAudio(
      String text, List<Uint8List> audioChunks) async {
    final BytesBuilder builder = BytesBuilder();
    for (var chunk in audioChunks) {
      builder.add(chunk);
    }
    final combinedBytes = builder.takeBytes();

    await TTSAudioStorageHelper.saveAudioRecording(
      text: text,
      audioBytes: combinedBytes,
      textHash: TTSAudioStorageHelper.generateTextHash(
        text,
        speechRate: state.speechRate,
        voiceName: state.selectedVoice?.name,
        pitch: state.setPitch,
        volume: state.setValume,
      ),
      speechRate: state.speechRate,
      voiceName: state.selectedVoice?.name,
      pitch: state.setPitch,
      volume: state.setValume,
    );

    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
        '${tempDir.path}/combined_audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
    await tempFile.writeAsBytes(combinedBytes);
    return tempFile;
  }

  Future<(Uint8List, List<Duration>)> _processChunk(String chunkText,
      int chunkIndex, int totalChunks, Emitter<TextToSpeechState> emit) async {
    final ttsRequest = TTSRequest(
      input: TextInput(text: chunkText),
      voice: VoiceSelectionParams(
        languageCode: state.selectedVoice?.languageCodes.first ?? 'en-US',
        name: state.selectedVoice?.name ?? 'en-US-Standard-A',
      ),
      audioConfig: AudioConfig(
        audioEncoding: 'MP3',
        speakingRate: state.speechRate,
        pitch: state.setPitch,
        volumeGainDb:
            state.setValume != null ? (state.setValume * 20) - 10 : null,
      ),
    );

    try {
      final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
      final audioBytes = base64Decode(audioContent);

      final tempDir = await getTemporaryDirectory();
      final tempChunkFile = File(
          '${tempDir.path}/tts_chunk_${chunkIndex}_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempChunkFile.writeAsBytes(audioBytes);

      final chunkPlayer = AudioPlayer();
      await chunkPlayer.setFilePath(tempChunkFile.path);
      Duration chunkDuration = await chunkPlayer.duration ?? Duration.zero;
      await chunkPlayer.dispose();
      await tempChunkFile.delete();

      List<Duration> chunkWordTimings =
          _calculateWordTimings(chunkText, chunkDuration);

      // Update progress
      emit(state.copyWith(
        loadingProgress: (chunkIndex + 1) / totalChunks,
        isLoading: true,
      ));

      return (audioBytes, chunkWordTimings);
    } catch (e) {
      print('Error processing chunk $chunkIndex: $e');
      throw Exception('Error processing chunk $chunkIndex: $e');
    }
  }


  List<String> _splitTextIntoChunks(String text, int maxChunkSize) {
    List<String> chunks = [];
    List<String> sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    String currentChunk = '';

    for (String sentence in sentences) {
      if ((currentChunk + sentence).length <= maxChunkSize) {
        currentChunk += sentence + ' ';
      } else {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk.trim());
          currentChunk = sentence + ' ';
        } else {
          
          chunks.add(sentence.trim());
        }
      }
    }

    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk.trim());
    }

    return chunks;
  }

  void _onFontSelected(SelectFont event, Emitter<TextToSpeechState> emit) {
    emit(state.copyWith(selectedFont: event.fontName));
  }

  List<Duration> _calculateWordTimings(String text, Duration totalDuration) {
    List<String> words = text.split(' ');
    int totalCharacters = text.replaceAll(' ', '').length;

    // Calculate milliseconds per character based on total duration
    double msPerCharacter = totalDuration.inMilliseconds / totalCharacters;

    List<Duration> startTimes = [Duration.zero];
    Duration cumulativeDuration = Duration.zero;

    for (String word in words) {
      // Add the word duration based on its length
      cumulativeDuration += Duration(
        milliseconds: (word.length * msPerCharacter).round(),
      );
      startTimes.add(cumulativeDuration);
    }

    return startTimes;
  }

  int _findWordIndexForTime(
      Duration elapsedTime, List<Duration> wordStartTimes) {
    if (wordStartTimes.isEmpty) return 0;

    for (int i = 0; i < wordStartTimes.length - 1; i++) {
      if (elapsedTime >= wordStartTimes[i] &&
          elapsedTime < wordStartTimes[i + 1]) {
        return i;
      }
    }

    return math.min(wordStartTimes.length - 1, state.currentWordIndex);
  }

  void _onInitializeWordKeys(
      InitializeWordKeys event, Emitter<TextToSpeechState> emit) {
    final List<GlobalKey> wordKeys =
        event.text.split(' ').map((_) => GlobalKey()).toList();
    emit(state.copyWith(wordKeys: wordKeys, text: event.text));
  }

  Future<void> _speakCurrentChunk({int startWordIndex = 0}) async {
    if (_currentChunkIndex >= _textChunks.length) return;

    String chunk = _textChunks[_currentChunkIndex];
    List<String> words = chunk.split(' ');

    startWordIndex = startWordIndex.clamp(0, words.length - 1);

    String adjustedChunk = words.sublist(startWordIndex).join(' ');

    final ttsRequest = TTSRequest(
      input: TextInput(text: adjustedChunk),
      voice: VoiceSelectionParams(
        languageCode: state.selectedVoice?.languageCodes.first ?? 'en-US',
        name: state.selectedVoice?.name ?? 'en-US-Standard-A',
      ),
      audioConfig: AudioConfig(
        audioEncoding: 'MP3',
        speakingRate: state.speechRate,
        pitch: state.setPitch,
        volumeGainDb:
            state.setValume != null ? (state.setValume * 20) - 10 : null,
      ),
    );
    try {
      final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
      final audioBytes = base64Decode(audioContent);

      // Play the audio
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/tts_chunk_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempFile.writeAsBytes(audioBytes);
      await _audioPlayer.setFilePath(tempFile.path);

      int globalWordIndexStart = 0;
      for (int i = 0; i < _currentChunkIndex; i++) {
        globalWordIndexStart += _textChunks[i].split(' ').length;
      }

      await _audioPlayer.seek(state.currentPosition);
      await _audioPlayer.play();

      _audioPlayer.playerStateStream.listen((playerState) async {
        if (playerState.processingState == ProcessingState.completed) {
          await tempFile.delete();
          if (_currentChunkIndex < _textChunks.length - 1) {
            _currentChunkIndex++;
            await Future.delayed(const Duration(milliseconds: 100));
            await _speakCurrentChunk();
          } else {
            add(Stop());
          }
        }
      });
    } catch (e) {
      print('Error in _speakCurrentChunk: $e');
      add(Stop());
    }
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _updateHighlightedWord(_audioPlayer.position);

    _progressTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      if (!state.isPlaying) {
        timer.cancel();
        return;
      }

      final currentPosition = _audioPlayer.position;
      final duration = await _audioPlayer.duration ?? Duration.zero;

      if (duration.inMilliseconds > 0) {
        final progress =
            currentPosition.inMilliseconds / duration.inMilliseconds;

        emit(state.copyWith(
          currentPosition: currentPosition,
          loadingProgress: progress,
        ));

        _updateHighlightedWord(currentPosition);
        if (context != null) {
          scrollToHighlightedWord(context!, state.currentWordIndex);
        }
      }

      if (currentPosition >= state.originalAudioDuration) {
        add(Stop());
        timer.cancel();
      }
    });
  }

  Duration _estimateTotalDuration() {
    return _calculateWordTimings(
            state.summarizedText.isEmpty
                ? state.normarlText
                : state.summarizedText,
            state.currentPosition)
        .fold(
      Duration.zero,
      (total, duration) => total + duration,
    );
  }

  int _calculateStartChunk(Duration? position) {
    if (position == null) return 0;

    Duration cumulativeDuration = Duration.zero;
    for (int i = 0; i < _textChunks.length; i++) {
      Duration chunkDuration =
          _calculateWordTimings(_textChunks[i], state.currentPosition)
              .fold(Duration.zero, (total, duration) => total + duration);
      cumulativeDuration += chunkDuration;
      if (position < cumulativeDuration) {
        return i;
      }
    }
    return _textChunks.length - 1;
  }

  void _onSliderValueChanged(
      PitchValueChange event, Emitter<TextToSpeechState> emit) async {
    final textToSpeak =
        state.summarizedText.isEmpty ? state.normarlText : state.summarizedText;

    final wasPlaying = state.isPlaying;
    final currentPosition = state.currentPosition;

    try {
      await _audioPlayer.setPitch(event.value);

      emit(state.copyWith(
        setPitch: event.value,
        isPlaying: wasPlaying,
        isPaused: !wasPlaying,
      ));

      if (wasPlaying) {
        _progressTimer?.cancel();
        _startProgressTimer();
      }
    } catch (e) {
      print('Direct pitch change failed: $e');

      emit(state.copyWith(
        setPitch: event.value,
        isPlaying: false,
        isPaused: true,
      ));

      add(Speak(startFrom: currentPosition));
    }
  }

// change volume
  void _onSlidersetVolumeValueChange(
      setVolumeValueChange event, Emitter<TextToSpeechState> emit) async {
    await _audioPlayer.stop();
    _progressTimer?.cancel();

    emit(state.copyWith(
      isPlaying: false,
      isPaused: false,
    ));
    emit(state.copyWith(setValume: event.volumeValue));
  }

// increase text size
  void _onIncreaseTextSize(
      IncreaseTextSize event, Emitter<TextToSpeechState> emit) async {
    await _audioPlayer.stop();
    _progressTimer?.cancel();
    emit(state.copyWith(textSize: state.textSize + 1));
    emit(state.copyWith(
      isPlaying: false,
      isPaused: false,
    ));
  }

// decrease text size
  void _onDecreaseTextSize(
      DecreaseTextSize event, Emitter<TextToSpeechState> emit) async {
    await _audioPlayer.stop();
    _progressTimer?.cancel();
    emit(state.copyWith(textSize: state.textSize - 1));
    emit(state.copyWith(
      isPlaying: false,
      isPaused: false,
    ));
  }

  Future<void> _onPause(Pause event, Emitter<TextToSpeechState> emit) async {
    await _audioPlayer.pause();
    final position = _audioPlayer.position;
    emit(state.copyWith(
      isPlaying: false,
      isPaused: true,
      currentPosition: position,
    ));
    _progressTimer?.cancel();
    _updateHighlightedWord(position);
  }

  void _onTogglePlayPause(
      TogglePlayPause event, Emitter<TextToSpeechState> emit) async {
    if (state.isPlaying) {
      add(Pause());
    } else {
      if (state.isPaused) {
        emit(state.copyWith(isPlaying: true, isPaused: false));
        await _audioPlayer.seek(state.currentPosition);
        await _audioPlayer.play();
        _startProgressTimer();
      } else {
        add(Speak());
      }
    }
  }

  void _onToggleChangeColor(
      ChangeColorToggle event, Emitter<TextToSpeechState> emit) {
    if (state.isChangeColor) {
      emit(state.copyWith(isChangeColor: !state.isChangeColor));
    } else {
      emit(state.copyWith(isChangeColor: !state.isChangeColor));
    }
  }

  void _onHideShowPlayerToggle(
      HideShowPlayerToggle event, Emitter<TextToSpeechState> emit) {
    emit(state.copyWith(
        isSwitchedToHideShowPlayer: !state.isSwitchedToHideShowPlayer));
  }

  void _onTouchScreenEvent(
      ScreenTouched event, Emitter<TextToSpeechState> emit) {
    emit(state.copyWith(isSwitchedToHideShowPlayer: false));
  }

  void _onReset(Reset event, Emitter<TextToSpeechState> emit) {
    emit(TextToSpeechState.initial());
    _progressTimer?.cancel();
    _audioPlayer.stop();
  }

  void _onChangeSpeechRate(
      ChangeSpeechRate event, Emitter<TextToSpeechState> emit) async {
    final newSpeechRate = event.rate;

    final textToSpeak =
        state.summarizedText.isEmpty ? state.normarlText : state.summarizedText;

    final wasPlaying = state.isPlaying;
    final currentPosition = state.currentPosition;

    await _audioPlayer.setSpeed(newSpeechRate);

    final adjustedDuration = state.originalAudioDuration * (1 / newSpeechRate);
    final wordStartTimes = _calculateWordTimings(textToSpeak, adjustedDuration);

    emit(state.copyWith(
      speechRate: newSpeechRate,
      originalAudioDuration: adjustedDuration,
      wordStartTimes: wordStartTimes,
      currentPosition: currentPosition,
      isPlaying: state.isPlaying,
      isPaused: state.isPaused,
    ));

    if (state.isPlaying) {
      _progressTimer?.cancel();
      _startProgressTimer();
    }
  }

  void _onSeekBy(SeekBy event, Emitter<TextToSpeechState> emit) async {
    final Duration newPosition = _clampDuration(
      state.currentPosition + event.offset,
      Duration.zero,
      state.originalAudioDuration,
    );

    final bool wasPlaying = state.isPlaying;

    emit(state.copyWith(
      currentPosition: newPosition,
      currentWordIndex:
          _findWordIndexForTime(newPosition, state.wordStartTimes),
    ));

    await _audioPlayer.seek(newPosition);

    if (wasPlaying) {
      await _audioPlayer.play();

      _startProgressTimer();
    }

    if (context != null) {
      scrollToHighlightedWord(context!, state.currentWordIndex);
    }
  }

  void _synchronizeHighlight(Duration currentPosition) {
    int newWordIndex =
        _findWordIndexForTime(currentPosition, state.wordTimings);
    if (newWordIndex != state.currentWordIndex) {
      emit(state.copyWith(currentWordIndex: newWordIndex));
      scrollToHighlightedWord(context!, newWordIndex);
    }
  }

  Future<void> _onSeekTo(SeekTo event, Emitter<TextToSpeechState> emit) async {
    try {
      Duration newPosition = _clampDuration(
        event.position,
        Duration.zero,
        state.originalAudioDuration,
      );

      int newWordIndex =
          _findWordIndexForTime(newPosition, state.wordStartTimes);
      bool wasPlaying = state.isPlaying;

      // if (wasPlaying) {
      //   await _audioPlayer.pause();
      // }

      emit(state.copyWith(
        currentPosition: newPosition,
        currentWordIndex: newWordIndex,
        isPlaying: true,
        isPaused: false,
      ));

      await _audioPlayer.seek(newPosition);

      if (context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToHighlightedWord(context!, newWordIndex, forceScroll: true);
        });
      }

      if (wasPlaying) {
        await _audioPlayer.play();
        emit(state.copyWith(
          isPlaying: true,
          isPaused: false,
        ));
        _startProgressTimer();
      }
    } catch (e) {
      print('Error in _onSeekTo: $e');
    }
  }

  Duration _clampDuration(Duration value, Duration min, Duration max) {
    if (value.compareTo(min) < 0) return min;
    if (value.compareTo(max) > 0) return max;
    return value;
  }

  int _getGlobalWordIndex(int localIndex) {
    int globalIndex = 0;
    for (int i = 0; i < _currentChunkIndex; i++) {
      globalIndex += _textChunks[i].split(' ').length;
    }
    return globalIndex + localIndex;
  }

  Future<void> _onStop(Stop event, Emitter<TextToSpeechState> emit) async {
    await _audioPlayer.stop();
    emit(state.copyWith(
      isPlaying: false,
      currentPosition: Duration.zero,
    ));
    _progressTimer?.cancel();
  }

  Duration _estimateDuration(String text, double speechRate) {
    const double baseWordsPerMinute = 150.0;

    final String cleanText = text.trim();
    if (cleanText.isEmpty) return Duration.zero;

    final List<String> words = cleanText.split(RegExp(r'\s+'));
    final int wordCount = words.length;

    final double adjustedWordsPerMinute = baseWordsPerMinute * speechRate;
    final double minutes = wordCount / adjustedWordsPerMinute;
    final int milliseconds = (minutes * 60 * 850).round();

    final int minDuration = 850;

    return Duration(milliseconds: math.max(milliseconds, minDuration));
  }

  int _findWordIndexAtPosition(Duration position) {
    Duration cumulativeDuration = Duration.zero;
    for (int i = 0; i < state.wordTimings.length; i++) {
      cumulativeDuration += state.wordTimings[i];
      if (position < cumulativeDuration) {
        return i;
      }
    }
    return state.wordTimings.length - 1;
  }

  Widget buildHighlightedTextSpans(
      BuildContext context, String text, int currentWordIndex) {
    if (text.isEmpty || state.wordKeys.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> chunks = text.split(RegExp(r'(?<=[.!?])\s+'));
    final int totalWordCount =
        chunks.fold(0, (sum, chunk) => sum + chunk.split(' ').length);
    final safeWordIndex = currentWordIndex.clamp(0, totalWordCount - 1);

    int currentChunkIndex = 0;
    int wordCount = 0;
    for (int i = 0; i < chunks.length; i++) {
      wordCount += chunks[i].split(' ').length;
      if (safeWordIndex < wordCount) {
        currentChunkIndex = i;
        break;
      }
    }

    return SingleChildScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: chunks.asMap().entries.map((entry) {
            final int index = entry.key;
            final String chunk = entry.value;
            final bool isHighlighted = index == currentChunkIndex;

            final List<String> chunkWords = chunk.split('/n');
            final int startWordIndex = chunks
                .take(index)
                .map((c) => c.split(' ').length)
                .fold(0, (sum, length) => sum + length);

            if (startWordIndex >= state.wordKeys.length) {
              return const SizedBox.shrink();
            }

            return Container(
              key: state.wordKeys[startWordIndex],
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: isHighlighted && !state.isChangeColor
                    ? Colors.blue.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => add(WordSelected(startWordIndex)),
                child: RichText(
                  text: TextSpan(
                    children: chunkWords.asMap().entries.map((wordEntry) {
                      final int wordIndex = startWordIndex + wordEntry.key;
                      if (wordIndex >= totalWordCount) return const TextSpan();

                      final String word = wordEntry.value;
                      final bool isCurrentWord = wordIndex == safeWordIndex;

                      return TextSpan(
                        text: wordEntry.key < chunkWords.length - 1
                            ? '$word '
                            : word,
                        style: TextStyle(
                          fontFamily: state.selectedFont,
                          fontSize: state.textSize.toDouble(),
                          color: state.isChangeColor
                              ? Colors.white
                              : isCurrentWord
                                  ? Colors.blue
                                  : Colors.black,
                          fontWeight: isCurrentWord
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _addSpaceAfterWord(String word) {
    if (word.endsWith('.') ||
        word.endsWith(',') ||
        word.endsWith('!') ||
        word.endsWith('?') ||
        word.endsWith(':') ||
        word.endsWith(';')) {
      return word + '';
    }
    return word + '';
  }

  void scrollToHighlightedWord(BuildContext context, int wordIndex,
      {bool forceScroll = false}) {
    if (state.wordKeys.isEmpty) return;

    final chunks = state.summarizedText.isEmpty
        ? state.normarlText.split(RegExp(r'(?<=[.!?])\s+'))
        : state.summarizedText.split(RegExp(r'(?<=[.!?])\s+'));

    int currentChunk = 0;
    int wordCount = 0;

    for (int i = 0; i < chunks.length; i++) {
      wordCount += chunks[i].split(' ').length;
      if (wordIndex < wordCount) {
        currentChunk = i;
        break;
      }
    }

    final startWordIndex = chunks
        .take(currentChunk)
        .map((c) => c.split(' ').length)
        .fold(0, (sum, length) => sum + length);

    final key = state.wordKeys[startWordIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (key.currentContext != null &&
          (state.isPlaying || forceScroll || !allowManualScroll)) {
        final RenderBox renderBox =
            key.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;
        final visibleRange = 150.0;

        bool isChunkOutOfView = position.dy < visibleRange ||
            position.dy > screenHeight - visibleRange;

        if (isChunkOutOfView || state.currentWordIndex == 0 || forceScroll) {
          Scrollable.ensureVisible(
            key.currentContext!,
            alignment: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> _onRequestStoragePermission(
      RequestStoragePermission event, Emitter<TextToSpeechState> emit) async {}

  Future<void> _onFetchVoices(
      FetchVoicesEvent event, Emitter<TextToSpeechState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final voices = await _ttsRepo.fetchVoices();
      emit(state.copyWith(
        availableVoices: voices,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Error fetching voices: $e',
      ));
      print('Error fetching voices: $e');
    }
  }

  void _onSelectVoice(
      SelectVoiceEvent event, Emitter<TextToSpeechState> emit) async {
    final currentPosition = _audioPlayer.position;
    final wasPlaying = state.isPlaying;
    final textToSpeak =
        state.summarizedText.isEmpty ? state.normarlText : state.summarizedText;

    if (textToSpeak.isEmpty) return;

    try {
      // Stop current playback
      if (wasPlaying) {
        await _audioPlayer.pause();
      }

      emit(state.copyWith(
        selectedVoice: event.voice,
        languageCode: event.voice.languageCodes.first,
        isLoading: true,
        isPlaying: false,
        isPaused: true,
      ));

      const maxChunkLength = 4000;
      List<String> textChunks = [];

      if (textToSpeak.length > maxChunkLength) {
        int startIndex = 0;
        while (startIndex < textToSpeak.length) {
          int endIndex =
              math.min(startIndex + maxChunkLength, textToSpeak.length);
          textChunks.add(textToSpeak.substring(startIndex, endIndex));
          startIndex += maxChunkLength;
        }
      } else {
        textChunks = [textToSpeak];
      }

      List<Uint8List> audioChunks = [];
      double totalProgress = 0;

      for (int i = 0; i < textChunks.length; i++) {
        final chunk = textChunks[i];
        final ttsRequest = TTSRequest(
          input: TextInput(text: chunk),
          voice: VoiceSelectionParams(
            languageCode: event.voice.languageCodes.first,
            name: event.voice.name,
          ),
          audioConfig: AudioConfig(
            audioEncoding: 'MP3',
            speakingRate: state.speechRate,
            pitch: state.setPitch,
            volumeGainDb:
                state.setValume != null ? (state.setValume * 20) - 10 : null,
          ),
        );

        final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
        final audioBytes = base64Decode(audioContent);
        audioChunks.add(audioBytes);

        totalProgress = (i + 1) / textChunks.length;
        emit(state.copyWith(loadingProgress: totalProgress));
      }

      final BytesBuilder builder = BytesBuilder();
      for (var chunk in audioChunks) {
        builder.add(chunk);
      }
      final combinedAudioBytes = builder.takeBytes();

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/voice_change_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempFile.writeAsBytes(combinedAudioBytes);

      await _audioPlayer.setFilePath(tempFile.path);
      final actualDuration = await _audioPlayer.duration ?? Duration.zero;

      final currentProgress = currentPosition.inMilliseconds /
          (state.originalAudioDuration.inMilliseconds == 0
              ? 1
              : state.originalAudioDuration.inMilliseconds);

      final newPosition = Duration(
          milliseconds:
              (actualDuration.inMilliseconds * currentProgress).round());
      final wordStartTimes = _calculateWordTimings(textToSpeak, actualDuration);

      await _audioPlayer.setSpeed(state.speechRate);

      if (newPosition > Duration.zero) {
        await _audioPlayer.seek(newPosition);
      }

      emit(state.copyWith(
        originalAudioDuration: actualDuration,
        wordStartTimes: wordStartTimes,
        currentPosition: newPosition,
        isLoading: false,
        isPlaying: wasPlaying,
        isPaused: !wasPlaying,
      ));

      if (wasPlaying) {
        await _audioPlayer.play();
        _startProgressTimer();
      }

      await TTSAudioStorageHelper.saveAudioRecording(
        text: textToSpeak,
        audioBytes: combinedAudioBytes,
        textHash: TTSAudioStorageHelper.generateTextHash(
          textToSpeak,
          speechRate: state.speechRate,
          voiceName: event.voice.name,
          pitch: state.setPitch,
          volume: state.setValume,
        ),
        speechRate: state.speechRate,
        voiceName: event.voice.name,
        pitch: state.setPitch,
        volume: state.setValume,
      );
    } catch (e) {
      print('Error switching voice: $e');
      emit(state.copyWith(
        isLoading: false,
        isPlaying: false,
        isPaused: true,
        error: 'Error switching voice: $e',
      ));
    }
  }

  Future<void> generateAndCacheAudio(
    String text,
    Voice voice,
    Duration currentPosition,
    Emitter<TextToSpeechState> emit,
  ) async {
    try {
      final ttsRequest = TTSRequest(
        input: TextInput(text: text),
        voice: VoiceSelectionParams(
          languageCode: voice.languageCodes.first,
          name: voice.name,
        ),
        audioConfig: AudioConfig(
          audioEncoding: 'MP3',
          speakingRate: state.speechRate,
          pitch: state.setPitch,
          volumeGainDb:
              state.setValume != null ? (state.setValume * 20) - 10 : null,
        ),
      );

      final audioContent = await _ttsRepo.textToSpeech(ttsRequest);
      final audioBytes = base64Decode(audioContent);

      await TTSAudioStorageHelper.saveAudioRecording(
        text: text,
        audioBytes: audioBytes,
        textHash: TTSAudioStorageHelper.generateTextHash(
          text,
          speechRate: state.speechRate,
          voiceName: voice.name,
          pitch: state.setPitch,
          volume: state.setValume,
        ),
        speechRate: state.speechRate,
        voiceName: voice.name,
        pitch: state.setPitch,
        volume: state.setValume,
      );

      if (state.isPlaying) {
        final existingRecording =
            await TTSAudioStorageHelper.findExistingRecording(
          text: text,
          speechRate: state.speechRate,
          voiceName: voice.name,
          pitch: state.setPitch,
          volume: state.setValume,
        );

        if (existingRecording != null) {
          final audioFile = File(existingRecording['filePath']);
          final currentPlaybackPosition = _audioPlayer.position;

          await _audioPlayer.setAudioSource(AudioSource.file(audioFile.path),
              initialPosition: currentPlaybackPosition);

          Duration actualDuration =
              await _audioPlayer.duration ?? Duration.zero;
          List<Duration> wordStartTimes =
              TTSAudioStorageHelper.calculateWordTimings(text, actualDuration);

          emit(state.copyWith(
            originalAudioDuration: actualDuration,
            wordStartTimes: wordStartTimes,
            isPlaying: true,
          ));

          await _audioPlayer.seek(currentPlaybackPosition);
          await _audioPlayer.play();
          _startProgressTimer();
        }
      }
    } catch (e) {
      print('Error generating cached audio: $e');
    }
  }

  Future<void> clearAudioRecordings() async {
    await AudioStorageHelper.clearAllAudioRecordings();
  }

  void _onClearAudioRecordings(
      ClearAudioRecordingsEvent event, Emitter<TextToSpeechState> emit) async {
    await AudioStorageHelper.clearAllAudioRecordings();
  }

// Cleanup
  @override
  Future<void> close() {
    _audioPlayer.dispose();
    _progressTimer?.cancel();
    return super.close();
  }
}

class TextInput {
  final String text;

  TextInput({required this.text});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

class PermissionHandler {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) return true;

      var status = await Permission.storage.request();
      if (status.isGranted) return true;

      status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true;
  }
}
