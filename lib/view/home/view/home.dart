import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lino_app/view/auth/controller/auth_controller.dart';

import '../../../core/controllers/locale_controller.dart';
import '../widgets/chats_tab.dart';
import '../widgets/friends_tab.dart';
import '../widgets/notifications_tab.dart';
import '../widgets/profile_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const ChatsTab(),
    const FriendsTab(),
    const NotificationsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline, size: 24.w),
            activeIcon: Icon(Icons.chat_bubble, size: 24.w),
            label: 'chats'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: 24.w),
            activeIcon: Icon(Icons.people, size: 24.w),
            label: 'friends'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: 24.w),
            activeIcon: Icon(Icons.notifications, size: 24.w),
            label: 'notifications'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24.w),
            activeIcon: Icon(Icons.person, size: 24.w),
            label: 'profile'.tr,
          ),
        ],
      ),
    );
  }
}
