// message_screen.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/read_email/MessageDetailScreen%20.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/clean_email_content_remove_specialCharct.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

// class MessageScreen extends StatelessWidget {
//   final String folderId;
//   final String accessToken;
//   final String folderName;

//   const MessageScreen(
//       {Key? key,
//       required this.folderId,
//       required this.accessToken,
//       required this.folderName})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     context.read<GmailBloc>().add(FetchMessagesEvent(folderId, accessToken));

//     return Scaffold(
//       appBar: AppBar(title: Text('Messages')),
//       body: BlocBuilder<GmailBloc, GmailState>(
//         builder: (context, state) {
//           if (state is GmailLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is GmailMessagesError) {
//             return Center(child: Text('Error: ${state.message}'));
//           } else if (state is GmailMessagesLoaded) {
//             if (state.messages.isEmpty) {
//               return Center(child: Text('No messages found.'));
//             }
//             return ListView.builder(
//               itemCount: state.messages.length,
//               itemBuilder: (context, index) {
//                 final message = state.messages[index];
//                 return ListTile(
//                   title: Text(message.subject),
//                   subtitle: Text('ID: ${message.id}'),
// onTap: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => MessageDetailScreen(
//         subject: message.subject,
//         body: message.body ?? "",
//       ),
//     ),
//   );
// },
//                 );
//               },
//             );
//           }
//           return Center(child: Text('No messages found.'));
//         },
//       ),
//     );
//   }
// }

class MessageScreen extends StatefulWidget {
  final String folderId;
  final String accessToken;
  final String folderName;

  const MessageScreen(
      {Key? key,
      required this.folderId,
      required this.accessToken,
      required this.folderName})
      : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _scrollController.addListener(_onScroll);
  }

  void _loadInitialMessages() {
    context.read<GmailBloc>().add(FetchMessagesEvent(
        widget.folderId, widget.accessToken,
        isFirstLoad: true));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<GmailBloc>().state;
      if (state is GmailMessagesLoaded &&
          state.hasMore &&
          !context.read<GmailBloc>().isLoadingMore) {
        context.read<GmailBloc>().add(FetchMessagesEvent(
            widget.folderId, widget.accessToken,
            isFirstLoad: false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
        title: CommonText(
          title: widget.folderName,
          color: Colors.black,
          size: 0.023,
          fontFamly: AppFont.robot,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<GmailBloc>().signOut();
            },
          ),
        ],
      ),
      body: BlocBuilder<GmailBloc, GmailState>(
        builder: (context, state) {
          if (state is GmailLoading && state is! GmailMessagesLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GmailMessagesLoaded) {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                );
              },
              controller: _scrollController,
              itemCount: state.messages.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.messages.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final message = state.messages[index];
                return index == 0
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.containerColor),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WriteAndTextPage(
                                  isConvertable: false,
                                  // subject: message.subject,
                                  text: message.body ?? "",
                                  isText: false,
                                ),
                              ),
                            );
                          },
                          title: CommonText(
                            title: message.subject,
                            color: Colors.black,
                            size: 0.018,
                            fontFamly: AppFont.robot,
                            fontWeight: FontWeight.w400,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: MediaQuery.of(context).size.height * 0.025,
                          ),
                          // subtitle: Text(message. ?? ''),
                        ).paddingAll(3),
                      );
              },
            );
          }

          // if (state is GmailMessagesError) {
          //   return Center(child: Text(state.message));
          // }

          return const Center(child: Text('No messages found'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
