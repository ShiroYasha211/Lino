import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/controllers/locale_controller.dart';
import '../../auth/controller/auth_controller.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('logout_confirm'.tr),
        content: Text('هل تريد بالتأكيد تسجيل الخروج؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<AuthController>().signOut();
              Get.offAllNamed('/auth/login');
            },
            child: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr, style: AppTheme.headingMedium),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, size: 24.w),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              // Profile picture and info
              Center(
                child: Column(
                  children: [
                    // Profile picture
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 3,
                        ),
                      ),
                      child: user.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user.avatarUrl!,
                                width: 120.w,
                                height: 120.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 60.w,
                                    color: Colors.grey[400],
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 60.w,
                              color: Colors.grey[400],
                            ),
                    ),

                    SizedBox(height: 16.h),

                    // Name
                    Text(
                      user.fullName,
                      style: AppTheme.headingMedium,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 4.h),

                    // Username
                    Text(
                      '@${user.username}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),

                    if (user.bio.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          user.bio,
                          style: AppTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Settings list
              _buildSettingsSection(),

              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSettingsSection() {
    final localeController = Get.find<LocaleController>();

    return Column(
      children: [
        _buildSettingsTile(
          icon: Icons.person_outline,
          title: 'account_settings'.tr,
          onTap: () {
            // TODO: Navigate to account settings
          },
        ),
        _buildSettingsTile(
          icon: Icons.security,
          title: 'privacy_settings'.tr,
          onTap: () {
            // TODO: Navigate to privacy settings
          },
        ),
        _buildSettingsTile(
          icon: Icons.notifications_outlined,
          title: 'notification_settings'.tr,
          onTap: () {
            // TODO: Navigate to notification settings
          },
        ),
        _buildSettingsTile(
          icon: Icons.language,
          title: 'language'.tr,
          subtitle: localeController.isArabic ? 'arabic'.tr : 'english'.tr,
          onTap: () {
            _showLanguageDialog();
          },
        ),
        _buildSettingsTile(
          icon: Icons.palette_outlined,
          title: 'theme_settings'.tr,
          subtitle: 'system_mode'.tr,
          onTap: () {
            // TODO: Navigate to theme settings
          },
        ),
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: 'about'.tr,
          onTap: () {
            // TODO: Show about dialog
          },
        ),
        _buildSettingsTile(
          icon: Icons.logout,
          title: 'logout'.tr,
          titleColor: Colors.red,
          onTap: _showLogoutDialog,
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24.w, color: titleColor ?? Colors.grey[700]),
      title: Text(title, style: AppTheme.bodyLarge.copyWith(color: titleColor)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(color: Colors.grey[600]),
            )
          : null,
      trailing: Icon(Icons.chevron_right, size: 20.w, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    final localeController = Get.find<LocaleController>();

    Get.dialog(
      AlertDialog(
        title: Text('language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('arabic'.tr),
              leading: Radio<bool>(
                value: true,
                groupValue: localeController.isArabic,
                onChanged: (value) {
                  if (value == true) {
                    localeController.changeLocale(const Locale('ar', 'SA'));
                    Get.back();
                  }
                },
              ),
            ),
            ListTile(
              title: Text('english'.tr),
              leading: Radio<bool>(
                value: false,
                groupValue: localeController.isArabic,
                onChanged: (value) {
                  if (value == false) {
                    localeController.changeLocale(const Locale('en', 'US'));
                    Get.back();
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ],
      ),
    );
  }
}
