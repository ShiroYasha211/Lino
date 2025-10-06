import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/controllers/locale_controller.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('chats'.tr, style: AppTheme.headingMedium),
        actions: [
          // Language toggle button
          IconButton(
            icon: Icon(
              localeController.isArabic ? Icons.translate : Icons.language,
              size: 24.w,
            ),
            onPressed: () {
              localeController.toggleLanguage();
            },
          ),
          // Search button
          IconButton(
            icon: Icon(Icons.search, size: 24.w),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat list
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80.w,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'لا توجد محادثات بعد',
                    style: AppTheme.headingSmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'ابدأ محادثة مع أصدقائك',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Start new chat
        },
        child: Icon(Icons.add_comment, size: 24.w),
      ),
    );
  }
}
