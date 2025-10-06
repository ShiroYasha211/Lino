import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../../../core/router/app_pages.dart';
import '../../../core/themes/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();

      final result = await authController.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );

      switch (result) {
        case SignUpResult.success:
          // الانتقال إلى صفحة تأكيد البريد بدلاً من إكمال البروفايل
          Get.offAllNamed(
            Routes.VERIFY_EMAIL,
            arguments: {'email': _emailController.text.trim()},
          );
          break;

        case SignUpResult.emailAlreadyExists:
          Get.snackbar(
            'البريد الإلكتروني موجود بالفعل',
            'هذا البريد الإلكتروني مسجل مسبقاً. يرجى تسجيل الدخول أو استخدام بريد آخر.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 5),
            mainButton: TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed(Routes.LOGIN);
              },
              child: Text('تسجيل الدخول'),
            ),
          );
          break;

        case SignUpResult.emailNotVerified:
          // في حالة التسجيل الناجح ولكن البريد يحتاج تفعيل
          Get.offAllNamed(
            Routes.VERIFY_EMAIL,
            arguments: {'email': _emailController.text.trim()},
          );
          break;

        case SignUpResult.unknownError:
          Get.snackbar(
            'خطأ في إنشاء الحساب',
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),

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
                          'إنشاء حساب جديد',
                          style: AppTheme.headingLarge,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          'انضم إلينا وابدأ في التواصل',
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

                        // Confirm password field
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'confirm_password'.tr,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field_required'.tr;
                            }
                            if (value != _passwordController.text) {
                              return 'passwords_not_match'.tr;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 32.h),

                        // Signup button
                        Obx(
                          () => CustomButton(
                            text: 'create_account'.tr,
                            isLoading: authController.isLoading,
                            onPressed: _signUp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('already_have_account'.tr, style: AppTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                        Get.offNamed(Routes.LOGIN);
                      },
                      child: Text('login'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
