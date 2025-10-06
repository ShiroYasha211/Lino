import 'package:get/get.dart';
import 'package:lino_app/view/auth/signup/signup_page.dart';
import 'package:lino_app/view/auth/verify_email/verify_email_view.dart';
import 'package:lino_app/view/home/home.dart';
import 'package:lino_app/view/auth/complete_profile_page.dart/complete_profile.dart';
import 'package:lino_app/view/auth/login/login_view.dart';
import 'package:lino_app/view/splash/view/splash_view.dart';

part 'app_router.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.LOGIN, page: () => const LoginView()),
    GetPage(name: _Paths.SPLASH, page: () => const SplashView()),
    GetPage(name: _Paths.HOME, page: () => Home()),
    GetPage(name: _Paths.COMPLETE_PROFILE, page: () => const CompleteProfile()),
    GetPage(name: _Paths.SIGNUP, page: () => const SignupPage()),
    GetPage(name: _Paths.VERIFY_EMAIL, page: () => const VerifyEmailPage()),
  ];
}
