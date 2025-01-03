// ignore_for_file: non_constant_identifier_names, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-state.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/link_reader/link_reader_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/link_reader/link_reader_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/link_reader/link_reader_state.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-bloc-class.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-event.dart';
import 'package:new_wall_paper_app/audio-to-text/page/link_reader_screen.dart';
import 'package:new_wall_paper_app/audio-to-text/page/pdf-to-text-screen.dart';
import 'package:new_wall_paper_app/audio-to-text/page/summarize_screen.dart';
import 'package:new_wall_paper_app/component/button_widget.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

class ImportAndListenGridView extends StatelessWidget {
  ItemLoaded state;
  double width;
  double heigh;
  HomePageBloc bloc;
  ImportAndListenGridView(
      {required this.bloc,
      required this.heigh,
      required this.state,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        // childAspectRatio: 1.2,
        mainAxisSpacing: 10,
      ),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return InkWell(
          onTap: () {
            if (index == 0) {
              bloc.add(ShowPopupDialog());
            } else if (index == 1) {
              context.read<PDFReaderBloc>().add(PickAndReadPDF());
            } else if (index == 2) {
              web_link_bottomsheet(context, width, heigh);
              context.read<HomePageBloc>().add(LoadItemsEvent(''));
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SummarizePage(
                          isOtherPage: false,
                          isEnableBtn: false,
                          isButtonShow: true,
                        )),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: AppColor.containerColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon at the top
                Image.asset(
                  item.imageUrl,
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                height(size: 0.03),
                // Main text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFont.robot,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                height(size: 0.01),
                // Description text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    item.des,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Colors.grey,
                      fontFamily: AppFont.robot,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final urlControler = TextEditingController();
  
  Future<dynamic> web_link_bottomsheet(
    BuildContext context,
    double width,
    double height,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.96,
            expand: false,
            builder: (context, scrollController) {
              return BlocListener<LinkReaderBloc, LinkReaderState>(
                listener: (context, state) {
                  if (state is LinkReaderLoaded) {
                    Navigator.pop(context);
                    urlControler.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinkReaderScreen(),
                      ),
                    );
                  } else if (state is LinkReaderError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        CommonText(
                          title: "Past a web link",
                          color: Colors.black,
                          size: 0.023,
                        ).paddingOnly(left: width * 0.05),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: buildSearchBar(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        BlocBuilder<LinkReaderBloc, LinkReaderState>(
                          builder: (context, state) {
                            final isLoading = state is LinkReaderLoading;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                // Add bottom padding to ensure buttons are above keyboard
                                // bottom: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ButtonWidget(
                                    onpress: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Cancel",
                                    textColor: Colors.black,
                                    size: 0.024,
                                    bgColor: AppColor.containerColor,
                                    width: width,
                                    heigh: height,
                                  ),
                                  ButtonWidget(
                                    onpress: isLoading
                                        ? null
                                        : () {
                                            final url =
                                                urlControler.text.trim();
                                            if (url.isNotEmpty) {
                                              context
                                                  .read<LinkReaderBloc>()
                                                  .add(FetchWebsiteTextEvent(
                                                      url));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please enter a valid URL'),
                                                ),
                                              );
                                            }
                                          },
                                    text: isLoading ? "Processing..." : "Next",
                                    textColor: Colors.white,
                                    size: 0.024,
                                    bgColor: AppColor.primaryColor2,
                                    width: width,
                                    heigh: height,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColor.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: urlControler,
        decoration: InputDecoration(
          hintText: 'e.g www.playstore.com',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}
