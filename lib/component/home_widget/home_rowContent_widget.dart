// ignore_for_file: avoid_print, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/qr_scanner_screen.dart';
import 'package:new_wall_paper_app/audio-to-text/page/read_email/mail_folder.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

class RowItems extends StatelessWidget {
  double width;
  double heigh;
  BuildContext context;
  // const RowItems({super.key});

  RowItems({required this.context, required this.heigh, required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // height(size: 0.03),
          SizedBox(
            width: width,
            height: heigh * 0.135,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: width * 0.02,
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: context.read<HomePageBloc>().exploreBooksList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    switch (index) {
                      case 0:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ScannerScreen()));
                        print("Help Book ");
                        break;
                      case 1:
                        print("Qr code scanner");

                        handleEmailNavigation(context);
                        break;
                      default:
                        print("Non of the above");
                    }
                  },
                  child: Container(
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      color: AppColor.containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            context
                                .read<HomePageBloc>()
                                .exploreBooksList[index],
                            height: heigh * 0.05,
                          ),
                        ),
                        CommonText(
                          textAlign: TextAlign.center,
                          color: Colors.black,
                          size: 0.018,
                          fontWeight: FontWeight.w400,
                          title: context
                              .read<HomePageBloc>()
                              .exploreBookstitleList[index],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleEmailNavigation(BuildContext context) async {
    final gmailBloc = context.read<GmailBloc>();

    try {
      final currentUser = gmailBloc.googleSignIn.currentUser;

      if (currentUser == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        gmailBloc.add(SignInEvent());

        await for (final state in gmailBloc.stream) {
          if (state is GmailSignedIn) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmailFolderScreen()),
            );
            break;
          } else if (state is GmailFoldersError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            break;
          }
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmailFolderScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing Gmail: $e')),
      );
    }
  }

}
