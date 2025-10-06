import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/user_model.dart';
import '../../../core/router/app_pages.dart';

class AuthController extends GetxController {
  final _isLoading = false.obs;
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  final _isProfileComplete = false.obs;
  final _isEmailVerified = false.obs;

  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;
  bool get isProfileComplete => _isProfileComplete.value;
  bool get isEmailVerified => _isEmailVerified.value;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
    _setupAuthListener();
  }

  void _checkAuthState() {
    final user = _supabase.auth.currentUser;
    _isLoggedIn.value = user != null;
    _isEmailVerified.value = user?.emailConfirmedAt != null;
    if (user != null) {
      _loadUserProfile();
    }
  }

  void _setupAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      _isLoggedIn.value = user != null;
      _isEmailVerified.value = user?.emailConfirmedAt != null;

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
      _checkProfileCompletion(_currentUser.value!);
    } catch (e) {
      _isProfileComplete.value = false;
    }
  }

  void _checkProfileCompletion(UserModel user) {
    final isComplete =
        user.fullName.isNotEmpty &&
        user.username.isNotEmpty &&
        _isValidUsername(user.username);

    _isProfileComplete.value = isComplete;
  }

  bool _isValidUsername(String username) {
    // التحقق من أن اسم المستخدم يتبع المعايير الصحيحة
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return username.length >= 3 &&
        username.length <= 20 &&
        usernameRegex.hasMatch(username);
  }

  String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'اسم المستخدم مطلوب';
    }
    if (username.length < 3) {
      return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
    }
    if (username.length > 20) {
      return 'اسم المستخدم يجب أن لا يتجاوز 20 حرف';
    }
    if (!_isValidUsername(username)) {
      return 'اسم المستخدم يجب أن يحتوي على أحرف إنجليزية وأرقام و _ فقط';
    }
    if (username.contains(' ')) {
      return 'اسم المستخدم يجب ألا يحتوي على فراغات';
    }
    return null;
  }

  // Sign in with email and password
  Future<SignInResult> signIn(String email, String password) async {
    try {
      _isLoading.value = true;

      // // التحقق أولاً من وجود البريد الإلكتروني في جدول البروفايل
      // final profileResponse = await _supabase
      //     .from('profiles')
      //     .select('id')
      //     .eq('email', email)
      //     .maybeSingle();

      // if (profileResponse == null) {
      //   return SignInResult.emailNotRegistered;
      // }

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (response.user!.emailConfirmedAt == null) {
          return SignInResult.emailNotVerified;
        }

        await _loadUserProfile();
        return SignInResult.success;
      }

      return SignInResult.unknownError;
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return SignInResult.invalidPassword;
      } else if (e.message.contains('Email not confirmed')) {
        return SignInResult.emailNotVerified;
      } else {
        Get.snackbar(
          'خطأ في تسجيل الدخول',
          e.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        return SignInResult.unknownError;
      }
    } catch (e) {
      Get.snackbar(
        'خطأ في تسجيل الدخول',
        'حدث خطأ غير متوقع',
        snackPosition: SnackPosition.BOTTOM,
      );
      return SignInResult.unknownError;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign up with email and password
  // في دالة signUp، تأكد من أن return type هو SignUpResult
  Future<SignUpResult> signUp(String email, String password) async {
    try {
      _isLoading.value = true;

      // التحقق من وجود البريد الإلكتروني مسبقاً
      final existingUser = await _supabase
          .from('profiles')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (existingUser != null) {
        return SignUpResult.emailAlreadyExists;
      }

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'email': email},
      );

      if (response.user != null) {
        // إنشاء بروفايل أساسي فوراً
        await _createBasicProfile(response.user!.id, email);

        // إذا كان هناك session مباشرة (مفعل مباشرة)
        if (response.session != null) {
          _isEmailVerified.value = true;
          await _loadUserProfile();
          return SignUpResult.success;
        } else {
          // إذا لم يكن هناك session، يحتاج تفعيل البريد
          _isEmailVerified.value = false;
          return SignUpResult.emailNotVerified;
        }
      }

      return SignUpResult.unknownError;
    } on AuthException catch (e) {
      if (e.message.contains('User already registered')) {
        return SignUpResult.emailAlreadyExists;
      } else {
        Get.snackbar(
          'خطأ في إنشاء الحساب',
          e.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        return SignUpResult.unknownError;
      }
    } catch (e) {
      Get.snackbar(
        'خطأ في إنشاء الحساب',
        'حدث خطأ غير متوقع',
        snackPosition: SnackPosition.BOTTOM,
      );
      return SignUpResult.unknownError;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _createBasicProfile(String userId, String email) async {
    try {
      final basicProfile = {
        'id': userId,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('profiles').insert(basicProfile);
    } catch (e) {
      print('Error creating basic profile: $e');
    }
  }

  // Complete user profile
  Future<ProfileCompletionResult> completeProfile({
    required String fullName,
    required String username,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      _isLoading.value = true;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return ProfileCompletionResult.userNotFound;

      // التحقق من صحة اسم المستخدم
      final usernameValidation = validateUsername(username);
      if (usernameValidation != null) {
        Get.snackbar(
          'خطأ في اسم المستخدم',
          usernameValidation,
          snackPosition: SnackPosition.BOTTOM,
        );
        return ProfileCompletionResult.invalidUsername;
      }

      // التحقق من توفر اسم المستخدم
      final isAvailable = await isUsernameAvailable(username);
      if (!isAvailable) {
        return ProfileCompletionResult.usernameTaken;
      }

      // التحقق من صحة الاسم الكامل
      if (fullName.isEmpty || fullName.length < 2) {
        Get.snackbar(
          'خطأ في الاسم الكامل',
          'الاسم الكامل مطلوب ويجب أن يكون على الأقل حرفين',
          snackPosition: SnackPosition.BOTTOM,
        );
        return ProfileCompletionResult.invalidFullName;
      }

      final profileData = {
        'full_name': fullName,
        'username': username.toLowerCase(),
        'email': _supabase.auth.currentUser?.email,
        'bio': bio ?? '',
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('profiles').update(profileData).eq('id', userId);

      await _loadUserProfile();

      return ProfileCompletionResult.success;
    } catch (e) {
      Get.snackbar(
        'خطأ في إكمال الملف الشخصي',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return ProfileCompletionResult.unknownError;
    } finally {
      _isLoading.value = false;
    }
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      if (username.length < 3) return false;

      final response = await _supabase
          .from('profiles')
          .select('username')
          .eq('username', username.toLowerCase())
          .maybeSingle();

      return response == null;
    } catch (e) {
      return false;
    }
  }

  // Resend email verification
  Future<bool> resendEmailVerification() async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: _supabase.auth.currentUser?.email,
      );

      Get.snackbar(
        'تم إرسال رابط التفعيل',
        'تم إرسال رابط تفعيل الحساب إلى بريدك الإلكتروني',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ في إرسال رابط التفعيل',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
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

      if (fullName != null) {
        if (fullName.isEmpty || fullName.length < 2) {
          throw Exception('الاسم الكامل مطلوب ويجب أن يكون على الأقل حرفين');
        }
        updateData['full_name'] = fullName;
      }

      if (bio != null) updateData['bio'] = bio;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      await _supabase.from('profiles').update(updateData).eq('id', userId);

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

  // Check if user needs profile completion
  bool get needsProfileCompletion {
    return isLoggedIn && !isProfileComplete;
  }

  Future<void> reloadUser() async {
    try {
      await _supabase.auth.refreshSession();
      final user = _supabase.auth.currentUser;
      _isEmailVerified.value = user?.emailConfirmedAt != null;
      if (user != null) {
        await _loadUserProfile();
      }
    } catch (e) {
      print('Error reloading user: $e');
    }
  }

  // إعداد مستمع لتغيرات حالة التفعيل
  void setupEmailVerificationListener(Function(User? user) onEmailVerified) {
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      final emailConfirmed = user?.emailConfirmedAt != null;

      _isEmailVerified.value = emailConfirmed;

      if (emailConfirmed) {
        onEmailVerified(user);
      }
    });
  }
}

// نتائج تسجيل الدخول
enum SignInResult {
  success,
  //emailNotRegistered,
  invalidPassword,
  emailNotVerified,
  unknownError,
}

// نتائج إنشاء الحساب

enum SignUpResult {
  success, // نجح وإنشاء session مباشرة
  emailAlreadyExists, // البريد موجود مسبقاً
  emailNotVerified, // نجح ولكن يحتاج تفعيل البريد
  unknownError,
}

// نتائج إكمال البروفايل
enum ProfileCompletionResult {
  success,
  usernameTaken,
  invalidUsername,
  invalidFullName,
  userNotFound,
  unknownError,
}
