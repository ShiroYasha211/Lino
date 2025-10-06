import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lino_app/core/router/app_pages.dart';

import '../controller/auth_controller.dart';
import '../../../core/themes/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();

      final result = await authController.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      switch (result) {
        case SignInResult.success:
          if (authController.needsProfileCompletion) {
            Get.offAllNamed(Routes.COMPLETE_PROFILE);
          } else {
            Get.offAllNamed(Routes.HOME);
          }
          break;

        // case SignInResult.emailNotRegistered:
        //   Get.snackbar(
        //     'البريد الإلكتروني غير مسجل',
        //     'هذا البريد الإلكتروني غير مسجل في النظام. يرجى إنشاء حساب جديد.',
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: Duration(seconds: 5),
        //   );
        //   break;

        case SignInResult.invalidPassword:
          Get.snackbar(
            'الايمل او كلمة المرور خاطئة',
            'كلمة المرور التي أدخلتها غير صحيحة. يرجى المحاولة مرة أخرى.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 5),
          );
          break;

        case SignInResult.emailNotVerified:
          Get.defaultDialog(
            title: 'البريد الإلكتروني غير مفعل',
            content: Column(
              children: [
                Text('يجب تفعيل بريدك الإلكتروني قبل تسجيل الدخول.'),
                SizedBox(height: 16),
                Text(
                  'يرجى التحقق من بريدك الإلكتروني والنقر على رابط التفعيل.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  // يمكن إضافة خيار إعادة إرسال رابط التفعيل هنا
                  authController.resendEmailVerification();
                },
                child: Text('إعادة إرسال رابط التفعيل'),
              ),
              TextButton(onPressed: () => Get.back(), child: Text('حسناً')),
            ],
          );
          break;

        case SignInResult.unknownError:
          Get.snackbar(
            'خطأ في تسجيل الدخول',
            'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble_rounded,
                          size: 50.w,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Welcome text
                      Text(
                        'مرحباً بعودتك',
                        style: AppTheme.headingLarge,
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'قم بتسجيل الدخول للمتابعة',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 40.h),

                      // Email field
                      CustomTextField(
                        controller: _emailController,
                        label: 'email'.tr,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'field_required'.tr;
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'invalid_email'.tr;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      // Password field
                      CustomTextField(
                        controller: _passwordController,
                        label: 'password'.tr,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'field_required'.tr;
                          }
                          if (value.length < 6) {
                            return 'password_too_short'.tr;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: Text('forgot_password'.tr),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Login button
                      Obx(
                        () => CustomButton(
                          text: 'login'.tr,
                          isLoading: authController.isLoading,
                          onPressed: _login,
                        ),
                      ),
                    ],
                  ),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('dont_have_account'.tr, style: AppTheme.bodyMedium),
                      TextButton(
                        onPressed: () {
                          Get.offNamed(Routes.SIGNUP);
                        },
                        child: Text('signup'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
