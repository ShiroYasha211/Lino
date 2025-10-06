// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const COMPLETE_PROFILE = _Paths.COMPLETE_PROFILE;
  static const SIGNUP = _Paths.SIGNUP;
  static const VERIFY_EMAIL = _Paths.VERIFY_EMAIL;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const COMPLETE_PROFILE = '/complete-profile';
  static const SIGNUP = '/signup';
  static const VERIFY_EMAIL = '/verify-email';
}
