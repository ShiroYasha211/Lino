import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_theme.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppTheme.primaryColor,
          body: const SafeArea(child: _SplashContent()),
        );
      },
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Section
          _AnimatedLogoSection(controller: controller),

          SizedBox(height: 80.h),

          // Loading Section
          _LoadingSection(controller: controller),
        ],
      ),
    );
  }
}

class _AnimatedLogoSection extends StatelessWidget {
  const _AnimatedLogoSection({required this.controller});

  final SplashController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: ScaleTransition(
            scale: controller.scaleAnimation,
            child: child,
          ),
        );
      },
      child: const _LogoContent(),
    );
  }
}

class _LogoContent extends StatelessWidget {
  const _LogoContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App logo
        Container(
          width: 120.w,
          height: 120.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.chat_bubble_rounded,
            size: 60.w,
            color: AppTheme.primaryColor,
          ),
        ),

        SizedBox(height: 24.h),

        // App name
        Text(
          'app_name'.tr,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),

        SizedBox(height: 8.h),

        // App subtitle
        Text(
          'تطبيق دردشة آمن وسريع',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white.withOpacity(0.9),
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection({required this.controller});

  final SplashController controller;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),

          SizedBox(height: 16.h),

          Text(
            'loading'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
