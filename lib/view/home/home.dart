import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lino_app/view/auth/controller/auth_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final AuthController authController =
      Get.find<AuthController>(); // Get.find<AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text('Home')),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              authController.signOut();
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
