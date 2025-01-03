import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/personal_dev/bloc/personal_dev_bloc_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/personal_dev/bloc/personal_dev_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/personal_dev/bloc/personal_dev_bloc_state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/personal_dev_detail.dart';
import 'package:new_wall_paper_app/model/course_model.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/res/font.dart';

class PersonalDevelopmentScreeen extends StatefulWidget {
  const PersonalDevelopmentScreeen({Key? key}) : super(key: key);

  @override
  State<PersonalDevelopmentScreeen> createState() =>
      _PersonalDevelopmentScreeenState();
}

class _PersonalDevelopmentScreeenState
    extends State<PersonalDevelopmentScreeen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late CourseBloc _courseBloc;
  List<String> filteredPrompts = [];
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _courseBloc = CourseBloc()..add(LoadCourses());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        final currentState = _courseBloc.state;
        if (currentState is CourseLoaded) {
          setState(() {
            showSuggestions = true;
            filteredPrompts = currentState.suggestedPrompts
                .where((prompt) =>
                    prompt.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
        }
      } else {
        setState(() {
          showSuggestions = false;
          filteredPrompts = [];
        });
        _courseBloc.add(LoadCourses());
      }
    });
  }

  void _handleSuggestionTap(String prompt) {
    _searchController.removeListener(_onSearchChanged);

    setState(() {
      showSuggestions = false;
      filteredPrompts = [];
      _searchController.text = prompt;
    });

    _courseBloc.add(SelectPrompt(prompt));

    Future.delayed(const Duration(milliseconds: 100), () {
      _searchController.addListener(_onSearchChanged);
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Here....',
          hintStyle: TextStyle(color: Colors.grey[400]),
          fillColor: Colors.blue.withOpacity(0.1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      showSuggestions = false;
                      filteredPrompts = [];
                    });
                    _courseBloc.add(LoadCourses());
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Personal Development',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseError) {
              return Center(child: Text(state.message));
            }

            if (state is CourseLoaded) {
              return Stack(
                children: [
                  Column(
                    children: [
                      _buildSearchBar(),
                      if (!showSuggestions)
                        Expanded(
                          child: SingleChildScrollView(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                              itemCount: state.courses.length,
                              itemBuilder: (context, index) => CourseCard(
                                course: state.courses[index],
                                index: index,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (showSuggestions && filteredPrompts.isNotEmpty)
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredPrompts.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemBuilder: (context, index) {
                            final prompt = filteredPrompts[index];
                            return GestureDetector(
                              onTap: () => _handleSuggestionTap(prompt),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  prompt,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ).paddingSymmetric(vertical: 6),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final int index;

  const CourseCard({
    required this.course,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PersonalDevDetailScreen(
              content: course.description,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(course.imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  _buildControlButton(
                    context,
                    onTap: () =>
                        context.read<CourseBloc>().add(TogglePlayState(index)),
                    icon: course.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(AppImage.ix_ai)
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: AppFont.robot,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontFamily: AppFont.robot,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required VoidCallback onTap,
    IconData? icon,
    Widget? child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: child ??
            Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
      ),
    );
  }
}
