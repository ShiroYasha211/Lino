import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_theme.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr, style: AppTheme.headingMedium),
        actions: [
          // Mark all as read button
          TextButton(
            onPressed: () {
              // TODO: Mark all notifications as read
            },
            child: Text(
              'mark_all_read'.tr,
              style: TextStyle(fontSize: 12.sp, color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80.w, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'no_notifications'.tr,
              style: AppTheme.headingSmall.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'ستظهر هنا جميع إشعاراتك',
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
