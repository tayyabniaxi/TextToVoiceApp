import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/image_editing_screen.dart';
import 'package:new_wall_paper_app/audio-to-text/page/imgReader-screen.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/utils/routes/route_name.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

class CustomPopupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HomePageBloc>(),
      child: BlocConsumer<HomePageBloc, HomePageSate>(
        listener: (context, state) {
          if (state is ImageEditingState) {
            Navigator.pop(context); // Close the dialog
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ImageEditorScreen(imagePath: state.imagePath),
              ),
            );
          }
        },
        builder: (context, state) {
          double heigh = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          
                          context.read<HomePageBloc>().add(
                                PickImageAndRecognizeTextEvent(isCamera: true),
                              );
                        },
                        child: Container(
                          width: width * 0.25,
                          height: heigh * 0.14,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColor.primaryColor2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 50, color: Colors.white),
                              SizedBox(height: 5),
                              CommonText(
                                  title: "Camera",
                                  color: Colors.white,
                                  size: 0.02)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.read<HomePageBloc>().add(
                                PickImageAndRecognizeTextEvent(isCamera: false),
                              );
                        },
                        child: Container(
                          width: width * 0.25,
                          height: heigh * 0.14,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColor.primaryColor2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.photo, size: 50, color: Colors.white),
                              SizedBox(height: 5),
                              CommonText(
                                  title: "Gallery",
                                  color: Colors.white,
                                  size: 0.02)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () =>
                            context.read<HomePageBloc>().add(HidePopupDialog()),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void showNoTextDialog() {
  Get.dialog(
    AlertDialog(
      title: Text('No Text Found'),
      content: Text('Unable to detect any text in this image.'),
      actions: [
        TextButton(
          onPressed: () {
            Get.offNamed(RoutesName.bottomNavigationPage);
          },
          child: CommonText(
            title: "Home",
            color: Colors.blue,
            size: 0.02,
            fontFamly: AppFont.robot,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
