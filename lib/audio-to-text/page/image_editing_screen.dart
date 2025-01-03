import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/imgReader-screen.dart';
import 'package:new_wall_paper_app/component/dialog_widget.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/utils/routes/route_name.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

class ImageEditingScreen extends StatelessWidget {
  final String imagePath;

  const ImageEditingScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Image'),
      ),
      body: BlocBuilder<HomePageBloc, HomePageSate>(
        builder: (context, state) {
          if (state is ImageEditingState) {
            return Column(
              children: [
                Expanded(
                  child: Image.file(
                    File(state.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<HomePageBloc>()
                        .add(CropImageEvent(state.imagePath));
                  },
                  child: Text('Crop'),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class ImageEditorScreen extends StatelessWidget {
  final String imagePath;

  const ImageEditorScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          context.read<HomePageBloc>()..add(EditImageEvent(imagePath)),
      child: ImageEditorContent(),
    );
  }
}

class ImageEditorContent extends StatelessWidget {
  ImageEditorContent({Key? key}) : super(key: key);

  final List<ColorFilter?> filters = [
    null, // Normal
    const ColorFilter.matrix([
      1.2,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.2,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.2,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]), // Vivid
    const ColorFilter.matrix([
      0.393,
      0.769,
      0.189,
      0.0,
      0.0,
      0.349,
      0.686,
      0.168,
      0.0,
      0.0,
      0.272,
      0.534,
      0.131,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]), // Sepia
    const ColorFilter.matrix([
      0.5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]), // Dark
    const ColorFilter.matrix([
      2.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      2.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      2.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]), // Bright
    const ColorFilter.matrix([
      0.33,
      0.33,
      0.33,
      0.0,
      0.0,
      0.33,
      0.33,
      0.33,
      0.0,
      0.0,
      0.33,
      0.33,
      0.33,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]),
  ];

  final List<String> filterNames = [
    'Normal',
    'Vivid',
    'Sepia',
    'Dark',
    'Bright',
    'Grayscale'
  ];

  void _showFiltersBottomSheet(BuildContext context, ImageEditingState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<HomePageBloc>()
                              .add(ApplyFilterEvent(index));
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: state.selectedFilterIndex == index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: filters[index] == null
                                  ? Image.file(File(state.imagePath),
                                      fit: BoxFit.cover)
                                  : ColorFiltered(
                                      colorFilter: filters[index]!,
                                      child: Image.file(File(state.imagePath),
                                          fit: BoxFit.cover),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              filterNames[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
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
      },
    );
  }

  void _showResizeDialog(BuildContext context, ImageEditingState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(),
          child: AlertDialog(
            title: const Text('Resize Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Scale: ${(state.scale * 100).toInt()}%'),
                Slider(
                  value: state.scale,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  onChanged: (value) {
                    context.read<HomePageBloc>().add(ResizeImageEvent(value));
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  context.read<HomePageBloc>().add(ResizeImageEvent(1.0));
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Apply'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isProcessing,
  }) {
    return InkWell(
      onTap: isProcessing ? null : onTap,
      child: Container(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isProcessing ? Colors.grey : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isProcessing ? Colors.grey : Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageSate>(
      listener: (context, state) {
        // if (state is ImageEditingState && !state.isProcessing) {}
      },
      builder: (context, state) {
        if (state is ImageEditingState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: kToolbarHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Get.toNamed(RoutesName.bottomNavigationPage),
                            ),
                            Text(
                              filterNames[state.selectedFilterIndex],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                                icon:
                                    const Icon(Icons.check, color: Colors.blue),
                                onPressed: () {
                                  context
                                      .read<HomePageBloc>()
                                      .add(ProcessEditedImage(state.imagePath));
                                }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Transform.scale(
                            scale: state.scale,
                            child: Transform.rotate(
                              angle: state.rotation * 3.14159 / 180,
                              child: filters[state.selectedFilterIndex] == null
                                  ? Image.file(File(state.imagePath))
                                  : ColorFiltered(
                                      colorFilter:
                                          filters[state.selectedFilterIndex]!,
                                      child: Image.file(File(state.imagePath)),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildToolButton(
                              context: context,
                              icon: Icons.auto_fix_high,
                              label: 'Auto',
                              onTap: () =>
                                  _showFiltersBottomSheet(context, state),
                              isProcessing: state.isProcessing,
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.crop,
                              label: 'Crop',
                              onTap: () => context
                                  .read<HomePageBloc>()
                                  .add(CropImageEvent(state.imagePath)),
                              isProcessing: state.isProcessing,
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.rotate_right,
                              label: 'Rotate',
                              onTap: () => context
                                  .read<HomePageBloc>()
                                  .add(RotateImageEvent()),
                              isProcessing: state.isProcessing,
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.photo_size_select_large,
                              label: 'Resize',
                              onTap: () => _showResizeDialog(context, state),
                              isProcessing: state.isProcessing,
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.delete,
                              label: 'Delete',
                              onTap: () => Navigator.pop(context),
                              isProcessing: state.isProcessing,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<HomePageBloc>()
                                  .add(ProcessEditedImage(state.imagePath));

                              // context
                              //   .read<HomePageBloc>()
                              //   .add(ProcessEditedImage(state.imagePath));
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state.isProcessing)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
