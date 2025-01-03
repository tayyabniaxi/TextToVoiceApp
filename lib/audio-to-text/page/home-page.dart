// ignore_for_file: sized_box_for_whitespace, use_key_in_widget_constructors, non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-state.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/bloc/top_trend_bloc_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/bloc/top_trend_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_event.dart';
import 'package:new_wall_paper_app/component/dialog_widget.dart';
import 'package:new_wall_paper_app/component/home_widget/ImportAndListenGridView_widget.dart';
import 'package:new_wall_paper_app/component/home_widget/home_rowContent_widget.dart';
import 'package:new_wall_paper_app/component/home_widget/top_tend_widget.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/utils/utils%20copy.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final urlControler = TextEditingController();
  DateTime? lastPressedTime;
  @override
  Widget build(BuildContext context) {
    context.read<HomePageBloc>().add(LoadItemsEvent(''));
    final bloc = context.read<HomePageBloc>();
    final TrendingBloc trendingBloc = TrendingBloc();
    double heigh = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (lastPressedTime == null ||
            DateTime.now().difference(lastPressedTime!) >
                const Duration(seconds: 1)) {
          lastPressedTime = DateTime.now();
          Utils.flushBarErrorMessage("Press back to exit", context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              AppImage.jamMenu,
              height: heigh * 0.01,
              width: width * 0.02,
            ),
          ),
          title: CommonText(
              title: "Text To Speech", color: Colors.black, size: 0.023),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SvgPicture.asset(
                AppImage.search,
                height: heigh * 0.03,
                width: width * 0.02,
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body:
            BlocBuilder<HomePageBloc, HomePageSate>(builder: (context, state) {
          if (state is ItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemLoaded) {
            return buildMainUi(state, bloc, width, heigh, context);
          } else if (state is ItemError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        }),
      ),
    );
  }

  Stack buildMainUi(ItemLoaded state, HomePageBloc bloc, double width,
      double heigh, BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 13),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText(
                    color: Colors.black,
                    size: 0.02,
                    fontWeight: FontWeight.w600,
                    title: "Import & Listen",
                  ),
                  height(size: 0.02),
                  ImportAndListenGridView(
                      state: state, bloc: bloc, width: width, heigh: heigh)
                ],
              ),
            ),
            height(size: 0.006),
            RowItems(width: width, heigh: heigh, context: context),
            height(size: 0.022),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: CommonText(
                color: Colors.black,
                size: 0.02,
                fontWeight: FontWeight.w600,
                title: "Top Trending",
              ),
            ),
            TopTrendingWidget(width: width),
            height(size: 0.02),
          ],
        ),
        if (state.isImageRecognitionLoading)
          const Center(child: CircularProgressIndicator()),
        if (state.showDialog) CustomPopupDialog(),
      ],
    );
  }

  Container past_text(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
            transform: GradientRotation(0.7),
            colors: [
              ContainerGradientColor.purplelight,
              ContainerGradientColor.purpledark
            ]),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Positioned(
                      top: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                        width: MediaQuery.of(context).size.width * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.053,
                width: MediaQuery.of(context).size.width * 0.28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    AppImage.past_text,
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.055,
              right: -6,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.16),
                        child: Positioned(
                          right: 0,
                          top: MediaQuery.of(context).size.height * 0.05,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.01,
                            width: MediaQuery.of(context).size.width * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget import_method(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
            transform: GradientRotation(0.7),
            colors: [
              ContainerGradientColor.importdark,
              ContainerGradientColor.importlight
            ]),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.24,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Positioned(
                      top: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.01,
                        width: MediaQuery.of(context).size.width * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.053,
                width: MediaQuery.of(context).size.width * 0.28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    AppImage.importWeb,
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.055,
              right: -6,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.16),
                        child: Positioned(
                          right: 0,
                          top: MediaQuery.of(context).size.height * 0.05,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.01,
                            width: MediaQuery.of(context).size.width * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
