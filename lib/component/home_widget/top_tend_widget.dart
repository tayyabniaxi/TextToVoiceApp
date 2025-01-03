// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/top_trend_bloc_state.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/bloc/top_trend_bloc_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/bloc/top_trend_bloc_event.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/tend_item/bloc/top_trend_bloc_state.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/utils/routes/route_name.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

class TopTrendingWidget extends StatelessWidget {
  const TopTrendingWidget({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrendingBloc, TrendingState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            TopTrendWidgets(width: width, state: state),
          ],
        );
      },
    );
  }
}

class TopTrendWidgets extends StatelessWidget {
  TopTrendWidgets({super.key, required this.width, required this.state});

  final double width;
  TrendingState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
        color: AppColor.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: state.categories.map((category) {
                  final isSelected = category == state.selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<TrendingBloc>()
                            .add(SelectCategory(category));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey),
                          color: isSelected
                              ? Colors.blue
                              : AppColor.containerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              children: state.sections.map((section) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RoutesName.PersonalDevelopmentScreeen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(section.icon),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            CommonText(
                                title: section.title,
                                color: Colors.black,
                                fontFamly: AppFont.robot,
                                fontWeight: FontWeight.w400,
                                size: 0.023)
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
