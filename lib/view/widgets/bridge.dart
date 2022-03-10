import 'package:flutter/material.dart';
import 'package:referral/model/user_model.dart';
import 'package:referral/repositories/user_repository.dart';
import 'package:referral/view/screens/home/home_screen.dart';
import '../screens/auth/authentication.dart';

class Bridge extends StatelessWidget {
  const Bridge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel>(
      valueListenable: UserRepository.instance.currentUserNotifier,
      builder: (context, value, widget) {
        if (value != UserModel.empty()) {
          return const HomeWidget();
        } else {
          return const AuthWidget();
        }
      },
    );
  }
}
