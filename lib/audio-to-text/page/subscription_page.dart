// subscription_event.dart
// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/subscription/subscription_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/subscription/subscription_state.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

// subscription_page.dart
class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double heigh = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => SubscriptionBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                return ListView(
                  children: [
                    height(size: 0.02),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFeatureIcon(Icons.language, "Websites"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          _buildFeatureIcon(
                              Icons.document_scanner, "Scan Text"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          _buildFeatureIcon(Icons.attach_file, "Attach"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: CommonText(
                        title: 'Text To Speech',
                        color: Colors.black,
                        size: 0.027,
                        fontFamly: AppFont.robot,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    height(size: 0.01),
                    Align(
                      alignment: Alignment.center,
                      child: CommonText(
                        title: 'Read Anything Aloud In Top Quality Voices',
                        color: Colors.grey,
                        size: 0.018,
                        fontFamly: AppFont.robot,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                        alignment: Alignment.center,
                        child: _buildFeatureList(context)),
                    const SizedBox(height: 30),
                    _buildPricingCards(state),
                    // const Spacer(),
                    height(size: 0.04),
                    _buildTryButton(),
                    _buildBottomRow(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    AppImage.profile_check,
                    color: AppColor.primaryColor2,
                  ),
                )),
            const SizedBox(width: 5),
            CommonText(
              title: label,
              color: AppColor.primaryColor2,
              size: 0.02,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureItem("Unlock Unlimited Access", context),
        height(size: 0.01),
        _buildFeatureItem("Turn Any Text Into Audio", context),
        height(size: 0.01),
        _buildFeatureItem("Best AI Voices Anywhere", context),
      ],
    );
  }

  Widget _buildFeatureItem(String text, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              AppImage.profile_box,
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            SvgPicture.asset(AppImage.profile_check),
          ],
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.06),
        CommonText(
          title: text,
          color: Colors.black,
          size: 0.02,
          fontFamly: AppFont.robot,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildPricingCards(SubscriptionState state) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonText(
                title: "${state.trialDays} Days Free Trial, Auto Renewal",
                color: Colors.white70,
                size: 0.02,
                fontFamly: AppFont.robot,
                fontWeight: FontWeight.w400,
              ),
              height(size: 0.01),
              Row(
                children: [
                  CommonText(
                    title: "Rs ${state.weeklyPrice} / Week",
                    color: Colors.white,
                    size: 0.026,
                    fontFamly: AppFont.robot,
                    fontWeight: FontWeight.w500,
                  ),
                  CommonText(
                    title: ", cancel anytime",
                    color: Colors.white60,
                    size: 0.021,
                    fontFamly: AppFont.robot,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.primaryColor2),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText(
                    title: "Billed Yearly, Auto Renewal",
                    color: Colors.black45,
                    size: 0.02,
                    fontFamly: AppFont.robot,
                    fontWeight: FontWeight.w400,
                  ),
                  height(size: 0.013),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText(
                        title: "Rs ${state.yearlyPrice} / Year, ",
                        color: Colors.black,
                        size: 0.026,
                        fontFamly: AppFont.robot,
                        fontWeight: FontWeight.w500,
                      ),
                      CommonText(
                        title: "cancel anytime",
                        color: Colors.black38,
                        size: 0.02,
                        fontFamly: AppFont.robot,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  )
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF0000),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Save 70%",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("Try For Free"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomRow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Terms"),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 5),
              Text("No Payment Now"),
            ],
          ),
          Text("Privacy"),
        ],
      ),
    );
  }
}
