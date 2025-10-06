import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/user_model.dart';
import '../../../core/router/app_pages.dart';
import '../../../core/themes/app_theme.dart';

class AuthController extends GetxController {
  final _isLoading = false.obs;
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  final _isProfileComplete = false.obs;
  final RxString _errorMessage = ''.obs;

  bool get isLoading => _isLoading.value;
  Rx<bool> get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser.value;
  bool get isProfileComplete => _isProfileComplete.value;
  String get errorMessage => _errorMessage.value;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
    _setupAuthListener();
  }

  // Check initial auth state
  void _checkAuthState() {
    final user = _supabase.auth.currentUser;
    _isLoggedIn.value = user != null;
    if (user != null) {
      _loadUserProfile();
    }
  }

  // Listen to auth state changes
  void _setupAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      _isLoggedIn.value = user != null;

      if (user != null) {
        _loadUserProfile();
      } else {
        _currentUser.value = null;
        _isProfileComplete.value = false;
      }
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      _currentUser.value = UserModel.fromMap(response);
      _isProfileComplete.value = true;
    } catch (e) {
      _isProfileComplete.value = false;
    }
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadUserProfile();
        return true;
      }

      return false;
    } on AuthException catch (e) {
      _errorMessage.value = _getErrorMessage(e.message);
      if (_errorMessage.value == "Email not confirmed") {
        verifiedEmailDialog(email);
      } else {
        Get.snackbar(
          'خطأ في تسجيل الدخول',
          _errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'خطأ في تسجيل الدخول',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign up with email and password
  Future<bool> signUp(String email, String password) async {
    try {
      _isLoading.value = true;
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      completeSignUpDialog(email);
      return response.user != null;
    } on AuthException catch (e) {
      Get.snackbar(
        'خطأ في إنشاء الحساب',
        _getErrorMessage(e.message),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'خطأ في إنشاء الحساب',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Complete user profile
  Future<bool> completeProfile({
    required String fullName,
    required String username,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      _isLoading.value = true;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final profileData = {
        'id': userId,
        'full_name': fullName,
        'username': username,
        'bio': bio ?? '',
        'email': _supabase.auth.currentUser!.email,
        'avatar_url': avatarUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('profiles').insert(profileData);

      _currentUser.value = UserModel.fromMap(profileData);
      _isProfileComplete.value = true;

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ في إكمال الملف الشخصي',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final response = await _supabase.rpc(
        'is_username_available',
        params: {'username_to_check': username},
      );

      return response as bool;
    } catch (e) {
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'خطأ في تسجيل الخروج',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? fullName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      _isLoading.value = true;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (bio != null) updateData['bio'] = bio;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      await _supabase.from('profiles').update(updateData).eq('id', userId);

      // Reload profile
      await _loadUserProfile();

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ في تحديث الملف الشخصي',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Helper to get user-friendly error messages
  String _getErrorMessage(String message) {
    const errorMap = {
      'Invalid login credentials': 'بيانات الدخول غير صحيحة',
      'User is banned': 'المستخدم محظور',
      'User already registered': 'المستخدم مسجل بالفعل',
      'Weak password': 'كلمة المرور ضعيفة',
      'Connection closed': 'خطاء فى الشبكه حاول مجددا',
    };

    return errorMap[message] ?? message;
  }

  // Dialog to inform user to verify their email
  void verifiedEmailDialog(String email) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 40,
                  color: Colors.orange,
                ),
              ),

              SizedBox(height: 16),

              Text(
                'تفعيل البريد المطلوب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

              Text(
                'يجب تفعيل بريدك الإلكتروني قبل تسجيل الدخول. تم إرسال رابط التفعيل إلى',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),

              SizedBox(height: 8),

              Text(
                email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),

              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تحقق من مجلد الرسائل غير المرغوب فيها إذا لم تجد البريد',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text('إلغاء'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _resendVerificationEmail(email);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: Text(
                        'إعادة الإرسال',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Dialog to inform user that sign up is complete
  void completeSignUpDialog(email) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 40, color: Colors.green),
              ),
              SizedBox(height: 16),
              Text(
                'تم إنشاء الحساب بنجاح',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'تم إنشاء حسابك بنجاح..',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                'يجب تفعيل بريدك الإلكتروني قبل تسجيل الدخول. تم إرسال رابط التفعيل إلى',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),

              SizedBox(height: 8),

              Text(
                email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),

              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تحقق من مجلد الرسائل غير المرغوب فيها إذا لم تجد البريد',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.offAllNamed(Routes.LOGIN);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: Text('تسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Resend verification email
  Future<void> _resendVerificationEmail(String email) async {
    try {
      // عرض مؤشر تحميل
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // إعادة إرسال رابط التفعيل
      await _supabase.auth.resend(type: OtpType.signup, email: email);

      // إغلاق مؤشر التحميل
      Get.back();

      // عرض رسالة نجاح
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('تم الإرسال'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تم إعادة إرسال رابط التفعيل إلى بريدك الإلكتروني بنجاح.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('حسناً'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      // إغلاق مؤشر التحميل في حالة الخطأ
      Get.back();

      Get.snackbar(
        'خطأ في إرسال رابط التفعيل',
        'فشل في إعادة إرسال رابط التفعيل. يرجى المحاولة مرة أخرى.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
