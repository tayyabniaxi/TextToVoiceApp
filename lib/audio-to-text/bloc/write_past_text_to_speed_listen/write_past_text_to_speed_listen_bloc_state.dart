// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/model/country_model.dart';
import 'package:new_wall_paper_app/model/tts_model.dart';

class TextToSpeechState extends Equatable {
  final List<String> openedPdfs;
  final List<String> key;
  String normarlText;
  final Duration originalAudioDuration;
  final Duration currentPosition;
  final bool isPlaying;
  final bool isPaused;
  final bool isLoading;
  final double speechRate;
  final int currentWordIndex;
  List<Duration> wordTimings;
  final List<Language> availableLanguages;
  final Language selectedLanguage;
  final String selectedCountry;
  final List<String> countryHistory;
  final bool isLanguageSelectOn;
  final bool ToggleSubCategory;
  String selectLang;
  String selectCountriesCode;
  final double setPitch;
  final double setValume;
  final List<String> languageHistory;
  final int textSize;
  final GlobalKey? highlightedWordKey;
  final int lastPausedWordIndex;
  final List<GlobalKey> wordKeys;
  final bool isUserScrolling;
  final int currentChunkIndex;
  String countryFlat;
  String languageCode;
  String countryCode;
  final String selectedFont;
  final String savedFilePath;
  final ThemeData themeData;
  final bool isChangeColor;
  final String summarizedText;
  final bool isPermissionGranted;
  final String? downloadedFilePath;
  final bool isSwitchedToHideShowPlayer;
  String editText;
  String error;
  final double processingProgress;
  final List<Voice> availableVoices;
  final Voice? selectedVoice;
  final String audioUrl;
  final bool isAudioLoaded;
  final bool isBuffering;
  final double conversionProgress;
  final int totalScheduledTime;
  final int totalPlayedTime;
  final double loadingProgress;
  final List<Duration> wordStartTimes;
  // final String summarizedText;
  final bool isSummarizing;
  final String summarizationError;
  final String? currentFileName;
  final bool isRenaming;
  final String? selectedAudioFormat;
  final bool isDownloadingFormat;
  int selectedSeconds;
  final TimeOfDay reminderTime;
  final double downloadProgress;
  final bool isDownloading;
  final String? currentDownloadFormat;
  final Map<String, dynamic>? currentSchedule;
  final bool remindMeToRead;
  final String goalPerDay;
  final int selectedDayIndex;
  final Duration? countdownRemaining;
  final bool isCountdownActive;
  final DateTime? countdownEndTime;
  final List<int> selectedDays;
  final bool isTimePickerActive;
  final Duration selectedDuration;
  final Duration elapsedTime;
  final TimerStatus timerStatus;
  final int selectedHour;
  final int selectedMinute;
  final int selectedSecond;
  final bool useDeviceTheme;
  final bool useLightTheme;
  final Timer? countdownTimer;
  final bool isDarkMode;

  TextToSpeechState(
      {required this.openedPdfs,
      required this.key,
      required this.wordKeys,
      this.highlightedWordKey,
      required this.normarlText,
      required this.originalAudioDuration,
      required this.currentPosition,
      required this.isPlaying,
      required this.isPaused,
      required this.isLoading,
      required this.speechRate,
      required this.currentWordIndex,
      required this.wordTimings,
      required this.availableLanguages,
      required this.selectedLanguage,
      required this.selectedCountry,
      required this.languageHistory,
      required this.countryHistory,
      required this.isLanguageSelectOn,
      required this.ToggleSubCategory,
      required this.selectLang,
      required this.setPitch,
      required this.setValume,
      required this.textSize,
      required this.lastPausedWordIndex,
      required this.selectCountriesCode,
      required this.isUserScrolling,
      required this.currentChunkIndex,
      required this.countryFlat,
      required this.languageCode,
      required this.countryCode,
      required this.selectedFont,
      required this.savedFilePath,
      this.isChangeColor = false,
      required this.themeData,
      this.isPermissionGranted = false,
      this.isSwitchedToHideShowPlayer = false,
      this.downloadedFilePath,
      this.summarizedText = '',
      this.editText = '',
      required this.totalScheduledTime,
      required this.totalPlayedTime,
      required this.availableVoices,
      this.selectedVoice,
      required this.audioUrl,
      required this.isAudioLoaded,
      required this.isBuffering,
      required this.error,
      required this.processingProgress,
      required this.conversionProgress,
      required this.loadingProgress,
      this.wordStartTimes = const [],
      this.currentFileName,
      this.isRenaming = false,
      this.selectedAudioFormat,
      this.isDownloadingFormat = false,
      this.isSummarizing = false,
      this.summarizationError = '',
      required this.reminderTime,
      required this.selectedSeconds,
      this.currentDownloadFormat = '',
      this.downloadProgress = 0.0,
      this.isDownloading = false,
      this.currentSchedule,
      this.goalPerDay = '1 Hour',
      this.selectedDayIndex = 3,
      this.remindMeToRead = false,
      this.selectedDays = const [],
      this.countdownRemaining,
      this.isCountdownActive = false,
      this.countdownEndTime,
      required this.isTimePickerActive,
      this.selectedDuration = Duration.zero,
      this.elapsedTime = Duration.zero,
      this.timerStatus = TimerStatus.initial,
      this.selectedHour = 0,
      this.selectedMinute = 0,
      this.useDeviceTheme = false,
      this.useLightTheme = false,
      this.selectedSecond = 0,
      this.isDarkMode = false,
      this.countdownTimer});

  factory TextToSpeechState.initial() {
    return TextToSpeechState(
        openedPdfs: [],
        key: [],
        wordKeys: [],
        highlightedWordKey: null,
        normarlText: '',
        originalAudioDuration: Duration.zero,
        currentPosition: Duration.zero,
        isPlaying: false,
        isPaused: false,
        isLoading: false,
        speechRate: 1.0,
        currentWordIndex: 0,
        wordTimings: [],
        availableLanguages: defaultLanguages,
        selectedLanguage: defaultLanguages.first,
        selectedCountry: '',
        languageHistory: [],
        countryHistory: [],
        isLanguageSelectOn: false,
        ToggleSubCategory: false,
        selectLang: "",
        setPitch: 1.0,
        setValume: 0.5,
        textSize: 16,
        lastPausedWordIndex: 0,
        currentChunkIndex: 0,
        isUserScrolling: false,
        countryFlat: '',
        selectCountriesCode: '',
        languageCode: '',
        countryCode: '',
        selectedFont: 'AvenirNextLTPro',
        savedFilePath: "",
        downloadedFilePath: "",
        summarizedText: "",
        editText: "",
        isChangeColor: false,
        isPermissionGranted: false,
        isSwitchedToHideShowPlayer: false,
        totalScheduledTime: 0,
        totalPlayedTime: 0,
        availableVoices: [],
        wordStartTimes: [],
        audioUrl: '',
        error: '',
        isAudioLoaded: false,
        currentFileName: '',
        isRenaming: false,
        isSummarizing: false,
        selectedAudioFormat: '',
        summarizationError: '',
        isDownloadingFormat: false,
        isBuffering: false,
        processingProgress: 0.0,
        conversionProgress: 0.0,
        loadingProgress: 0.0,
        selectedSeconds: 0,
        downloadProgress: 0.0,
        isDownloading: false,
        currentDownloadFormat: "",
        goalPerDay: '',
        currentSchedule: null,
        selectedDays: [],
        selectedDayIndex: 0,
        remindMeToRead: false,
        isTimePickerActive: false,
        useLightTheme: false,
        reminderTime: const TimeOfDay(hour: 10, minute: 0),
        selectedHour: 0,
        selectedMinute: 0,
        selectedSecond: 0,
        countdownTimer: null,
        // countdownTimer:
        themeData: ThemeData.light());
  }

  TextToSpeechState copyWith({
    List<String>? openedPdfs,
    List<String>? key,
    List<GlobalKey>? wordKeys,
    GlobalKey? highlightedWordKey,
    String? text,
    Duration? originalAudioDuration,
    Duration? currentPosition,
    bool? isPlaying,
    bool? isPaused,
    bool? isLoading,
    double? speechRate,
    int? currentWordIndex,
    List<Duration>? wordTimings,
    List<Language>? availableLanguages,
    Language? selectedLanguage,
    String? selectedCountry,
    List<String>? languageHistory,
    List<String>? countryHistory,
    bool? isLanguageSelectOn,
    bool? ToggleSubCategory,
    String? selectLang,
    double? setPitch,
    double? setValume,
    String? selectCountriesCode,
    int? textSize,
    int? lastPausedWordIndex,
    int? currentChunkIndex,
    bool? isUserScrolling,
    String? countryFlat,
    String? languageCode,
    String? countryCode,
    String? selectedFont,
    String? savedFilePath,
    bool? isChangeColor,
    ThemeData? themeData,
    bool? isPermissionGranted,
    bool? isSwitchedToHideShowPlayer,
    String? downloadedFilePath,
    String? summarizedText,
    String? editText,
    int? totalScheduledTime,
    int? totalPlayedTime,
    List<Voice>? availableVoices,
    Voice? selectedVoice,
    String? audioUrl,
    String? error,
    bool? isAudioLoaded,
    bool? isBuffering,
    double? processingProgress,
    double? conversionProgress,
    double? loadingProgress,
    List<Duration>? wordStartTimes,
    String? currentFileName,
    bool? isRenaming,
    String? selectedAudioFormat,
    bool? isDownloadingFormat,
    bool? isSummarizing,
    String? summarizationError,
    int? selectedSeconds,
    double? downloadProgress,
    bool? isDownloading,
    String? currentDownloadFormat,
    TimeOfDay? reminderTime,
    Map<String, dynamic>? currentSchedule,
    bool? remindMeToRead,
    String? goalPerDay,
    int? selectedDayIndex,
    List<int>? selectedDays,
    Duration? countdownRemaining,
    bool? isCountdownActive,
    DateTime? countdownEndTime,
    bool? isTimePickerActive,
    bool? showDialog,
    Duration? selectedDuration,
    Duration? elapsedTime,
    TimerStatus? timerStatus,
    int? selectedHour,
    int? selectedMinute,
    int? selectedSecond,
    Timer? countdownTimer,
    bool? useDeviceTheme,
    bool? useLightTheme,
    bool? isDarkMode,
  }) {
    return TextToSpeechState(
      openedPdfs: openedPdfs ?? this.openedPdfs,
      key: key ?? this.key,
      wordKeys: wordKeys ?? this.wordKeys,
      highlightedWordKey: highlightedWordKey ?? this.highlightedWordKey,
      normarlText: text ?? this.normarlText,
      originalAudioDuration:
          originalAudioDuration ?? this.originalAudioDuration,
      currentPosition: currentPosition ?? this.currentPosition,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isLoading: isLoading ?? this.isLoading,
      speechRate: speechRate ?? this.speechRate,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      wordTimings: wordTimings ?? this.wordTimings,
      availableLanguages: availableLanguages ?? this.availableLanguages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      languageHistory: languageHistory ?? this.languageHistory,
      countryHistory: countryHistory ?? this.countryHistory,
      isLanguageSelectOn: isLanguageSelectOn ?? this.isLanguageSelectOn,
      ToggleSubCategory: ToggleSubCategory ?? this.ToggleSubCategory,
      selectLang: selectLang ?? this.selectLang,
      setPitch: setPitch ?? this.setPitch,
      setValume: setValume ?? this.setValume,
      textSize: textSize ?? this.textSize,
      lastPausedWordIndex: lastPausedWordIndex ?? this.lastPausedWordIndex,
      currentChunkIndex: currentChunkIndex ?? this.currentChunkIndex,
      selectCountriesCode: selectCountriesCode ?? this.selectCountriesCode,
      isUserScrolling: isUserScrolling ?? this.isUserScrolling,
      countryFlat: countryFlat ?? this.countryFlat,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
      selectedFont: selectedFont ?? this.selectedFont,
      savedFilePath: savedFilePath ?? this.savedFilePath,
      themeData: themeData ?? this.themeData,
      isChangeColor: isChangeColor ?? this.isChangeColor,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      summarizedText: summarizedText ?? this.summarizedText,
      editText: editText ?? this.editText,
      isSwitchedToHideShowPlayer:
          isSwitchedToHideShowPlayer ?? this.isSwitchedToHideShowPlayer,
      totalScheduledTime: totalScheduledTime ?? this.totalScheduledTime,
      totalPlayedTime: totalPlayedTime ?? this.totalPlayedTime,
      availableVoices: availableVoices ?? this.availableVoices,
      selectedVoice: selectedVoice ?? this.selectedVoice,
      audioUrl: audioUrl ?? this.audioUrl,
      isAudioLoaded: isAudioLoaded ?? this.isAudioLoaded,
      isBuffering: isBuffering ?? this.isBuffering,
      error: error ?? this.error,
      processingProgress: processingProgress ?? this.processingProgress,
      conversionProgress: conversionProgress ?? this.conversionProgress,
      loadingProgress: loadingProgress ?? this.loadingProgress,
      wordStartTimes: wordStartTimes ?? this.wordStartTimes,
      currentFileName: currentFileName ?? this.currentFileName,
      isRenaming: isRenaming ?? this.isRenaming,
      selectedAudioFormat: selectedAudioFormat ?? this.selectedAudioFormat,
      isDownloadingFormat: isDownloadingFormat ?? this.isDownloadingFormat,
      isSummarizing: isSummarizing ?? this.isSummarizing,
      summarizationError: summarizationError ?? this.summarizationError,
      reminderTime: reminderTime ?? this.reminderTime,
      selectedSeconds: selectedSeconds ?? this.selectedSeconds,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isDownloading: isDownloading ?? this.isDownloading,
      currentDownloadFormat:
          currentDownloadFormat ?? this.currentDownloadFormat,
      currentSchedule: currentSchedule ?? this.currentSchedule,
      remindMeToRead: remindMeToRead ?? this.remindMeToRead,
      goalPerDay: goalPerDay ?? this.goalPerDay,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      selectedDays: selectedDays ?? this.selectedDays,
      countdownRemaining: countdownRemaining ?? this.countdownRemaining,
      isCountdownActive: isCountdownActive ?? this.isCountdownActive,
      countdownEndTime: countdownEndTime ?? this.countdownEndTime,
      isTimePickerActive: isTimePickerActive ?? this.isTimePickerActive,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      timerStatus: timerStatus ?? this.timerStatus,
      selectedHour: selectedHour ?? this.selectedHour,
      selectedMinute: selectedMinute ?? this.selectedMinute,
      selectedSecond: selectedSecond ?? this.selectedSecond,
      countdownTimer: countdownTimer ?? this.countdownTimer,
      useDeviceTheme: useDeviceTheme ?? this.useDeviceTheme,
      useLightTheme: useLightTheme ?? this.useLightTheme,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [
        key,
        openedPdfs,
        wordKeys,
        highlightedWordKey,
        normarlText,
        originalAudioDuration,
        currentPosition,
        isPlaying,
        isPaused,
        isLoading,
        speechRate,
        currentWordIndex,
        wordTimings,
        availableLanguages,
        selectedLanguage,
        selectedCountry,
        countryHistory,
        isLanguageSelectOn,
        ToggleSubCategory,
        selectLang,
        selectCountriesCode,
        setPitch,
        setValume,
        languageHistory,
        textSize,
        isUserScrolling,
        currentChunkIndex,
        countryFlat,
        selectedFont,
        savedFilePath,
        themeData,
        isChangeColor,
        isPermissionGranted,
        isSwitchedToHideShowPlayer,
        editText,
        availableVoices,
        selectedVoice,
        audioUrl,
        isAudioLoaded,
        isBuffering,
        error,
        conversionProgress,
        loadingProgress,
        currentSchedule,
        remindMeToRead,
        goalPerDay,
        selectedDayIndex,
        selectedDays,
        selectedHour,
        selectedMinute,
        selectedSecond,
      ];
}

enum TimerStatus { initial, running, paused, completed }
