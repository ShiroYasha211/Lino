import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lino_app/view/auth/controller/auth_controller.dart';

import '../../../../core/router/app_pages.dart';
import '../../../../core/themes/app_theme.dart';
import '../widgets/custom_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final AuthController _authController = Get.find<AuthController>();
  final String _email = Get.arguments?['email'] ?? '';

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    // الاستماع لتغيرات حالة المصادقة للكشف عن تفعيل البريد
    _authController.setupEmailVerificationListener((user) {
      if (user?.emailConfirmedAt != null) {
        // إذا تم تفعيل البريد، الانتقال إلى صفحة إكمال البروفايل
        Get.offAllNamed(Routes.COMPLETE_PROFILE);
      }
    });
  }

  Future<void> _resendVerification() async {
    final success = await _authController.resendEmailVerification();
    if (success) {
      Get.snackbar(
        'تم الإرسال',
        'تم إعادة إرسال رابط التفعيل إلى بريدك الإلكتروني',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }

  void _checkVerification() async {
    // إعادة تحميل حالة المستخدم للتحقق من التفعيل
    await _authController.reloadUser();
    if (_authController.isEmailVerified) {
      Get.offAllNamed(Routes.COMPLETE_PROFILE);
    } else {
      Get.snackbar(
        'لم يتم التفعيل',
        'لم يتم تفعيل البريد الإلكتروني بعد. يرجى التحقق من بريدك.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),

                      // Icon
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.email_outlined,
                          size: 50.w,
                          color: AppTheme.primaryColor,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Title
                      Text(
                        'تفعيل البريد الإلكتروني',
                        style: AppTheme.headingLarge,
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 16.h),

                      // Description
                      Text(
                        'تم إرسال رابط التفعيل إلى:',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8.h),

                      // Email
                      Text(
                        _email,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        'يرجى التحقق من بريدك الإلكتروني والنقر على رابط التفعيل للمتابعة.',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'بعد تفعيل البريد، سيتم نقلك تلقائياً إلى صفحة إكمال الملف الشخصي.',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 40.h),

                      // Check Verification Button
                      CustomButton(
                        text: 'تم تفعيل البريد - تابع',
                        onPressed: _checkVerification,
                        backgroundColor: Colors.green,
                      ),

                      SizedBox(height: 16.h),

                      // Resend Button
                      OutlinedButton(
                        onPressed: _resendVerification,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                          minimumSize: Size(double.infinity, 50.h),
                        ),
                        child: Text('إعادة إرسال رابط التفعيل'),
                      ),
                    ],
                  ),
                ),
              ),

              // Support Text
              Text(
                'إذا لم تستلم البريد، تحقق من مجلد الرسائل غير المرغوب فيها (Spam)',
                style: AppTheme.bodySmall.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
