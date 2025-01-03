// ignore_for_file: unused_element, unused_local_variable, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/component/attachment_icon.dart';
import 'package:new_wall_paper_app/component/loading_dialog.dart';
import 'package:new_wall_paper_app/component/time_format.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/clean_email_content_remove_specialCharct.dart';

class EmailFolderScreen extends StatefulWidget {
  @override
  State<EmailFolderScreen> createState() => _EmailFolderScreenState();
}

class _EmailFolderScreenState extends State<EmailFolderScreen> {
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = 'INBOX';

  @override
  void initState() {
    super.initState();
    _loadFolders();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadFolders() {
    // Future.delayed(Duration(seconds: 1));
    LoadingDialog(title: "Loading....");
    context.read<GmailBloc>().add(SignInEvent());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    final currentState = context.read<GmailBloc>().state;

    if (currentScroll >= maxScroll * 0.9 &&
        currentState is GmailSignedIn &&
        currentState.hasMoreMessages &&
        currentState.messages.isNotEmpty) {
      final account = context.read<GmailBloc>().googleSignIn.currentUser;
      if (account != null) {
        account.authentication.then((auth) {
          context.read<GmailBloc>().add(
                FetchMessagesEvent(
                  selectedFilter,
                  auth.accessToken!,
                  isFirstLoad: false,
                ),
              );
        });
      }
    }
  }

  void _handleFilterTap(String filter) {
    setState(() {
      selectedFilter = filter;
    });

    final account = context.read<GmailBloc>().googleSignIn.currentUser;
    if (account != null) {
      account.authentication.then((auth) {
        context.read<GmailBloc>().add(
              FetchMessagesEvent(
                filter,
                auth.accessToken!,
                isFirstLoad: true,
              ),
            );
      });
    }
  }

  bool _isFilterSelected(String filter) {
    return selectedFilter == filter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gmail',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {},
        //     child: const Text(
        //       'Done',
        //       style: TextStyle(
        //         color: Colors.blue,
        //         fontSize: 16,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: BlocBuilder<GmailBloc, GmailState>(
        builder: (context, state) {
          if (state is GmailLoading || state is GmailInitial) {
            return Center(
              child: LoadingDialog(title: "Loading...."),
            );
          }

          if (state is GmailSignedIn) {
            final bloc = context.read<GmailBloc>();
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        ...state.folders.map((folder) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildFilterChip(
                              folder.id,
                              folder.subject,
                              state.selectedFolder == folder.id,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                // Messages List
                Expanded(
                  child: state.isLoadingMessages
                      ? Center(child: LoadingDialog(title: "Loading...."))
                      : state.messages.isEmpty && !state.isLoadingMessages
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No messages in ${state.selectedFolder.toLowerCase()}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: state.messages.isEmpty
                                  ? 1
                                  : state.messages.length +
                                      (state.hasMoreMessages &&
                                              state.messages.length >=
                                                  GmailBloc.messagesPerPage
                                          ? 1
                                          : 0),
                              controller: _scrollController,
                              separatorBuilder: (context, index) => Divider(
                                height: 1.4,
                                color: Colors.black.withOpacity(0.3),
                              ).paddingSymmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05),
                              itemBuilder: (context, index) {
                                if (index == state.messages.length &&
                                    state.hasMoreMessages &&
                                    state.messages.length >=
                                        GmailBloc.messagesPerPage) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: LoadingDialog(
                                            title: "Loading....")),
                                  );
                                }

                                final message = state.messages[index];
                                return InkWell(
                                  onTap: () async {
                                    final cleanedBody =
                                        VRemoveSpecialCharctorWidget()
                                            .cleanEmailContent(
                                                message.body ?? "");

                                    //                              messageText: message.body ?? "",
                                    // bossName: "Kristopher Cremin",
                                    // messageSubject: message.subject,
                                    // messageTimestamp: message.timestamp,
                                    // senderEmail: "kris13@gmail.com",
                                    // receiverEmail: "shahrukkhkhan@gmail.com",
                                    // profileImage: message.profileImage,
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WriteAndTextPage(
                                          isConvertable: false,
                                          isMailPage: true,
                                          bossName: "Kristopher Cremin",
                                          dates: message.timestamp,
                                          text: cleanedBody,
                                          senderEmail: "kris13@gmail.com",
                                          receiverEmail:
                                              "shahrukkhkhan@gmail.com",
                                          title: message.subject,
                                          profileImage: message.profileImage,
                                          isText: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Avatar
                                        CircleAvatar(
                                          backgroundImage:
                                              message.profileImage != null
                                                  ? NetworkImage(
                                                      message.profileImage!)
                                                  : null,
                                          backgroundColor: message
                                                      .profileImage ==
                                                  null
                                              ? _getAvatarColor(message.subject)
                                              : null,
                                          radius: 24,
                                          child: message.profileImage == null
                                              ? Text(
                                                  _getAvatarText(
                                                      message.subject),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Message content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Top row with subject and time
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      message.subject,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  CommonText(
                                                    title: formatEmailTime(
                                                        message.timestamp),
                                                    color: Colors.black54,
                                                    size: 0.016,
                                                    fontFamly: AppFont.robot,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                ],
                                              ),
                                              // const SizedBox(height: 4),

                                              // Message preview row with star icon
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      message.body?.substring(
                                                            0,
                                                            message.body!
                                                                        .length >
                                                                    50
                                                                ? 50
                                                                : message.body!
                                                                    .length,
                                                          ) ??
                                                          '',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      message.isStarred
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                      color: message.isStarred
                                                          ? Colors.blue
                                                          : Colors.grey,
                                                    ),
                                                    onPressed: () async {
                                                      final account = context
                                                          .read<GmailBloc>()
                                                          .googleSignIn
                                                          .currentUser;
                                                      if (account != null) {
                                                        final auth =
                                                            await account
                                                                .authentication;
                                                        context
                                                            .read<GmailBloc>()
                                                            .add(
                                                              StarMessageEvent(
                                                                message.id,
                                                                auth.accessToken!,
                                                                star: !message
                                                                    .isStarred,
                                                              ),
                                                            );
                                                      }
                                                    },
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 32,
                                                      minHeight: 32,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // Attachments row if any
                                              if (message.hasAttachments) ...[
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        getAttachmentIcon(
                                                            message
                                                                .attachments
                                                                .first
                                                                .mimeType),
                                                        size: 16,
                                                        color:
                                                            Colors.grey[600]),
                                                    const SizedBox(width: 4),
                                                    if (message.attachments
                                                            .length ==
                                                        1)
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.02,
                                                            vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black54,
                                                                )),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.photo,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            CommonText(
                                                              title:
                                                                  "Image_file",
                                                              color:
                                                                  Colors.black,
                                                              size: 0.02,
                                                              fontFamly:
                                                                  AppFont.robot,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    else
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.02,
                                                                vertical: 5),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black54,
                                                                    )),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.photo,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                CommonText(
                                                                  title:
                                                                      "Image_file",
                                                                  color: Colors
                                                                      .black,
                                                                  size: 0.02,
                                                                  fontFamly:
                                                                      AppFont
                                                                          .robot,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          CommonText(
                                                            title:
                                                                ' +${message.attachments.length - 1}',
                                                            color: Colors.black,
                                                            size: 0.02,
                                                            fontFamly:
                                                                AppFont.robot,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).paddingOnly(top: 10),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          }
          return const Center(
            child: Text('Please sign in to view folders'),
          );
        },
      ),
    );
  }

  String _getAvatarText(String subject) {
    String cleanSubject = subject.trim();

    if (cleanSubject.isEmpty) return 'E';

    int startIndex = 0;
    while (
        startIndex < cleanSubject.length && (cleanSubject[startIndex] == '"')) {
      startIndex++;
    }

    if (startIndex >= cleanSubject.length) return 'E';

    return cleanSubject[startIndex].toUpperCase();
  }

  Widget _buildFilterChip(String id, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => _handleFilterTap(id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? Colors.transparent : Colors.black54),
            color: isSelected ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(String text) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.teal,
    ];

    final index = text.hashCode % colors.length;
    return colors[index];
  }
}
