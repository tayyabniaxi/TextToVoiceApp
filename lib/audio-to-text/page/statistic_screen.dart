// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/statistic/statistic_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/statistic/statistic_state.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

class StatisticScreen extends StatelessWidget {
  StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double heigh = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: CommonText(
          title: "Statistics",
          color: Colors.black,
          size: 0.021,
          fontFamly: AppFont.robot,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buidTopRow("24", "Total Words"),
                buildVerticalDivider(heigh),
                buidTopRow("24", "Characters"),
                buildVerticalDivider(heigh),
                buidTopRow("24", "Time Spent"),
              ],
            ).paddingSymmetric(horizontal: width * 0.02),
            height(size: 0.03),
            BlocBuilder<StatisticBloc, StatisticState>(
              builder: (context, state) {
                double sliderValue = 0;

                if (state is StatisticSliderValueChangeState) {
                  sliderValue = state.value;
                }

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height(size: 0.01),
                          CommonText(
                                  title: "10,000 Free Words ",
                                  color: Colors.black,
                                  fontFamly: AppFont.robot,
                                  fontWeight: FontWeight.w500,
                                  size: 0.025)
                              .paddingOnly(
                                  left: width * 0.05,
                                  right: width * 0.05,
                                  top: 6),
                          Slider(
                            value: sliderValue,
                            min: 0,
                            max: 100,
                            onChanged: (value) {
                              context
                                  .read<StatisticBloc>()
                                  .add(StatisticSliderValueChange(value));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                  title: "450 Words ",
                                  color: Colors.black54,
                                  fontFamly: AppFont.robot,
                                  fontWeight: FontWeight.w400,
                                  size: 0.02),
                              CommonText(
                                  title: "9,550 Left  ",
                                  color: Colors.black54,
                                  fontFamly: AppFont.robot,
                                  fontWeight: FontWeight.w400,
                                  size: 0.02)
                            ],
                          ).paddingOnly(
                              left: width * 0.05,
                              right: width * 0.05,
                              bottom: heigh * 0.02),
                        ],
                      ),
                    ),
                    height(size: 0.03),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.primaryColor2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
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
                                    title: "Rs ${1109.99} / Year, ",
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xffFF0000),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Save 70%",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Text('Slider Value: $sliderValue'),
                  ],
                );
              },
            ).paddingSymmetric(horizontal: width * 0.06),
            height(size: 0.02),
            ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: heigh * 0.013,
                );
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: text.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: heigh * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.containerColor,
                  ),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColor.primaryColor2),
                          child:
                              SvgPicture.asset(imageList[index]).paddingAll(5)),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      CommonText(
                        title: text[index],
                        color: Colors.black,
                        size: 0.026,
                        fontFamly: AppFont.robot,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ).paddingSymmetric(horizontal: width * 0.04),
                ).paddingSymmetric(horizontal: width * 0.06);
              },
            )
          ],
        ),
      ),
    );
  }

  List text = [
    "Restore Purchase",
    "Report Issues",
    "FAQ’s",
    "Request a features",
    "rate us",
  ];
  List imageList = [
    AppImage.statistic_restore,
    AppImage.statistic_edit,
    AppImage.statistic_faq,
    AppImage.statistic_request,
    AppImage.statistic_review,
    AppImage.statistic_support,
  ];
  SizedBox buildVerticalDivider(double heigh) {
    return SizedBox(
      height: heigh * 0.08,
      child: const VerticalDivider(
        color: AppColor.primaryColor2,
      ),
    );
  }

  Row buidTopRow(String value, String key) {
    return Row(
      children: [
        Column(
          children: [
            CommonText(
              title: value,
              color: AppColor.primaryColor2,
              size: 0.034,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w500,
            ),
            height(size: 0.007),
            CommonText(
              title: key,
              color: Colors.black54,
              size: 0.023,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ],
    );
  }
}
