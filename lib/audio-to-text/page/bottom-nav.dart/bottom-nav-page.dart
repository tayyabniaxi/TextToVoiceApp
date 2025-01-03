// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/bottom-nav/bottom-nav-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/bottom-nav/bottom-nav-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/bottom-nav/bottom-nav-state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/home-page.dart';
import 'package:new_wall_paper_app/audio-to-text/page/statistic_screen.dart';
import 'package:new_wall_paper_app/audio-to-text/page/subscription_page.dart';
import 'package:new_wall_paper_app/audio-to-text/page/show-history.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

// ignore: use_key_in_widget_constructors
class BottomNavigationPage extends StatefulWidget {
  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  final List<Widget> pages = [
    const HomeScreen(),
     StatisticScreen(),
    const Center(child: Text('Add Page')),
    const HistoryPage(),
    SubscriptionPage()
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AddOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationBloc(),
      child: BlocConsumer<BottomNavigationBloc, BottomNavigationState>(
        listener: (context, state) {
          _pageController.jumpToPage(state.selectedIndex);
        },
        builder: (context, state) {
          return Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
            bottomNavigationBar: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        context: context,
                        isSelected: state.selectedIndex == 0,
                        icon: AppImage.home_icon,
                        label: 'Home',
                        index: 0,
                      ),
                      _buildNavItem(
                        context: context,
                        isSelected: state.selectedIndex == 1,
                        icon: AppImage.explore,
                        label: 'statistics',
                        index: 1,
                      ),
                      const SizedBox(width: 56),
                      _buildNavItem(
                        context: context,
                        isSelected: state.selectedIndex == 3,
                        icon: AppImage.history_icon,
                        label: 'History',
                        index: 3,
                      ),
                      _buildNavItem(
                        context: context,
                        isSelected: state.selectedIndex == 4,
                        icon: AppImage.person,
                        label: 'Profile',
                        index: 4,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 14,
                  child: _buildAddButton(
                    context: context,
                    onTap: () {
                      context
                          .read<BottomNavigationBloc>()
                          .add(const NavigateToPage(2));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  void _onPageChanged(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required bool isSelected,
    required String icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        context.read<BottomNavigationBloc>().add(NavigateToPage(index));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              color: isSelected ? AppColor.primaryColor : Colors.grey,
              height: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.primaryColor : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () => _showAddBottomSheet(),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.14,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColor.primaryColor2,
          shape: BoxShape.circle,
          boxShadow: [],
        ),
        child: Center(
          child: SvgPicture.asset(
            AppImage.plus,
            color: Colors.white,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}

class AddOptionsBottomSheet extends StatelessWidget {
  const AddOptionsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.13,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          CommonText(
            title: "Import",
            color: Colors.black,
            size: 0.025,
            fontFamly: AppFont.robot,
            fontWeight: FontWeight.w600,
          ),
          CommonText(
            title: "Import your document, create and past",
            color: Colors.grey,
            size: 0.02,
            fontFamly: AppFont.robot,
            fontWeight: FontWeight.w400,
          ),
          height(size: 0.015),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_docs,
            title: 'Import Document',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_link,
            title: 'Web Link',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_drive,
            title: 'Google Drive',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_add,
            title: 'Upload Image',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_scan,
            title: 'Scan QR Code',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_scan,
            title: 'Chat With AI',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_note,
            title: 'Notes',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          _buildOptionItem(
            context: context,
            icon: AppImage.bottom_dropbox,
            title: 'Drop Box',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  icon,
                  height: MediaQuery.of(context).size.height * 0.03,
                )),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
