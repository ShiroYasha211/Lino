import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lino_app/core/router/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controller/auth_controller.dart';
import '../../../core/themes/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  File? _selectedImage;
  bool _isUsernameChecking = false;
  bool _isUsernameAvailable = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _checkUsername(String username) async {
    if (username.length < 3) return;

    setState(() {
      _isUsernameChecking = true;
    });

    final authController = Get.find<AuthController>();
    final isAvailable = await authController.isUsernameAvailable(username);

    setState(() {
      _isUsernameChecking = false;
      _isUsernameAvailable = isAvailable;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _completeProfile() async {
    if (_formKey.currentState!.validate()) {
      if (!_isUsernameAvailable) {
        Get.snackbar(
          'خطأ',
          'اسم المستخدم غير متاح',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final authController = Get.find<AuthController>();

      String? avatarUrl;
      if (_selectedImage != null) {
        try {
          // عرض مؤشر تحميل أثناء رفع الصورة
          Get.dialog(
            Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );

          avatarUrl = await _uploadImageToSupabase(_selectedImage!);

          Get.back(); // إغلاق مؤشر التحميل
        } catch (e) {
          Get.back(); // إغلاق مؤشر التحميل في حالة الخطأ
          Get.snackbar(
            'خطأ في رفع الصورة',
            'فشل في رفع الصورة. يرجى المحاولة مرة أخرى.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      final result = await authController.completeProfile(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        bio: _bioController.text.trim(),
        avatarUrl: avatarUrl,
      );

      switch (result) {
        case ProfileCompletionResult.success:
          Get.offAllNamed(Routes.HOME);
          break;

        case ProfileCompletionResult.usernameTaken:
          Get.snackbar(
            'اسم المستخدم محجوز',
            'اسم المستخدم هذا مستخدم بالفعل. يرجى اختيار اسم آخر.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;

        case ProfileCompletionResult.invalidUsername:
          // الرسالة تظهر بالفعل من داخل الـ controller
          break;

        case ProfileCompletionResult.invalidFullName:
          Get.snackbar(
            'خطأ في الاسم الكامل',
            'الاسم الكامل مطلوب ويجب أن يكون على الأقل حرفين',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;

        case ProfileCompletionResult.userNotFound:
          Get.snackbar(
            'خطأ في المصادقة',
            'لم يتم العثور على بيانات المستخدم. يرجى تسجيل الدخول مرة أخرى.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;

        case ProfileCompletionResult.unknownError:
          Get.snackbar(
            'خطأ في إكمال الملف الشخصي',
            'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  // دالة رفع الصورة إلى Supabase Storage
  Future<String> _uploadImageToSupabase(File imageFile) async {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser?.id;

    if (userId == null) {
      throw Exception('لم يتم العثور على معرف المستخدم');
    }

    // إنشاء اسم فريد للصورة
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'avatar_${userId}_$timestamp.jpg';

    // رفع الصورة إلى bucket الـ avatars
    final response = await Supabase.instance.client.storage
        .from('avatars') // اسم البوكت
        .upload(
          fileName,
          imageFile,
          fileOptions: FileOptions(
            upsert: true, // استبدال الصورة إذا كانت موجودة
            contentType: 'image/jpeg',
          ),
        );

    // الحصول على رابط التحميل العام للصورة
    final String publicUrl = Supabase.instance.client.storage
        .from('avatars')
        .getPublicUrl(fileName);

    return publicUrl;
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
                      children: [
                        SizedBox(height: 20.h),

                        // Header
                        Text(
                          'complete_profile'.tr,
                          style: AppTheme.headingLarge,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          'أكمل ملفك الشخصي للبدء',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 40.h),

                        // Profile picture
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 120.w,
                                height: 120.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: _selectedImage != null
                                    ? ClipOval(
                                        child: Image.file(
                                          _selectedImage!,
                                          width: 120.w,
                                          height: 120.w,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 60.w,
                                        color: Colors.grey[400],
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Full name field
                        CustomTextField(
                          controller: _fullNameController,
                          label: 'full_name'.tr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field_required'.tr;
                            }
                            if (value.trim().length < 2) {
                              return 'name_too_short'.tr;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16.h),

                        // Username field
                        CustomTextField(
                          controller: _usernameController,
                          label: 'username'.tr,
                          hint: 'username_example',
                          suffixIcon: _isUsernameChecking
                              ? const CircularProgressIndicator()
                              : _usernameController.text.length >= 3
                              ? Icon(
                                  _isUsernameAvailable
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _isUsernameAvailable
                                      ? Colors.green
                                      : Colors.red,
                                )
                              : null,
                          onChanged: (value) {
                            if (value.length >= 3) {
                              _checkUsername(value);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field_required'.tr;
                            }
                            if (value.length < 3) {
                              return 'username_too_short'.tr;
                            }
                            if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                              return 'username_invalid'.tr;
                            }
                            return null;
                          },
                        ),

                        if (_usernameController.text.length >= 3 &&
                            !_isUsernameChecking)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _isUsernameAvailable
                                    ? 'username_available'.tr
                                    : 'username_taken'.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: _isUsernameAvailable
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ),

                        SizedBox(height: 16.h),

                        // Bio field
                        CustomTextField(
                          controller: _bioController,
                          label: 'bio'.tr,
                          hint: 'نبذة قصيرة عنك (اختياري)',
                          maxLines: 3,
                          maxLength: 150,
                        ),

                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),

                // Complete button
                Obx(
                  () => CustomButton(
                    text: 'done'.tr,
                    isLoading: authController.isLoading,
                    onPressed: _completeProfile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
