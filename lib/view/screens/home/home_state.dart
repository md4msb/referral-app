import 'package:flutter/material.dart';
import 'package:referral/repositories/user_repository.dart';

class HomeState extends ChangeNotifier {
  final userRepo = UserRepository.instance;
}
