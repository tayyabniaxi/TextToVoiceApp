// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/bottom-nav/bottom-nav-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/docsReader/docs-reader-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/gDrive/gDrive-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/imageReader/imgReader-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/link_reader/link_reader_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/note_paid/bloc/note_paid_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-bloc-class.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/statistic/statistic_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/subscription/subscription_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/repo/tts_repo.dart';
import 'package:new_wall_paper_app/utils/routes/route_name.dart';
import 'package:new_wall_paper_app/utils/routes/routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  final ttsRepo = TtsRepo();

  MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    final TrendingBloc trendingBloc = TrendingBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ImageReaderBloc>(
          create: (context) => ImageReaderBloc(),
        ),
        BlocProvider<DocsReaderBloc>(
          create: (context) => DocsReaderBloc(),
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
        ),
        BlocProvider<LinkReaderBloc>(
          create: (context) => LinkReaderBloc(),
        ),
        BlocProvider<PDFReaderBloc>(
          create: (context) => PDFReaderBloc(),
        ),
        BlocProvider<GmailBloc>(
          create: (context) => GmailBloc(),
        ),
        BlocProvider<StatisticBloc>(
          create: (context) => StatisticBloc(),
        ),
        BlocProvider<SubscriptionBloc>(
          create: (context) => SubscriptionBloc(),
        ),
        BlocProvider<BottomNavigationBloc>(
          create: (context) => BottomNavigationBloc(),
        ),
        BlocProvider<TextToSpeechBloc>(
            create: (context) => TextToSpeechBloc(ttsRepo: ttsRepo)),
        BlocProvider<DriveBloc>(create: (context) => DriveBloc()),
        BlocProvider<TrendingBloc>(create: (context) => TrendingBloc()),
        BlocProvider<NotesBloc>(
          create: (context) => NotesBloc()..add(LoadNotes()),
        ),
        BlocProvider<TrendingBloc>(
          create: (context) => trendingBloc..add(LoadTrendingData()),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Text To Voice',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isFirstLaunch
            ? RoutesName.onboardingScreen
            : RoutesName.bottomNavigationPage,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
